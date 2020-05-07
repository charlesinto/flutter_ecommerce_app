
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/model/app_adProduct.dart';
import 'package:flutter_ecommerce_app/src/model/app_cartlist.dart';
import 'package:flutter_ecommerce_app/src/model/app_product.dart';
import 'package:flutter_ecommerce_app/src/model/app_state.dart';
import 'package:flutter_ecommerce_app/src/model/app_user.dart';
import 'package:flutter_ecommerce_app/src/model/data.dart';
import 'package:flutter_ecommerce_app/src/pages/home_page.dart';
import 'package:flutter_ecommerce_app/src/pages/ordersPage.dart';
import 'package:flutter_ecommerce_app/src/pages/shoping_cart_page.dart';
import 'package:flutter_ecommerce_app/src/redux/actions.dart';
import 'package:flutter_ecommerce_app/src/themes/light_color.dart';
import 'package:flutter_ecommerce_app/src/themes/theme.dart';
import 'package:flutter_ecommerce_app/src/wigets/BottomNavigationBar/bootom_navigation_bar.dart';
import 'package:flutter_ecommerce_app/src/wigets/prduct_icon.dart';
import 'package:flutter_ecommerce_app/src/wigets/product_card.dart';
import 'package:flutter_ecommerce_app/src/wigets/title_text.dart';
import 'package:flutter_ecommerce_app/util/app.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:badges/badges.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GlobalKey<ScaffoldState> _drawerWidget = GlobalKey<ScaffoldState>();
  bool isHomePageSelected = true;
  Widget _appBar(BuildContext context)  {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RotatedBox(
                  quarterTurns: 4,
                  child: GestureDetector(onTap: (){
                      _drawerWidget.currentState.openEndDrawer();
                  }, child: _icon(Icons.sort,context, color: Colors.black54) ),
                ),
          ClipRRect(
            // borderRadius: BorderRadius.all(Radius.circular(13)),
            child: Container(
              decoration: BoxDecoration(
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: GestureDetector(
                onTap: () async{
                  await loadCart(context);
                  StoreProvider.of<AppState>(context).dispatch(BottomIconSelected(2));
                },
                child: FutureBuilder(
                  builder: (BuildContext context, AsyncSnapshot<Cart> snapshot){
                    if(snapshot.connectionState == ConnectionState.done){
                      if(snapshot.hasData){
                          return Badge(
                            badgeColor: LightColor.orange,
                            shape: BadgeShape.circle,
                            badgeContent: Text(snapshot.data.products.length.toString(), style: TextStyle(color: Colors.white),),
                            child: Icon(Icons.shopping_cart, color: Colors.black),
                          );
                      }
                    }
                    return Badge(
                      badgeColor: LightColor.orange,
                      shape: BadgeShape.circle,
                      badgeContent: Text('', style: TextStyle(color: Colors.white),),
                      child: Icon(Icons.shopping_cart, color: Colors.black),
                    );
                  },
                  future: getUserCart() ,
                )
              // Icon(Icons.shopping_cart, color: Colors.black)
              // child: Image.asset("assets/user.png"),
            ),
          ))
        ],
      ),
    );
  }

  loadCart(BuildContext context) async{
      User user = await App.getCurrentUser();
      var cart = await  App.getUserCart(user.token);
      // var userOrder = await App.getUserOrders();
      // print(userOrder.body);
      StoreProvider.of<AppState>(context).dispatch(CartItemsFetched(cart));
  }

  Widget _icon(IconData icon,context, {Color color = LightColor.iconColor}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: Theme.of(context).backgroundColor,
          boxShadow: AppTheme.shadow),
      child: Icon(
        icon,
        color: color,
      ),
    );
  }

  Widget getTabTitle(int tabIndex){
    switch(tabIndex){
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(
                  text: 'Our',
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                ),
                TitleText(
                  text: 'Products',
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                )
          ]
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(
                  text: 'Your',
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                ),
                TitleText(
                  text: 'Orders',
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                )
          ]
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(
                  text: 'Shopping',
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                ),
                TitleText(
                  text:  'Cart',
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                )
          ]
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(
                  text: 'Your',
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                ),
                TitleText(
                  text: 'Profile',
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
              )
          ]
        );
      default:
        return Container();
    }
  }
  removeAllCartItems(BuildContext context, List<AppProduct> products) async{
    try{
      App.isLoading(context);
    products.forEach((product) async{
      await App.removeCartItem(product.id);
    });
    
    App.stopLoading(context);
    Alert(
      context: context,
      type: AlertType.success,
      title: "Action Successful",
      desc: "Products removed from cart successfully",
      buttons: [
        DialogButton(
          color: Colors.white,
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.orange, fontSize: 20),
          ),
          onPressed: () {
            StoreProvider.of<AppState>(context).dispatch(ClearCartItems());
            Navigator.pop(context);
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
    }catch(error){
      print(error);
        Alert(
        context: context,
        type: AlertType.error,
        title: "Action failed",
        desc: "Some errors were encountered",
        buttons: [
          DialogButton(
            color: Colors.white,
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.orange, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            width: 120,
          )
        ],
      ).show();
    }
  }
  Widget _title(int tabIndex, BuildContext context, List<AppProduct> products) {
    return Container(
        margin: AppTheme.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                getTabTitle(tabIndex)
              ],
            ),
            Spacer(),
            tabIndex == 2
                ? FlatButton(
                  onPressed: (){
                      Alert(
                          context: context,
                          type: AlertType.info,
                          title: "Delete Item(s)",
                          desc: "Remove the following item(s) from cart",
                          buttons: [
                            DialogButton(
                              color: LightColor.orange,
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => Navigator.pop(context),
                              width: 120,
                            ),
                            DialogButton(
                              color: Colors.white,
                              child: Text(
                                "Yes, Delete",
                                style: TextStyle(color: Colors.orange, fontSize: 20),
                              ),
                              onPressed: () {
                                removeAllCartItems(context, products);
                              },
                              width: 120,
                            )
                          ],
                        ).show();
                    print('Delete Items');
                  },
                  child: Icon(
                    Icons.delete_outline,
                    color: LightColor.orange,
                  ),
                )
                : SizedBox()
          ],
        ));
  }
  
  hanldeNavigationToPaymentPage(BuildContext context, List<int> modifiedItems, Cart cart) async{
    if(modifiedItems.length > 0){
        App.isLoading(context);
        modifiedItems.forEach((id) async {
          var doc = cart.products.firstWhere((AppProduct element) => element.id == id, orElse: () => null);
          if(doc != null){
            int index = cart.products.indexOf(doc);
            var product = cart.products[index];
            await App.addProductToCart(product.id, product.orderNumber);
          }
        });
        App.stopLoading(context);
    }
    // Navigator.of(context).pushNamed('/payment');
  }

  void onBottomIconPressed(int index, BuildContext context, Cart cart, List<int> modifiedItems) async{
    print('pressed button');
    hanldeNavigationToPaymentPage(context, modifiedItems, cart);
    await loadCart(context);
    StoreProvider.of<AppState>(context).dispatch(BottomIconSelected(index));
  }
  Widget getPage(int selectedTabIndex){
    switch(selectedTabIndex){
      case 0:
        return MyHomePage();
      case 1: 
        return OrderPage();
      case 2:
        return Align(
                alignment: Alignment.topCenter,
                child:ShopingCartPage(),
              );
      case 3:
        return MyHomePage();
      default:
        return Container();
    }
    /*
      isHomePageSelected
                                    ? MyHomePage()
                                    : Align(
                                      alignment: Alignment.topCenter,
                                      child:ShopingCartPage(),
                                    )
    */
  }
  Widget _appDrawer(BuildContext context, User user){
    return Column(
      children: [
         Container(
            height: 180,
            color: LightColor.primaryAccent,
            child: Container(
              color: LightColor.primaryAccent,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.asset('assets/logo.png',
                        fit: BoxFit.cover,
                        width: 75,
                        height:75,
                      ),
                    // CircleAvatar(
                    //   radius: 20,
                    //   backgroundColor: Colors.white,
                    //   child: Image.asset('assets/logo.png',
                    //     fit: BoxFit.contain,
                    //     width: 200,
                    //     height:200,
                    //   ),)
                  ),
                  Container(
                    child: TitleText(
                      color: Colors.white ,
                      text: user == null ? '' : "${user.firstName} ${user.lastName}",
                      fontSize: 27,
                      fontWeight: FontWeight.w700,
                    ),
                    ),

                  Container(
                    child: TitleText(
                      color: Colors.white ,
                      text: user == null ? '' : "${user.email}",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    )
              ],) ,
            )
        ),
        Expanded(
          // flex: 6,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: SingleChildScrollView(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(Icons.home, color: LightColor.lightColor),
                    title: TitleText(
                            color: Colors.black ,
                            text: 'Home',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ) ,
                  ),
                  GestureDetector(
                    onTap: () {
                      StoreProvider.of<AppState>(context).dispatch(BottomIconSelected(1));
                      Navigator.pop(context);
                    },
                    child: ListTile(
                    leading: Icon(Icons.history, color: LightColor.lightColor),
                    title: TitleText(
                            color: Colors.black ,
                            text: 'My Orders',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ) ,
                  )
                  ),
                  GestureDetector(onTap: () => Navigator.of(context).pushNamed('/wallet'),
                    child: ListTile(
                      leading: Icon(Icons.card_membership, color: LightColor.lightColor),
                      title: TitleText(
                              color: Colors.black ,
                              text: 'Azonka Wallet',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ) ,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.credit_card, color: LightColor.lightColor),
                    title: TitleText(
                            color: Colors.black ,
                            text: 'Azonka Pay',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ) ,
                  ),
                  ListTile(
                    leading: Icon(Icons.settings, color: LightColor.lightColor),
                    title: TitleText(
                            color: Colors.black ,
                            text: 'Settings',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ) ,
                  ),
                  ListTile(
                    leading: Icon(Icons.call, color: LightColor.lightColor),
                    title: TitleText(
                            color: Colors.black ,
                            text: 'Costumer Service',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ) ,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacementNamed('/wallet'),
                    child: ListTile(
                      leading: Icon(Icons.store, color: LightColor.lightColor),
                      title: TitleText(
                              color: Colors.black ,
                              text: 'My Store',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ) ,
                    ),
                  ),
                  GestureDetector(
                    onTap: (){ _signOutUser(context);},
                   child: ListTile(
                    leading: Icon(Icons.arrow_back_ios, color: LightColor.lightColor),
                    title: TitleText(
                            color: Colors.black ,
                            text: 'Sign Out',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ) ,
                  ), )
                ]
              )
            )
          )
        )
      ],
    );
  }
  Future<Cart> getUserCart()async{
      var user = await App.getCurrentUser();
      
      var cart = await  App.getUserCart(user.token);
      return cart;
  }
  _signOutUser(BuildContext context) async{
      App.isLoading(context);
      var isSignedOut =  await App.signOutUser();
      return isSignedOut ? Navigator.of(context).pushReplacementNamed('/login') : Alert(
                                context: context,
                                type: AlertType.error,
                                title: "Action Error",
                                desc: "Some errors were encountered signing you out",
                                buttons: [
                                  DialogButton(
                                    color: LightColor.orange,
                                    child: Text(
                                      "Ok",
                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    width: 120,
                                  )
                                ],
                              ).show();
  }

  Future<User> getCurrentUser() async{
    try{
        var user = await App.getCurrentUser();
        var res = await App.getUserOrders();
        print(res.length);
      // var cart = await  App.getUserCart(user.token);
      return user;
    }catch(error){
      print(error);
      return null;
    }
  }
  Widget getUser(AsyncSnapshot<User> snapshot){
    if(snapshot.connectionState == ConnectionState.done){
      if(snapshot.hasData){
        return _appDrawer(context, snapshot.data);
      }
      return _appDrawer(context, null);
    }
    return Container();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot){
        return StoreConnector<AppState, AppState>(
      builder: (BuildContext context, state){
        return Scaffold(
              key: _drawerWidget,
              endDrawer: Drawer(
                child: getUser(snapshot),
              ),
              body: SafeArea(
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Container(
                        height: AppTheme.fullHeight(context) - 50,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          colors: [
                            Color(0xfffbfbfb),
                            Color(0xfff7f7f7),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child:  _appBar(context)
                            ),
                            // _title(),
                            Expanded(
                              flex: 1,
                              child:  _title(state.bottomIconIndex, context, state.userCart.products),
                            ),
                            Expanded(
                                flex: 5,
                                child:AnimatedSwitcher(
                                  duration: Duration(milliseconds: 300),
                                  switchInCurve: Curves.easeInToLinear,
                                  switchOutCurve: Curves.easeOutBack,
                                  child:  getPage(state.bottomIconIndex)
                                ))
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: CustomBottomNavigationBar(
                          onIconPresedCallback: (index ) =>  onBottomIconPressed(index, context, state.userCart, state.modifiedCartItems),
                        ))
                  ],
                ),
              ),
            );
      },
       converter: (store) => store.state);
      }
    );
  }
}
