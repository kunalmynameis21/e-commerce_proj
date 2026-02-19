import 'package:ecommerce_pro/homeScreen_page.dart';
import 'package:ecommerce_pro/product_Models.dart';
import 'package:ecommerce_pro/product_provider.dart';
import 'package:ecommerce_pro/screen-demo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ProductDetailScreen.dart';

void main(){
  MultiProvider(
    providers: [


      ChangeNotifierProvider(create: (_) => ProductProvider()),
      // ChangeNotifierProvider(create: (_) => CartProvider()..loadCart()),
    ],
    child: const MyApp(),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Myscreen()
    );
  }
}
