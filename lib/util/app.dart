import 'dart:convert';

import 'package:flutter_ecommerce_app/src/model/app_product.dart';
import 'package:flutter_ecommerce_app/src/model/app_product_appstore.dart';
import 'package:flutter_ecommerce_app/src/model/app_product_category.dart';
import 'package:flutter_ecommerce_app/src/model/app_product_owner.dart';
import 'package:flutter_ecommerce_app/src/model/app_product_subcategory.dart';
import 'package:http/http.dart' as http;
import './constants.dart';

class App{

  static Future<List<AppProduct>> getProducts(String url) async{
    List<AppProduct> _products = List<AppProduct>();
    final response = await http.get(appDomain+ url);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print('here 2');
      // print(json.decode(response.body).toString());
      // SharedPreferences
      try{

       
      var _serverResponse = json.decode(response.body);
      List<dynamic> products = _serverResponse['products'];

      products.forEach((product) {
        ProductCategory category = ProductCategory(id:product['category']['id'],commissionMaxAmount:product['category']['commissionMaxAmount'] ,
          commissionPercentage:product['category']['commissionPercentage'] ,createdAt:product['category']['createdAt'] ,name: product['category']['name'],
          owner: product['category']['owner'],updatedAt: product['category']['updatedAt'] );
        
        SubCategory _subCategory = SubCategory(id: product['subCategory']['id'], updatedAt: product['subCategory']['updatedAt'],owner: product['subCategory']['owner'],
                 name: product['subCategory']['name'] , createdAt:product['subCategory']['createdAt'] ,commissionPercentage: product['subCategory']['commissionPercentage'], 
                 commissionMaxAmount: product['subCategory']['commissionMaxAmount'],parentCategory: product['subCategory']['parentCategory']);
                 
        Store _store = Store(createdAt: product['store']['createdAt'] , name: product['store']['name'], owner: product['store']['owner'], updatedAt:product['store']['updatedAt'] , active: product['store']['active'],
                 address:product['store']['address'] ,blockedReason: product['store']['blockedReason'],country:product['store']['country'] ,headerImageUrl: product['store']['headerImageUrl'],
                 id: product['store']['id'],isoCode: product['store']['name'],
                 otherImageUrl:product['store']['otherImageUrl'] ,state:product['store']['state']);
        
        Owner _owner = Owner(id: product['owner']['id'], emailAddress: product['owner']['emailAddress'], 
            firstName: product['owner']['firstName'], lastName: product['owner']['lastName'], phoneNumber: product['owner']['phoneNumber'], country: product['owner']['country']);
        

        AppProduct appProduct = AppProduct(createdAt: product['createdAt'],
             id: product['id'], name: product['name'], model: product['model'], description:
              product['description'], year: product['year'], mainImageUrl: product['mainImageUrl'], sellingPrice:
               product['sellingPrice'], costPrice: product['costPrice'], discounts: product['discounts'], finalPrice: 
               product['finalPrice'], deliveryDays: product['deliveryDays'], deliveryLocation: product['deliveryLocation'],
                deliveryType: product['deliveryType'], rating: product['rating'], blockedReason: product['blockedReason'],
                 isBlocked: product['isBlocked'], homepage: product['homepage'], homePageUntil: product['homePageUntil'], 
                 featured: product['featured'], featuredUntil: product['featuredUntil'], owner: _owner, agent: product['agent'],
                  adCategory: product['adCategory'], category: category, subCategory: _subCategory, store: _store);
        
        _products.add(appProduct);
      });
      // print(json.decode(response.body));
      return _products;
      }catch(error){
        print(error);
        return _products;
      }
      
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load products');
    }
  }
  static getFlashSales(){

  }
}