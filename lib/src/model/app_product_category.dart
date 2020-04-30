

import 'package:flutter/cupertino.dart';

class ProductCategory{
  final int createdAt;
  final int updatedAt;
  final int id;
  final String name;
  bool isSelected = false;
  String image;
  final int commissionPercentage;
  final int commissionMaxAmount;
  final int owner;

  ProductCategory({this.createdAt, this.updatedAt, @required this.id, this.name, this.commissionMaxAmount, 
  this.commissionPercentage, this.owner});
}

/*
"category": {
        "createdAt": 1583400633272,
        "updatedAt": 1583400633272,
        "id": 4,
        "name": "Clothings",
        "commissionPercentage": 24,
        "commissionMaxAmount": 1000,
        "owner": 2
      }
"subCategory": {
        "createdAt": 1583400672712,
        "updatedAt": 1583400672712,
        "id": 7,
        "name": "Hat",
        "commissionPercentage": 12,
        "commissionMaxAmount": 2000,
        "owner": 2,
        "parentCategory": 4
      }

*/