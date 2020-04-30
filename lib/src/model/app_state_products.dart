

import 'package:flutter/cupertino.dart';
import 'package:flutter_ecommerce_app/src/model/app_advert_product.dart';
import 'package:flutter_ecommerce_app/src/model/app_cartlist.dart';
import 'package:flutter_ecommerce_app/src/model/app_product.dart';
import 'package:flutter_ecommerce_app/src/model/app_product_category.dart';

class AppStateProducts{
  final List<AppProduct> featuredProducts;
  final List<AppProduct> homeProducts;
  final List<ProductCategory> categories;
  final List<AdvertProduct> advertCategory;
  Cart cart;
  AppStateProducts({@required this.featuredProducts, @required this.homeProducts, this.categories,
      @required this.advertCategory, @required this.cart,});
}