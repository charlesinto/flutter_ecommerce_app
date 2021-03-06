

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/model/app_adProduct.dart';
import 'package:flutter_ecommerce_app/src/model/app_cartlist.dart';
import 'package:flutter_ecommerce_app/src/model/app_product.dart';
import 'package:flutter_ecommerce_app/src/model/app_product_category.dart';
import 'package:flutter_ecommerce_app/src/model/app_state.dart';
import 'package:flutter_ecommerce_app/src/redux/actions.dart';
import 'package:flutter_ecommerce_app/util/app.dart';

AppState reducer(AppState prevState, dynamic action) {
  
  AppState newState = AppState.fromAppState(prevState);
  if(action is AppStateProductsFetched){
    print('called');
    newState.appStateProducts = action.payload;
  }
  if (action is ItemSelectedProductCard){
    newState.selectedProduct = action.payload;
  }
  if( action is AddPrductToCart){
    Cart localCart = newState.userCart;
    // List<AppProduct> cart = newState.userCart.products;
    List<AppProduct> cart = localCart.products;
    AppProduct doc =  cart.firstWhere((AppProduct element) => element.id == action.payload.id, orElse: () => null);
    if(doc != null){
       // get the index
       int index = cart.indexOf(doc);
       cart[index].orderNumber = cart[index].orderNumber + 1;
    }else{
      print(action.payload.name);
      action.payload.orderNumber = action.payload.orderNumber == null ? 1 : action.payload.orderNumber + 1;
      cart.add(action.payload);
    }
    //new products
    var newModifiedCard = Cart(products: cart);
    newState.userCart = newModifiedCard;
  }
  if( action is BottomIconSelected){
      newState.bottomIconIndex = action.payload;
  }
  if( action is UserLoggedIn){
    newState.user = action.payload;
  }
  if(action is CartItemsFetched){
    newState.userCart = action.payload;
  }
  if(action is IncrementQuantity){
    Cart localCart = newState.userCart;
    // List<AppProduct> cart = newState.userCart.products;
    // check if item is already in the array of modified cart items
    List<int> modifiedItems = newState.modifiedCartItems; 
    int modifiedProductId = modifiedItems.firstWhere((id) => id == action.payload, orElse: () => null);
   
    if(modifiedProductId == null){
      modifiedItems.add(action.payload);
    }
    List<AppProduct> cart = localCart.products;
    AppProduct doc =  cart.firstWhere((AppProduct element) => element.id == action.payload, orElse: () => null);
    if(doc != null){
       // get the index
       int index = cart.indexOf(doc);
       cart[index].orderNumber = cart[index].orderNumber + 1;
       var newModifiedCard = Cart(products: cart);
       newState.userCart = newModifiedCard;
       
    }
    newState.modifiedCartItems = modifiedItems;
  }
  if(action is DecrementQuantity){
    Cart localCart = newState.userCart;
    // List<AppProduct> cart = newState.userCart.products;
    List<int> modifiedItems = newState.modifiedCartItems; 
    int modifiedProductId = modifiedItems.firstWhere((id) => id == action.payload, orElse: () => null);

    if(modifiedProductId == null){
      modifiedItems.add(action.payload);
    }
    List<AppProduct> cart = localCart.products;
    AppProduct doc =  cart.firstWhere((AppProduct element) => element.id == action.payload, orElse: () => null);
    if(doc != null){
       // get the index
       int index = cart.indexOf(doc);
       cart[index].orderNumber = cart[index].orderNumber > 1 ?  cart[index].orderNumber - 1 : 1 ;
       var newModifiedCard = Cart(products: cart);
       newState.userCart = newModifiedCard;
    }
    newState.modifiedCartItems = modifiedItems;
  }

  if(action is RemoveCartItem){
    List<AppProduct> cart = newState.userCart.products;
    AppProduct doc =  cart.firstWhere((AppProduct element) => element.id == action.payload.id, orElse: () => null);
    if(doc != null){
        int index = cart.indexOf(doc);
        cart.removeAt(index);

      var  newCart = Cart(products: cart);
      newState.userCart = newCart;
    }

  }
  if(action is ClearCartItems){
    newState.userCart = Cart(products: []);
  }
  if(action is SearchProduct){
      searchProduct(newState.searchString, action.payload).then((products){
        newState.searchResult = products;
        newState.searchComplete = true;
      }).catchError((error){
        App.showActionError(action.payload,message: 'Some error were encountred');
        print('errors: '+ error);
      });
  }
  if(action is SearchByCategory){
    newState.searchString = 'Search for: ${action.payload.category.name}';
    searchByCategory("", action.payload.context, action.payload.category).then((products){
      newState.searchResult = products;
      newState.searchComplete = true;
      Navigator.pop(action.payload.context);
      Navigator.of(action.payload.context).pushNamed('/search');
    }).catchError((error){
      App.showActionError(action.payload.context,message: 'Some errors were encountred');
        print(error);
    });
  }
  if(action is SearchStringChange){
    newState.searchString = action.payload;
    newState.searchComplete = false;
  }
  return newState;
}

Future<List<AppProduct>> searchProduct(String search, BuildContext context) async{
  try{
    App.isLoading(context);
    var products = await App.searchProduct(search);
    App.stopLoading(context);
    return products;
  }catch(error){
    throw error;
  }
}

Future<List<AppProduct>> searchByCategory(String search, BuildContext context, ProductCategory category) async{
  try{
    print(category.id);
    print(category.name);
    App.isLoading(context);
    var products = await App.searchProduct("", category: category.id );
    App.stopLoading(context);
    return products;
  }catch(error){
    throw error;
  }
}

