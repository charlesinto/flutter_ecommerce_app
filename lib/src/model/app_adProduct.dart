import 'package:flutter/cupertino.dart';

class ProductAd{
  final int createdAt;
  final int updatedAt;
  final int id;
  final String name;
  final String description;
  final String model;
  final int year;
  final String mainImageUrl;
  final String otherImageUrl1;
  final String otherImageUrl2;
  final String otherImageUrl3;
  final String otherImageUrl4;
  final int sellingPrice;
  final int costPrice;
  final bool discounts;
  final int finalPrice;
  final String deliveryType;
  final String deliveryLocation;
  final int deliveryDays;
  final int rating;
  final bool homepage;
  final int homePageUntil;
  final bool featured;
  final int featuredUntil; 
  final bool isBlocked;
  final String blockedReason;
  final int owner;
  final int agent;
  bool isSelected = false;
  bool isLiked = false;
  int orderNumber = 0;
  final int adCategory;
  final int category;
  final int subCategory;
  final int store;
  
  ProductAd({@required this.createdAt, this.updatedAt, @required this.id, @required this.name,
    @required this.model, @required this.description, @required this.year, @required this.mainImageUrl,
    this.otherImageUrl1, this.otherImageUrl2, this.otherImageUrl3, this.otherImageUrl4, @required this.sellingPrice,
    @required this.costPrice, @required this.discounts, @required this.finalPrice,@required this.deliveryDays,
     @required this.deliveryLocation,@required this.deliveryType, @required this.rating,@required this.blockedReason,@required this.isBlocked,@required this.homepage,
     @required this.homePageUntil,@required this.featured,@required this.featuredUntil,@required this.owner,@required this.agent,@required this.adCategory,@required this.category,@required this.subCategory,
    @required this.store, this.orderNumber});

}