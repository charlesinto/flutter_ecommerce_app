

import 'package:flutter/cupertino.dart';
import 'package:flutter_ecommerce_app/src/model/app_product.dart';

class AppStateProducts{
  final List<AppProduct> featuredProducts;
  final List<AppProduct> homeProducts;
  
  AppStateProducts({@required this.featuredProducts, @required this.homeProducts});
}