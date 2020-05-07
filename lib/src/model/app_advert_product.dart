

import 'package:flutter/cupertino.dart';
import 'package:flutter_ecommerce_app/src/model/app_adProduct.dart';
import 'package:flutter_ecommerce_app/src/model/app_product.dart';

class AdvertProduct{
    final List<AppProduct> productAd;
    final String name;
    final int id;
    final int createdAt;
    final int updatedAt;

    AdvertProduct({@required this.id,@required this.createdAt,@required this.name,
      @required this.productAd, @required this.updatedAt});

}