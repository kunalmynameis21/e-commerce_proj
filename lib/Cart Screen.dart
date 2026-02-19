import 'package:ecommerce_pro/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Consumer<CartProvider>(
          builder: (context, cart, child) =>
              Text("Cart (${cart.totalItems})"),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {

          if (cart.cartItems.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("Your Cart is Empty",
                      style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          return Column(
            children: [

              Expanded(
                child: ListView.builder(
                  itemCount: cart.cartItems.length,
                  itemBuilder: (context, index) {

                    final item = cart.cartItems[index];

                    return ListTile(
                      leading: Image.network(
                        item.product.image ?? "",
                        width: 50,
                      ),
                      title: Text(item.product.title ?? ""),
                      subtitle: Text(
                          "\$${item.totalPrice.toStringAsFixed(2)}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () =>
                                cart.decreaseQty(item.product.id!),
                          ),

                          Text(item.quantity.toString()),

                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () =>
                                cart.increaseQty(item.product.id!),
                          ),

                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () =>
                                cart.removeFromCart(item.product.id!),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide()),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total:",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text(
                      "\$${cart?.totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
