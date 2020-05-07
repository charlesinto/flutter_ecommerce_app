import 'dart:convert';

import 'package:flutter_ecommerce_app/src/model/app_adProduct.dart';
import 'package:flutter_ecommerce_app/src/model/app_address.dart';
import 'package:flutter_ecommerce_app/src/model/app_advert_product.dart';
import 'package:flutter_ecommerce_app/src/model/app_cartlist.dart';
import 'package:flutter_ecommerce_app/src/model/app_order.dart';
import 'package:flutter_ecommerce_app/src/model/app_product.dart';
import 'package:flutter_ecommerce_app/src/model/app_product_appstore.dart';
import 'package:flutter_ecommerce_app/src/model/app_product_category.dart';
import 'package:flutter_ecommerce_app/src/model/app_product_owner.dart';
import 'package:flutter_ecommerce_app/src/model/app_product_subcategory.dart';
import 'package:flutter_ecommerce_app/src/model/app_question.dart';
import 'package:flutter_ecommerce_app/src/model/app_transaction.dart';
import 'package:flutter_ecommerce_app/src/model/app_user.dart';
import 'package:flutter_ecommerce_app/src/model/app_wallet.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './constants.dart';

class App{
  SharedPreferences _preferences;
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
  static Future<List<AdvertProduct>> getProductAdvertCategories() async{
      List<AdvertProduct> adCatgeories = List<AdvertProduct>();
      try{
        final response = await http.get(appDomain + '/api/v1/ad-category/get-ad-categories/0/20');
        if (response.statusCode == 200) {
          var _res = json.decode(response.body);
          List<dynamic> _adcategories = _res['adCategories'];
          _adcategories.forEach((category) { 
            List<AppProduct> _productAdd = List<AppProduct>();
            category['products'].forEach((product) async {
              
              var _res = await http.get(appDomain + "/api/v1/seller/product/get/${product["id"]}");
              var _product_detail = json.decode(_res.body)['product'];
              

              ProductCategory category = ProductCategory(id:_product_detail['category']['id'],commissionMaxAmount:_product_detail['category']['commissionMaxAmount'] ,
                commissionPercentage:_product_detail['category']['commissionPercentage'] ,createdAt:_product_detail['category']['createdAt'] ,name: _product_detail['category']['name'],
                owner: _product_detail['category']['owner'],updatedAt: _product_detail['category']['updatedAt'] );
              
              SubCategory _subCategory = SubCategory(id: _product_detail['subCategory']['id'], updatedAt: _product_detail['subCategory']['updatedAt'],owner: _product_detail['subCategory']['owner'],
                      name: _product_detail['subCategory']['name'] , createdAt:_product_detail['subCategory']['createdAt'] ,commissionPercentage: _product_detail['subCategory']['commissionPercentage'], 
                      commissionMaxAmount: _product_detail['subCategory']['commissionMaxAmount'],parentCategory: _product_detail['subCategory']['parentCategory']);
                     
              Store _store = Store(createdAt: _product_detail['store']['createdAt'] , name: _product_detail['store']['name'], owner: _product_detail['store']['owner'], updatedAt:_product_detail['store']['updatedAt'] , active: _product_detail['store']['active'],
                      address:_product_detail['store']['address'] ,blockedReason: _product_detail['store']['blockedReason'],country:_product_detail['store']['country'] ,headerImageUrl: _product_detail['store']['headerImageUrl'],
                      id: _product_detail['store']['id'],isoCode: _product_detail['store']['name'],
                      otherImageUrl:_product_detail['store']['otherImageUrl'] ,state:_product_detail['store']['state']);
              
              Owner _owner = Owner(id: _product_detail['owner']['id'], emailAddress: _product_detail['owner']['emailAddress'], 
                  firstName: _product_detail['owner']['firstName'], lastName: _product_detail['owner']['lastName'], phoneNumber: _product_detail['owner']['phoneNumber'], country: _product_detail['owner']['country']);
              
              _productAdd.add(
                AppProduct(createdAt: _product_detail['createdAt'],
                  id: _product_detail['id'], name: _product_detail['name'], model: _product_detail['model'], description:
                    _product_detail['description'], year: _product_detail['year'], mainImageUrl: _product_detail['mainImageUrl'], sellingPrice:
                    _product_detail['sellingPrice'], costPrice: _product_detail['costPrice'], discounts: _product_detail['discounts'], finalPrice: 
                    _product_detail['finalPrice'], deliveryDays: _product_detail['deliveryDays'], deliveryLocation: _product_detail['deliveryLocation'],
                      deliveryType: _product_detail['deliveryType'], rating: _product_detail['rating'], blockedReason: _product_detail['blockedReason'],
                      isBlocked: _product_detail['isBlocked'], homepage: _product_detail['homepage'], homePageUntil: _product_detail['homePageUntil'], 
                      featured: _product_detail['featured'], featuredUntil: _product_detail['featuredUntil'], owner: _owner, 
                      agent: _product_detail['agent'],
                        adCategory: _product_detail['adCategory'], category: category, subCategory: _subCategory,
                        store: _store)
              );
              
            });
            // adCatgeories.add(
            //   ProductAd(createdAt: null, id: null, name: null, model: null, description: null, year: null, mainImageUrl: null, sellingPrice: null, costPrice: null, discounts: null, finalPrice: null, deliveryDays: null, deliveryLocation: null, deliveryType: null, rating: null, blockedReason: null, isBlocked: null, homepage: null, homePageUntil: null, featured: null, featuredUntil: null, owner: null, agent: null, adCategory: null, category: null, subCategory: null, store: null)
            // );
            adCatgeories.add(
                AdvertProduct(createdAt: category['createdAt'] ,name:
                  category['name'] ,updatedAt:category['updatedAt'] ,id: category['id'] ,
                  productAd: _productAdd ,)
              );
          });
          return adCatgeories;
        }else{
          throw Exception('Failed to load categories');
        }
      }catch(error){
        print('>>>: '+ error);
        throw Exception('Failed to load categories');
      }
  }
  static Future<List<ProductCategory>> getProductCategories() async{
      List<ProductCategory> catgeories = List<ProductCategory>();
      
      try{
        final response = await http.get(appDomain + '/api/v1/category/get-categories/0/20');
        if (response.statusCode == 200) {
          var _res = json.decode(response.body);
          List<dynamic> productCatgories = _res['categories'];
          productCatgories.forEach((category) { 
            catgeories.add(
              ProductCategory(id: category['id'] ,updatedAt:category['updatedAt'] ,owner:category['owner'] ,
              name:category['name'] ,createdAt:category['createdAt'] ,commissionMaxAmount:category['commissionMaxAmount'] ,
              commissionPercentage: category['commissionPercentage'] ,)
            );

          });
          return catgeories;
        }else{
          throw Exception('Failed to load categories');
        }
      }catch(error){
        print(error);
        throw Exception('Failed to load categories');
      }
  }
  static String formatAsMoney(int price ){
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: price.toDouble());
    return fmf.output.withoutFractionDigits;
  }

  static Future<User> getCurrentUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var user = prefs.getString('user');
    var data = json.decode(user);

    return User(firstName: data['firstName'], lastName: data['lastName'], 
                email: data['email'], phoneNumber: data['phoneNumber'], 
                id: data['id'], agentApproved: data['agentApproved'], 
                agentIdentification: data['agentIdentification'], blockedReason: data['blockedReason'],
                companyName: data['companyName'], contactLine: data['contactLine'], 
                country: data['country'], countryCode: data['countryCode'],
                emailProofToken: data['emailProofToken'], emailProofTokenExpiresAt: data['emailProofTokenExpiresAt'], 
                emailVerified: data['emailVerified'], 
                gender: data['gender'], headOfficeAddress: data['headOfficeAddress'],
                 isBlocked: data['isBlocked'], isoCode: data['isCode'], lastSeenAt: data['lastSeenAt'],
                passwordResetToken: data['passwordResetToken'], passwordResetTokenExpiresAt: data['passwordResetTokenExpiresAt'], pinSet: data['pinSet'], 
                profileImage: data['profileImage'], rating: data['rating'], referralCode: data['referralCode'], referredBy: data['referredBy'], 
                sellerAgent: data['sellerAgent'], sellerApproved: data['sellerApproved'], sellerIdentification: data['sellerIdentification'], 
               token: data['token'], tosAcceptedByIp: data['tosAcceptedByIp'], type: data['type']);
  }
  static Future<bool> isAuthenticated() async{
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    if(_preferences.getString('user') != null){
      var resp = _preferences.getString('user');
    var data = json.decode(resp);

    User user = User(firstName: data['firstName'], lastName: data['lastName'], 
                email: data['email'], phoneNumber: data['phoneNumber'], 
                id: data['id'], agentApproved: data['agentApproved'], 
                agentIdentification: data['agentIdentification'], blockedReason: data['blockedReason'],
                companyName: data['companyName'], contactLine: data['contactLine'], 
                country: data['country'], countryCode: data['countryCode'],
                emailProofToken: data['emailProofToken'], emailProofTokenExpiresAt: data['emailProofTokenExpiresAt'], 
                emailVerified: data['emailVerified'], 
                gender: data['gender'], headOfficeAddress: data['headOfficeAddress'],
                 isBlocked: data['isBlocked'], isoCode: data['isCode'], lastSeenAt: data['lastSeenAt'],
                passwordResetToken: data['passwordResetToken'], passwordResetTokenExpiresAt: data['passwordResetTokenExpiresAt'], pinSet: data['pinSet'], 
                profileImage: data['profileImage'], rating: data['rating'], referralCode: data['referralCode'], referredBy: data['referredBy'], 
                sellerAgent: data['sellerAgent'], sellerApproved: data['sellerApproved'], sellerIdentification: data['sellerIdentification'], 
               token: data['token'], tosAcceptedByIp: data['tosAcceptedByIp'], type: data['type']);
      var token = App.tryParseJwt(user.token);
      var date = DateTime.fromMillisecondsSinceEpoch(token['exp'] * 1000);
      DateTime today = DateTime.now();
      int diffInMinutes = date.difference(today).inMinutes;
      print(token);
      print(diffInMinutes);
      if(diffInMinutes >= 10){
          return true;
      }
      _preferences.remove('user');
      return false;
      
    }
    return false;
  }

  static Future<http.Response> login(String email, String password) async{
    try{
      var response = await http.post(appDomain+'/api/v1/authentication/login', body: {
        'emailAddress': email,'password':password
      });
      return response;
    }catch(error){
      throw error;
    }
  }

  static isLoading(BuildContext context){
    return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: EdgeInsets.symmetric(vertical:16.0, horizontal: 16.0),
          child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(),
            Container(padding: EdgeInsets.symmetric(horizontal:16.0),
              child: new Text("Loading"),
            )
          ],
        ),),
      );
      });
  }
  static stopLoading(BuildContext context){
    return Navigator.pop(context);
  }

  static Map<String, dynamic> tryParseJwt(String token) {
    if(token == null) return null;
    final parts = token.split('.');
    if (parts.length != 3) {
      return null;
    }
    final payload = parts[1];
    var normalized = base64Url.normalize(payload);
    var resp = utf8.decode(base64Url.decode(normalized));
    final payloadMap = json.decode(resp);
    if (payloadMap is! Map<String, dynamic>) {
      return null;
    }
    return payloadMap;
  }
  static Future<http.Response> removeCartItem(int productId) async{
    try{
      var user = await App.getCurrentUser();
      var response = http.post(appDomain + '/api/v1/user/cart/remove', body: {
        'productId': "$productId"}, headers: {'x-access-token': user.token});
      return response;
    }catch(error){
      throw error;
    }
  }
  static Future<Cart> getUserCart(String token ) async{
    List<AppProduct> _products = [];
    try{
      var response = await http.get(appDomain + '/api/v1/user/cart/get', headers: {
        'x-access-token': token
      });
      List<dynamic> products = json.decode(response.body)['cart']['products'];
      var cartQuantity = json.decode(response.body)['cart']['quantity'];
      var cart = json.decode(response.body)['cart'];
      
      products.forEach((product) {
        
        

        AppProduct appProduct = AppProduct(createdAt: product['createdAt'],
             id: product['id'], name: product['name'], model: product['model'], description:
              product['description'], year: product['year'], mainImageUrl: product['mainImageUrl'], sellingPrice:
               product['sellingPrice'], costPrice: product['costPrice'], discounts: product['discounts'], finalPrice: 
               product['finalPrice'], deliveryDays: product['deliveryDays'], deliveryLocation: product['deliveryLocation'],
                deliveryType: product['deliveryType'], rating: product['rating'], blockedReason: product['blockedReason'],
                 isBlocked: product['isBlocked'], homepage: product['homepage'], homePageUntil: product['homePageUntil'], 
                 featured: product['featured'], featuredUntil: product['featuredUntil'], owner: null, agent: product['agent'],
                  adCategory: product['adCategory'], category: null, subCategory: null, store: null,
                  orderId: cart['id'] ,orderNumber: cartQuantity["${product['id']}"] 
              );
        
        _products.add(appProduct);
      });
      return Cart(products: _products);
    }catch(error){
      throw error;
    }
  }
  static Future<http.Response> addProductToCart(int productId, int quantity) async{
    try{
        print(productId.toString() + ' ' + quantity.toString());
        var user =  await App.getCurrentUser();
        var response = await  http.post(appDomain + '/api/v1/user/cart/add', body: {
          'productId': "$productId",
          'quantity': "$quantity"
        }
          , headers: {'x-access-token': user.token});
      return response;
    }catch(error){
      throw error;
    }
  }

  static Future<List<Address>> getUserAddress() async{
    try{
      var user = await App.getCurrentUser();
      var response = await http.get(appDomain + '/api/v1/user/address/get/0/3', headers: {
        'x-access-token': user.token
      });
      var address = json.decode(response.body)['address'];
      List<Address> _address = [];
      address.forEach((item) {
        _address.add(
          Address(address1: item['address1'], id: item['id'], state: item['state'], country: item['country'])
        );
      });
      return _address;
    }catch(error){
      throw (error);
    }
  }
  static Future<http.Response> orderProduct(String amount, String transactionReference,
    List<AppProduct> cart, bool useWallet, String addressId, String addressString) async{
    try{
        var user = await App.getCurrentUser();
        var response = await http.post(appDomain+'/api/v1/user/order/create',
          body: {'amount': amount, 'transactionReference': transactionReference,
         'useWallet': useWallet.toString(), 'addressId': addressId, 'addressString': addressString  },
          headers: {'x-access-token': user.token });
        // if(response.statusCode != 201 || response.statusCode != 200){
        //     throw response;
        // }
        return response;
    }catch(error){
      throw error;
    }
  }

  static Future<List<Order>> getUserOrders() async{
    try{
        var user = await App.getCurrentUser();
        var response = await http.get(appDomain+'/api/v1/user/order/get-orders/0/20', headers: {
          'x-access-token': user.token
        });
        var orders = json.decode(response.body)['order'];
        // var products = orders['products'];
        
        List<Order> _orders = [];
        orders.forEach(( order){
          var products = order['products'];
          List<AppProduct> _products = [];
          products.forEach((product) {
                AppProduct appProduct = AppProduct(createdAt: product['createdAt'],
                id: product['id'], name: product['name'], model: product['model'], description:
                  product['description'], year: product['year'], mainImageUrl: product['mainImageUrl'], sellingPrice:
                  product['sellingPrice'], costPrice: product['costPrice'], discounts: product['discounts'], finalPrice: 
                  product['finalPrice'], deliveryDays: product['deliveryDays'], deliveryLocation: product['deliveryLocation'],
                    deliveryType: product['deliveryType'], rating: product['rating'], blockedReason: product['blockedReason'],
                    isBlocked: product['isBlocked'], homepage: product['homepage'], homePageUntil: product['homePageUntil'], 
                    featured: product['featured'], featuredUntil: product['featuredUntil'], owner: null, agent: product['agent'],
                      adCategory: product['adCategory'], category: null, subCategory: null, store: null,
                      orderId: product['id'] ,orderNumber: order['quantity']["${product['id']}"],
                       orderStatus: order['productStatus']["${product['id']}"]
                       
                  );
              print('here o');
              _products.add(appProduct);
              
          });
          Address _address = Address(address1: order['address']['address1'], id: order['address']['id'], 
                state: order['address']['state'], country: order['address']['country']);
          _orders.add(
            Order(products: _products , address: _address , addressString: order['addressString'] , 
              createdAt: order['createdAt'] , id: order['id'] , owner: order['owner'] ,status: order['status'] , totalAmount: order['totalAmount'] )
          );
        });
        return _orders;
    }catch(error){
      throw error;
    }
  }
  static Future<bool> signOutUser() async{
     try{
       SharedPreferences _prefs = await SharedPreferences.getInstance();
       _prefs.remove('user');
       return true;
     }catch(error){
       return false;
     }
  }
  static bool isEmail(String em) {

    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }
  static Future<http.Response> signUp(String firstName, String lastName, String emailAddress,
    String password, String phoneNumber, String country, String countryCode, String gender, String referredBy
      ,String isoCode) async{
      try{
        var response = await http.post(appDomain+'/api/v1/registration/signup', body: {
          'firstName': firstName, 'lastName': lastName, 'emailAddress': emailAddress, 
          'password': password, 'phoneNumber': phoneNumber, 'country': country, 'countryCode': countryCode,
          'gender': gender, 'referredBy': referredBy, 'isoCode': isoCode
        });
        return response;
      }catch(error){
        throw error;
      }
  }
  static Future<http.Response> resendVerificationLink(String email) async{
    try{
      var response = await http.post(appDomain+'/api/v1/registration/resend-verification-code', body: {
        'emailAddress': email
      });
      return response;
    }catch(error){
      throw error;
    }
  }
  static Future<http.Response> verifyEmail(String email, String password, String emailProofToken ) async{
    try{
        var response = await http.post(appDomain+'/api/v1/registration/verify-email', body: {
          'emailAddress': email, 'password': password, 'emailProofToken': emailProofToken
        });
        return response;
    }catch(error){
      throw error;
    }
  }
  static Future<http.Response> sendPasswordLink(String email) async{
    try{
        var response = await http.post(appDomain+'/api/v1/user/forgot-password', body: {'emailAddress': email});
        return response;
    }catch(error){
      throw error;
    }
  }
  static Future<User> getUserWallet() async{
    try{
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var user = await App.getCurrentUser();
      var response = await http.get(appDomain+'/api/v1/user/wallet/get', headers: {
        'x-access-token': user.token
      });
      var wallet = json.decode(response.body)['wallet'];
      var transactions = wallet['transactions'];
      List<Transaction> _transaction = [];

      transactions.forEach((item) {
        _transaction.add(Transaction(amount: item['amount'] ,createdAt: item['createdAt'],
        currency: item['currency'] ,id: item['id'] ,isApproved: item['isApproved'] ,owner: item['owner'],
        transactionReference: item['transactionReference'] ,type: item['type'] ,wallet: item['wallet'] ));
      });

      Wallet _wallet = Wallet(currency: wallet['currency'], id: wallet['id'], 
      createdAt: wallet['createdAt'], balance: wallet['balance'], transactions: _transaction);

      user.wallet = _wallet;
      _prefs.remove('user');
      _prefs.setString('user', json.encode(user));
      return user;
    }catch(error){
      throw error;
    }
  }

  static Future<List<Question>> getSecurityQuestions() async{
    try{
      var response = await http.get(appDomain + "/api/v1/user/get-security-questions");
      var questions = json.decode(response.body)['questions'];
      List<Question> _questions= [];
      questions.keys.forEach((key) {
        _questions.add(Question(id: key ,question: questions[key]));
      });
      return _questions;
    }catch(error){
      throw error;
    }
  }

  static Future<http.Response> setSecurityQuestion(String pin, String securityQuestion, String securityAnswer) async{
    try{
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var user = await App.getCurrentUser();
      var response = await http.post(appDomain+'/api/v1/user/set-account-pin', 
        body: {'pin': pin, 'securityQuestion': securityQuestion, 'securityAnswer': securityAnswer},
        headers: {'x-access-token': user.token}  );
      user.pinSet = true;
      _prefs.remove('user');
      _prefs.setString('user', json.encode(user));
        return response;
    }catch(error){
      throw error;
    }
  }

}