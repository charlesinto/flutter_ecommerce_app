

import 'package:flutter_ecommerce_app/src/model/app_adProduct.dart';
import 'package:flutter_ecommerce_app/src/model/app_product.dart';
import 'package:flutter/cupertino.dart';

class Cart {
  List<AppProduct> products = [];
  Cart({@required this.products});
}