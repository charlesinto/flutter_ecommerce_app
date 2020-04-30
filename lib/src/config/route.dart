import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/pages/home_page.dart';
import 'package:flutter_ecommerce_app/src/pages/loginPage.dart';
import 'package:flutter_ecommerce_app/src/pages/mainPage.dart';
import 'package:flutter_ecommerce_app/src/pages/payment.dart';
import 'package:flutter_ecommerce_app/src/pages/paystack.dart';
import 'package:flutter_ecommerce_app/src/pages/product_detail.dart';

class Routes{
  static Map<String,WidgetBuilder> getRoute(){
    return  <String, WidgetBuilder>{
          '/home': (_) => MainPage(),
          '/app': (_) => MyHomePage(),
          '/detail': (_) => ProductDetailPage(),
          '/login': (_) => LoginPage(),
          '/payment': (_) => Payment(),
          '/paystack': (_) => PayStackApp()
        };
  }
}