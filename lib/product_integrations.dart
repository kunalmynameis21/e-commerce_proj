import 'dart:convert';
import 'dart:io';
import 'package:ecommerce_pro/product_Models.dart';
import 'package:http/http.dart' as http;

class ProductIntegrations {

 static const String _baseUrl = "https://fakestoreapi.com/products";

 Future<List<ProductDetails>> getCoProduct() async {
  try {
   final uri = Uri.parse(_baseUrl);

   final response = await http
       .get(uri)
       .timeout(const Duration(seconds: 10));

   if (response.statusCode == 200) {

    final List<dynamic> decoded = jsonDecode(response.body);

    return decoded
        .map((e) =>
        ProductDetails.fromJson(e as Map<String, dynamic>))
        .toList();

   } else {
    throw HttpException(
     "Server error: ${response.statusCode}",
    );
   }

  } on http.ClientException {
   throw Exception("No Internet Connection");
  } on FormatException {
   throw Exception("Invalid response format");
  } catch (e) {
   throw Exception("Unexpected error: $e");
  }
 }
}
