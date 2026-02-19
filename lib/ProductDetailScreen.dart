import 'package:ecommerce_pro/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_Models.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductDetails product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: Image.network(
                product.image ?? "",
                height: 250,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              product.title ?? "",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "\$${product.price?.toStringAsFixed(2) ?? '0.00'}",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange),
                const SizedBox(width: 5),
                Text(
                  "${product.rating?.rate?.toStringAsFixed(1) ?? "0"} (${product.rating?.count ?? 0} reviews)",
                ),

                const SizedBox(height: 30),

                Consumer<CartProvider>(
                  builder: (context, cart, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          cart.addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Added to Cart")),
                          );
                        },
                        child: const Text("Add to Cart"),
                      ),
                    );
                  },
                ),

              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Description",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 8),

            Text(product.description ?? ""),
          ],
        ),
      ),
    );
  }
}
