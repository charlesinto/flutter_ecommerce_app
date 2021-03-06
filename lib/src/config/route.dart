import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/pages/advert.dart';
import 'package:flutter_ecommerce_app/src/pages/azonka_pay.dart';
import 'package:flutter_ecommerce_app/src/pages/customer_service.dart';
import 'package:flutter_ecommerce_app/src/pages/home_page.dart';
import 'package:flutter_ecommerce_app/src/pages/loginPage.dart';
import 'package:flutter_ecommerce_app/src/pages/mainPage.dart';
import 'package:flutter_ecommerce_app/src/pages/payment.dart';
import 'package:flutter_ecommerce_app/src/pages/paystack.dart';
import 'package:flutter_ecommerce_app/src/pages/product_detail.dart';
import 'package:flutter_ecommerce_app/src/pages/search_page.dart';
import 'package:flutter_ecommerce_app/src/pages/sellerProduct.dart';
import 'package:flutter_ecommerce_app/src/pages/settings.dart';
import 'package:flutter_ecommerce_app/src/pages/signupPage.dart';
import 'package:flutter_ecommerce_app/src/pages/store.dart';
import 'package:flutter_ecommerce_app/src/pages/verify_account_page.dart';
import 'package:flutter_ecommerce_app/src/pages/walletPage.dart';

class Routes{
  static Map<String,WidgetBuilder> getRoute(){
    return  <String, WidgetBuilder>{

          '/home': (_) => MainPage(),
          '/app': (_) => MyHomePage(),
          '/detail': (_) => ProductDetailPage(),
          '/login': (_) => LoginPage(),
          '/payment': (_) => Payment(),
          '/paystack': (_) => PayStackApp(),
          '/signup': (_) => SignupPage(),
          '/verifyAccount': (_) => VerifyAccount(),
          '/wallet': (_) => WalletPage(),
          '/settings': (_) => Settings(),
          '/search': (_) => SearchPage(),
          '/customerService': (_) => CustomerService(),
          '/azonkapay': (_) => AzonkaPay(),
          '/store': (_) => SellerStore(),
          '/sellerProducts': (_) => SellerProduct(),
          '/advert': (_) => AdvertPage()
        };
  }
}