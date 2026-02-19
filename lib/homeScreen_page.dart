import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ProductDetailScreen.dart';
import 'product_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Add a GlobalKey for the RefreshIndicator
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    // Call API after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).getApiProduct();
    });
  }

  // Method to handle refresh
  Future<void> _handleRefresh() async {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    await provider.getApiProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          // Add refresh button for testing
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<ProductProvider>(
                context,
                listen: false,
              ).getApiProduct();
            },
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          // Show loading indicator
          if (provider.isLoading && provider.productList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error message
          if (provider.errorMessage != null && provider.productList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.getApiProduct();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Show empty state
          if (provider.productList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    "No products available",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      provider.getApiProduct();
                    },
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          // Show products with pull-to-refresh
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _handleRefresh,
            color: Colors.blue,
            // Customize the color
            backgroundColor: Colors.white,
            // Customize background color
            strokeWidth: 2.0,
            // Customize stroke width
            child:
            // Show products with pull-to-refresh
             RefreshIndicator.adaptive(  // ← Replace your existing RefreshIndicator with this
            onRefresh: _handleRefresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                final product = provider.productList[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (_) => ProductDetailScreen(product: product),
                    //     ),
                    //   );
                    // },
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: product.image != null
                          ? Image.network(
                        product.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported),
                      )
                          : const Icon(Icons.image),
                    ),
                    title: Text(product.title ?? 'No title'),
                    subtitle: Text(
                      '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      '★ ${product.rating?.rate?.toStringAsFixed(1) ?? "0"}',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },

            ),

          )
          );
        },
      ),
    );
  }
}
