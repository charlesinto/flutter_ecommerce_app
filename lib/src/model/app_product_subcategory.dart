
import 'package:flutter/cupertino.dart';

class SubCategory{
  final int createdAt; 
  final int updatedAt; 
  final int id;
  final String name;
  final int commissionPercentage;
  final int commissionMaxAmount; 
  final int owner;
  final int parentCategory;

  SubCategory({this.createdAt, this.updatedAt,@required this.id, this.name, this.commissionPercentage, this.commissionMaxAmount,
  this.owner, this.parentCategory});
}

/*

        "createdAt": 1583400672712,
        "updatedAt": 1583400672712,
        "id": 7,
        "name": "Hat",
        "commissionPercentage": 12,
        "commissionMaxAmount": 2000,
        "owner": 2,
        "parentCategory": 4

*/