

import 'package:flutter/cupertino.dart';
import 'package:flutter_ecommerce_app/src/model/app_adProduct.dart';
import 'package:flutter_ecommerce_app/src/model/app_cartlist.dart';
import 'package:flutter_ecommerce_app/src/model/app_product.dart';
import 'package:flutter_ecommerce_app/src/model/app_product_category.dart';
import 'package:flutter_ecommerce_app/src/model/app_state_products.dart';
import 'package:flutter_ecommerce_app/src/model/app_user.dart';

class AppState{
  int selectedTabIndex = 0;
  AppStateProducts appStateProducts;
  AppProduct selectedProduct;
  int bottomIconIndex = 0;
  List<AppProduct> cart = [];
  Cart userCart = Cart(products: []);
  List<int> modifiedCartItems = [];
  ProductCategory searchCategory;
  String searchString = "";
  AppState({@required this.selectedTabIndex, this.appStateProducts});
  User user;
  List<AppProduct> searchResult = [];
  AppState.fromAppState(AppState anotherState){
    selectedTabIndex = anotherState.selectedTabIndex;
    appStateProducts = anotherState.appStateProducts;
    selectedProduct = anotherState.selectedProduct;
    cart = anotherState.cart;
    bottomIconIndex = anotherState.bottomIconIndex;
    user = anotherState.user;
    userCart = anotherState.userCart;
    modifiedCartItems = anotherState.modifiedCartItems;
    searchCategory = anotherState.searchCategory;
    searchString = anotherState.searchString;
    searchResult = anotherState.searchResult;
  }
}