
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ecommerce_app/src/model/app_product_appstore.dart';
import 'package:flutter_ecommerce_app/src/model/app_product_owner.dart';
import 'package:flutter_ecommerce_app/src/model/app_product_subcategory.dart';
import 'package:flutter_ecommerce_app/src/model/app_product_category.dart';

class AppProduct{
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
  final Owner owner;
  final int agent;
  bool isSelected = false;
  bool isLiked = false;
  final int adCategory;
  final ProductCategory category;
  final SubCategory subCategory;
  final Store store;

  AppProduct({@required this.createdAt, this.updatedAt, @required this.id, @required this.name,
    @required this.model, @required this.description, @required this.year, @required this.mainImageUrl,
    this.otherImageUrl1, this.otherImageUrl2, this.otherImageUrl3, this.otherImageUrl4, @required this.sellingPrice,
    @required this.costPrice, @required this.discounts, @required this.finalPrice,@required this.deliveryDays,
     @required this.deliveryLocation,@required this.deliveryType, @required this.rating,@required this.blockedReason,@required this.isBlocked,@required this.homepage,
     @required this.homePageUntil,@required this.featured,@required this.featuredUntil,@required this.owner,@required this.agent,@required this.adCategory,@required this.category,@required this.subCategory,
    @required this.store});
}

/*
    {
      "createdAt": 1583400981126,
      "updatedAt": 1583760841439,
      "id": 1,
      "name": "cap",
      "description": "-",
      "brandName": "vixion",
      "model": "-",
      "year": 0,
      "mainImageUrl": "https://azonka.nyc3.digitaloceanspaces.com/storeItems/1038269886.jpg",
      "otherImageUrl1": "",
      "otherImageUrl2": "",
      "otherImageUrl3": "",
      "otherImageUrl4": "",
      "sellingPrice": 2000,
      "costPrice": 0,
      "discounts": true,
      "finalPrice": 1850,
      "deliveryType": "pick-up",
      "deliveryLocation": "state",
      "deliveryDays": null,
      "rating": 0,
      "homePage": true,
      "homePageUntil": 1594290000000,
      "featured": true,
      "featuredUntil": 1605190000000,
      "isBlocked": false,
      "blockedReason": "",
      "owner": {
        "createdAt": 1583397807975,
        "updatedAt": 1587197906291,
        "id": 1,
        "emailAddress": "md@example.com",
        "firstName": "super",
        "lastName": "tester",
        "phoneNumber": "8163113450",
        "countryCode": "234",
        "type": "seller",
        "gender": "Male",
        "profileImage": "",
        "country": "Nigeria",
        "isoCode": "NG",
        "isBlocked": false,
        "blockedReason": "",
        "referralCode": "WCHAAJAX",
        "agentIdentification": "",
        "agentApproved": false,
        "companyName": "c&sons limited",
        "headOfficeAddress": "Lekki Phase 1",
        "contactLine": "09010502030",
        "sellerIdentification": "",
        "sellerApproved": false,
        "pinSet": true,
        "rating": 0,
        "passwordResetToken": "0",
        "passwordResetTokenExpiresAt": 0,
        "emailProofToken": 0,
        "emailProofTokenExpiresAt": 0,
        "emailVerified": true,
        "tosAcceptedByIp": "::ffff:105.112.179.181",
        "lastSeenAt": 1587200000000,
        "referredBy": null,
        "sellerAgent": null
      },
      "agent": null,
      "category": {
        "createdAt": 1583400633272,
        "updatedAt": 1583400633272,
        "id": 4,
        "name": "Clothings",
        "commissionPercentage": 24,
        "commissionMaxAmount": 1000,
        "owner": 2
      },
      "subCategory": {
        "createdAt": 1583400672712,
        "updatedAt": 1583400672712,
        "id": 7,
        "name": "Hat",
        "commissionPercentage": 12,
        "commissionMaxAmount": 2000,
        "owner": 2,
        "parentCategory": 4
      },
      "adCategory": 3,
      "store": {
        "createdAt": 1583398323910,
        "updatedAt": 1583398323910,
        "id": 1,
        "name": "May hill hotel",
        "address": "Lekki Phase 1",
        "headerImageUrl": "",
        "otherImageUrl": "",
        "state": "Lagos",
        "country": "Nigeria",
        "isoCode": "234",
        "active": true,
        "blockedReason": "",
        "owner": 1
      }
    }



*/