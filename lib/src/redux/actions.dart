
import 'package:flutter_ecommerce_app/src/model/app_adProduct.dart';
import 'package:flutter_ecommerce_app/src/model/app_cartlist.dart';
import 'package:flutter_ecommerce_app/src/model/app_product.dart';
import 'package:flutter_ecommerce_app/src/model/app_state_products.dart';
import 'package:flutter_ecommerce_app/src/model/app_user.dart';
import 'package:flutter_ecommerce_app/src/wigets/product_card.dart';

class AppStateProductsFetched{
  
   final AppStateProducts payload;
  AppStateProductsFetched(this.payload);
}

class ItemSelectedProductCard{
  final AppProduct payload;
  ItemSelectedProductCard(this.payload);
}

class AddPrductToCart{
  final AppProduct payload;
  AddPrductToCart(this.payload);
}

class BottomIconSelected{
  final int payload;
  BottomIconSelected(this.payload);
}

class UserLoggedIn{
  final User payload;
  UserLoggedIn(this.payload);
}

class CartItemsFetched{
  final Cart payload;
  CartItemsFetched(this.payload);
}

class DecrementQuantity{
  final int payload;
  DecrementQuantity(this.payload);
}

class IncrementQuantity{
  final int payload;
  IncrementQuantity(this.payload);
}

class RemoveCartItem{
  final AppProduct payload;
  RemoveCartItem(this.payload);
}

class ClearCartItems{
  ClearCartItems();
}