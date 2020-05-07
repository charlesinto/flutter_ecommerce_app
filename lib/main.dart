import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/config/route.dart';
import 'package:flutter_ecommerce_app/src/model/app_advert_product.dart';
import 'package:flutter_ecommerce_app/src/model/app_product.dart';
import 'package:flutter_ecommerce_app/src/model/app_product_category.dart';
import 'package:flutter_ecommerce_app/src/model/app_state.dart';
import 'package:flutter_ecommerce_app/src/model/app_state_products.dart';
import 'package:flutter_ecommerce_app/src/pages/loginPage.dart';
import 'package:flutter_ecommerce_app/src/pages/mainPage.dart';
import 'package:flutter_ecommerce_app/src/pages/product_detail.dart';
import 'package:flutter_ecommerce_app/src/wigets/customRoute.dart';
import 'package:flutter_ecommerce_app/src/themes/light_color.dart';
import 'package:flutter_ecommerce_app/src/wigets/title_text.dart';
import 'package:flutter_ecommerce_app/util/app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'src/pages/home_page.dart';
import 'src/themes/theme.dart';
import './src/redux/reducers.dart';

void main() {
  // final Store<AppState> _store = Store<AppState>(reducer);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Store<AppState> store;
  Widget _icon(BuildContext context, IconData icon, {Color color = LightColor.iconColor}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color:Colors.white,
          boxShadow: AppTheme.shadow),
      child: Icon(
        icon,
        color: color,
      ),
    );
  }
  Widget _appBar(context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RotatedBox(
            quarterTurns: 4,
            child: _icon(context, Icons.sort, color: Colors.black54),
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(13)),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Color(0xfff8f8f8),
                      blurRadius: 10,
                      spreadRadius: 10),
                ],
              ),
              child: Image.asset("assets/user.png"),
            ),
          )
        ],
      ),
    );
  }
  Future<bool> isUserAuthenticated() async {
    return await App.isAuthenticated();
  }
  Future<Store<AppState>> getCurrentUser() async{
     AppStateProducts appStateProducts;
    try{
      
      List<AppProduct> _featuredproducts = await App.getProducts('/api/v1/user/product/get-featured-products/0/20');
      
      List<AppProduct> _homeProducts = await App.getProducts('/api/v1/user/product/get-featured-products/0/20');
      List<ProductCategory> _categories = await App.getProductCategories();
     
      List<AdvertProduct> _adcategories = await App.getProductAdvertCategories();
      appStateProducts = AppStateProducts(featuredProducts: _featuredproducts, homeProducts: _homeProducts,
                             categories: _categories, advertCategory: _adcategories, cart: null );
      // StoreProvider.of<AppState>(context).dispatch(AppStateProductsFetched(appStateProducts));
      final _initialState = AppState(selectedTabIndex: 0, appStateProducts: appStateProducts);
      store = Store<AppState>(reducer, initialState: _initialState);
      
      return store;
    }catch(error){
      print('error is: '+ error);
      return Store<AppState>(reducer, initialState: null);
    }
  }
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: isUserAuthenticated(),
      builder: (BuildContext context,AsyncSnapshot<bool> snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasData && snapshot.data == true){
              return FutureBuilder(
              future: getCurrentUser(),
              builder: (BuildContext context, snapshot){
         if(snapshot.connectionState == ConnectionState.done){
           if(snapshot.hasData){
             print('snapshot data');
             return StoreProvider<AppState>(
                  store: snapshot.data,
                  child: MaterialApp(
                      title: 'Azonka',
                      theme:  AppTheme.lightTheme.copyWith(
                        textTheme: GoogleFonts.muliTextTheme(
                          Theme.of(context).textTheme,
                        ),
                      ),
                      debugShowCheckedModeBanner: false ,
                      home: MainPage(),
                      routes: Routes.getRoute(),
                      // onGenerateRoute: (RouteSettings settings ){
                      //         final List<String> pathElements = settings.name.split('/');
                      //           if(pathElements[1].contains('detail')){
                      //             return CustomRoute<bool>(builder:(BuildContext context)=> ProductDetailPage(), settings: settings);
                      //           }
                      //          return null;
                      //     },
                    ) ,
                  );
                    }
                    print('snapshot data 1');
                    return  MaterialApp(
                                title: 'Azonka',
                                theme:  AppTheme.lightTheme.copyWith(
                                  textTheme: GoogleFonts.muliTextTheme(
                                    Theme.of(context).textTheme,
                                  ),
                                ),
                                debugShowCheckedModeBanner: false ,
                                home: Scaffold(
                                  body:  Container(
                                      color: LightColor.orange,
                                      child: Center(
                                        child: TitleText(
                                          color: Colors.white ,
                                          text: 'Azonka',
                                          fontSize: 27,
                                          fontWeight: FontWeight.w800,
                                        ) ,
                                    )
                                    ),
                                  
                                ),
                              );
                  }
                  return MaterialApp(
                                title: 'Azonka',
                                theme:  AppTheme.lightTheme.copyWith(
                                  textTheme: GoogleFonts.muliTextTheme(
                                    Theme.of(context).textTheme,
                                  ),
                                ),
                                debugShowCheckedModeBanner: false ,
                                home: Scaffold(
                                  body:  Container(
                                      color: Colors.white,
                                      child: Center(
                                        child: Image.asset('assets/logo.png',
                                                    fit: BoxFit.contain,
                                                    height: 400.0,
                                                    width: 400.0,
                                          ),
                                        )
                                    ),
                                ),
                              );
                });
          }
          final _initialState = AppState(selectedTabIndex: 0, appStateProducts: null);
          store = Store<AppState>(reducer, initialState: _initialState);
          return StoreProvider<AppState>(
            store: store ,
            child: MaterialApp(
                  title: 'Azonka',
                  theme:  AppTheme.lightTheme.copyWith(
                    textTheme: GoogleFonts.muliTextTheme(
                      Theme.of(context).textTheme,
                    ),
                  ),
                  debugShowCheckedModeBanner: false ,
                  home: LoginPage(),
                  routes: Routes.getRoute() ,
                ) ,);       
        }
        return MaterialApp(
                title: 'Azonka',
                theme:  AppTheme.lightTheme.copyWith(
                  textTheme: GoogleFonts.muliTextTheme(
                    Theme.of(context).textTheme,
                  ),
                ),
                debugShowCheckedModeBanner: false ,
                home: Scaffold(
                  body:  Container(
                      color: Colors.white,
                      child: Center(
                        child: Image.asset('assets/logo.png',
                                    fit: BoxFit.contain,
                                    height: 400.0,
                                    width: 400.0,
                          ),
                        )
                    ),
                ),
              );
      });
  }
}