import 'package:ecommerce_pro/product_Models.dart';
import 'package:ecommerce_pro/product_integrations.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'product_Models.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'product_Models.dart';


class ProductProvider with ChangeNotifier {

  List<ProductDetails> _productList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductDetails> get productList => _productList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> getApiProduct() async {

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ProductIntegrations().getCoProduct();

      _productList = response; // ✅ Replace list (not addAll)

    } catch (e) {
      _errorMessage = "Failed to load products";
    }

    _isLoading = false;
    notifyListeners(); // ✅ Only once at end
  }

  void clearProducts() {
    _productList.clear();
    notifyListeners();
  }

  ProductDetails? getProductById(int id) {
    try {
      return _productList.firstWhere((product) => product.id == id);
    } catch (_) {
      return null;
    }

  }
  // In your ProductProvider class, you might want to add this method
  Future<void> refreshProducts() async {
    // Clear existing data and show loading
    productList.clear();
    _isLoading = true;
    notifyListeners();

    // Fetch new data
    await getApiProduct();
  }

}




class CartProvider with ChangeNotifier {

  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  int get totalItems =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  // ---------------- ADD TO CART ----------------
  void addToCart(ProductDetails product) {
    final index = _cartItems.indexWhere((e) => e.product.id == product.id);

    if (index >= 0) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(CartItem(product: product));
    }

    _saveCart();
    notifyListeners();
  }

  // ---------------- REMOVE ----------------
  void removeFromCart(int productId) {
    _cartItems.removeWhere((e) => e.product.id == productId);
    _saveCart();
    notifyListeners();
  }

  // ---------------- INCREASE ----------------
  void increaseQty(int productId) {
    final item =
    _cartItems.firstWhere((e) => e.product.id == productId);
    item.quantity++;
    _saveCart();
    notifyListeners();
  }

  // ---------------- DECREASE ----------------
  void decreaseQty(int productId) {
    final item =
    _cartItems.firstWhere((e) => e.product.id == productId);

    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _cartItems.remove(item);
    }

    _saveCart();
    notifyListeners();
  }

  // ---------------- SAVE LOCAL ----------------
  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _cartItems.map((e) => jsonEncode(e.toJson())).toList();
    prefs.setStringList("cart", data);
  }

  // ---------------- LOAD LOCAL ----------------
  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList("cart");

    if (data != null) {
      _cartItems = data
          .map((e) => CartItem.fromJson(jsonDecode(e)))
          .toList();
      notifyListeners();
    }
  }
}
