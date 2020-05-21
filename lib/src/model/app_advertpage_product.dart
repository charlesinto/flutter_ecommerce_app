import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/model/app_product.dart';

class AdvertPageProduct{
  final List<AppProduct> newArrival;
  final List<AppProduct> productYouMayLike;

  AdvertPageProduct({@required this.newArrival, @required this.productYouMayLike});
}