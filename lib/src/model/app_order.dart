

import 'package:flutter/cupertino.dart';
import 'package:flutter_ecommerce_app/src/model/app_address.dart';
import 'package:flutter_ecommerce_app/src/model/app_product.dart';

class Order{
  final List<AppProduct> products;
  final Address address;
  final String addressString;
  final int owner;
  final int totalAmount;
  final String status;
  final int createdAt;
  final int id;

  Order({@required this.products, @required this.id, @required this.address, @required this.addressString, 
    @required this.owner, @required this.createdAt, @required this.status, @required this.totalAmount});
}