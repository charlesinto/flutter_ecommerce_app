import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/model/app_adProduct.dart';
import 'package:flutter_ecommerce_app/src/model/app_cartlist.dart';
import 'package:flutter_ecommerce_app/src/model/app_product.dart';
import 'package:flutter_ecommerce_app/src/model/app_state.dart';
import 'package:flutter_ecommerce_app/src/model/app_user.dart';
import 'package:flutter_ecommerce_app/src/model/data.dart';
import 'package:flutter_ecommerce_app/src/model/product.dart';
import 'package:flutter_ecommerce_app/src/themes/light_color.dart';
import 'package:flutter_ecommerce_app/src/themes/theme.dart';
import 'package:flutter_ecommerce_app/src/wigets/title_text.dart';
import 'package:flutter_ecommerce_app/util/app.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/actions.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ShopingCartPage extends StatelessWidget {
  const ShopingCartPage({Key key}) : super(key: key);

  Widget _cartItems(BuildContext context, List<AppProduct> cart) {
    // return Column(children: AppData.cartList.map((x) => _item(x)).toList());
    return Column(children: cart.map((AppProduct x) => _item(context, x)).toList());
  }

  Widget _item(BuildContext context, AppProduct model) {
    return Container(
      height: 80,
      child: Row(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.2,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 70,
                    width: 70,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            decoration: BoxDecoration(
                                color: LightColor.lightGrey,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  // left: -20,
                  // bottom: -20,
                  child: Image.network(model.mainImageUrl,
                      height: 75.0,
                      width: 75.0, 
                      fit: BoxFit.cover,
                    )
                )
              ],
            ),
          ),
          Expanded(
              child: ListTile(
                  title: TitleText(
                    text: model.name,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      TitleText(
                        text: 'NGN ',
                        color: LightColor.red,
                        fontSize: 12,
                      ),
                      TitleText(
                        text:App.formatAsMoney(model.finalPrice),
                        fontSize: 14,
                      ),
                    ],
                  ),
                  trailing: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            StoreProvider.of<AppState>(context).dispatch(DecrementQuantity(model.id));
                          },
                          child: Container(
                          child: TitleText(
                            color: Colors.red,
                            text: '-',
                            fontSize: 28,
                          ) ,)
                        ),
                          SizedBox(
                            width: 16
                          ),
                          Container(
                            width: 35,
                            height: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: LightColor.lightGrey.withAlpha(150),
                                borderRadius: BorderRadius.circular(10)),
                            child: TitleText(
                                    text: 'x${model.orderNumber}',
                                    fontSize: 12,
                                  )
                            
                          ),
                          SizedBox(
                            width: 16
                          ),
                          GestureDetector(
                            onTap: (){
                              StoreProvider.of<AppState>(context).dispatch(IncrementQuantity(model.id));
                            },
                            child: Container(
                          child: TitleText(
                            color: Colors.green,
                            text: '+',
                            fontSize: 28,
                          ) ,)
                          ),
                          SizedBox(
                            width: 8
                          ),
                          GestureDetector(
                            onTap: (){
                              removeItemFromCart(context, model);
                            },
                            child: Icon(
                              
                              Icons.delete_outline,
                              color: LightColor.orange,
                              size: 20,
                            )
                          )
                      ]
                    )
                  )
                  
                  
                   
                )
              )
        ],
      ),
    );
  }

  Widget _price(List<AppProduct> cart) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TitleText(
          text: '${cart.length} Items',
          color: LightColor.grey,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        TitleText(
          text: 'NGN ${getPrice(cart)}',
          fontSize: 18,
        ),
      ],
    );
  }
  removeItemFromCart(BuildContext context, AppProduct product) async{
    try{
      
        App.isLoading(context);
        await App.removeCartItem(product.id);

        StoreProvider.of<AppState>(context).dispatch(RemoveCartItem(product));


        App.stopLoading(context);

        Alert(
          context: context,
          type: AlertType.success,
          title: "Delete Item",
          desc: "Product removed from cart successfully",
          buttons: [
            DialogButton(
              color: LightColor.orange,
              child: Text(
                "Continue",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            ),
          ],
        ).show();
    }catch(error){
      print(error);
      App.stopLoading(context);
    }
    
  }
  hanldeNavigationToPaymentPage(BuildContext context, List<int> modifiedItems, Cart cart) async{
    if(modifiedItems.length > 0){
        App.isLoading(context);
        modifiedItems.forEach((id) async {
          var doc = cart.products.firstWhere((AppProduct element) => element.id == id, orElse: () => null);
          if(doc != null){
            int index = cart.products.indexOf(doc);
            var product = cart.products[index];
            try{
              await App.addProductToCart(product.id, product.orderNumber);
            }catch(error){
              print(error);
            }
            
          }
        });
        App.stopLoading(context);
    }
    Navigator.of(context).pushNamed('/payment');
  }
  Widget _submitButton(BuildContext context, List<int> modifiedItems, Cart cart) {
    return FlatButton(
        onPressed: () {
          hanldeNavigationToPaymentPage(context, modifiedItems, cart);
          print('pressed');
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: LightColor.orange,
        child: Container(
          alignment: Alignment.center,
          // margin: EdgeInsets.only(bottom: 30.0),
          padding: EdgeInsets.symmetric(vertical: 12.0),
          width: AppTheme.fullWidth(context) * .7,
          child: TitleText(
            text: 'Next',
            color: LightColor.background,
            fontWeight: FontWeight.w500,
          ),
        ));
  }

  String getPrice(List<AppProduct> cart) {
    double price = 0;
    cart.forEach((AppProduct x) {
      price += x.finalPrice * x.orderNumber;
    });
    return App.formatAsMoney(price.toInt());
  }
  Future<Cart> getUserCart(BuildContext context) async{
      User user = await App.getCurrentUser();
      var cart = await  App.getUserCart(user.token);
      // StoreProvider.of<AppState>(context).dispatch(CartItemsFetched(cart));
      return cart;
  }
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
              builder: (BuildContext context, state){
                print(state.userCart.products.length);
                return Container(
                      padding: AppTheme.padding,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(top: 20.0,bottom: 40.0),
                        child: Column(
                          children: <Widget>[
                            state.userCart.products.length > 0 ?
                            _cartItems(context, state.userCart.products)
                            : FutureBuilder(
                              future: getUserCart(context),
                              builder: (BuildContext context, AsyncSnapshot<Cart> snapshot){
                                  if(snapshot.connectionState == ConnectionState.done){
                                    if(snapshot.hasData){
                                      return _cartItems(context, snapshot.data.products);
                                    }
                                  }
                                  return _cartItems(context, []);
                              },
                            ),
                            Divider(
                              thickness: 1,
                              height: 70,
                            ),
                            state.userCart.products.length > 0 ?
                            _price(state.userCart.products)
                            : FutureBuilder(
                              future: getUserCart(context),
                              builder: (BuildContext context, AsyncSnapshot<Cart> snapshot){
                                  if(snapshot.connectionState == ConnectionState.done){
                                    if(snapshot.hasData){
                                      return _price(snapshot.data.products);
                                    }
                                  }
                                  return _price([]);
                              },
                            ),
                            
                            SizedBox(height: 30),
                            state.userCart.products.length > 0 ?
                            _submitButton(context, state.modifiedCartItems, state.userCart)
                            : Container()
                          ],
                        ),
                      ),
                    );
              }, 
              converter: (store) => store.state);

    
      }
}
