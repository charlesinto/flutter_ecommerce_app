import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/config/route.dart';
import 'package:flutter_ecommerce_app/src/model/app_state.dart';
import 'package:flutter_ecommerce_app/src/pages/product_detail.dart';
import 'package:flutter_ecommerce_app/src/wigets/customRoute.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'src/pages/home_page.dart';
import 'src/themes/theme.dart';
import './src/redux/reducers.dart';

void main() {
  final _initialState = AppState(selectedTabIndex: 0); 
  final Store<AppState> _store = Store<AppState>(reducer, initialState: _initialState);
  runApp(MyApp(_store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  MyApp(this.store);
  Future<String> getCurrentUser() async{
    // print('h');
    return 'c';
  }
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCurrentUser(),
      builder: (BuildContext context, snapshot){
         if(snapshot.connectionState == ConnectionState.done){
           if(snapshot.hasData){
             StoreProvider<AppState>(
                  store: store,
                  child: MaterialApp(
                      title: 'Azonka',
                      theme:  AppTheme.lightTheme.copyWith(
                        textTheme: GoogleFonts.muliTextTheme(
                          Theme.of(context).textTheme,
                        ),
                      ),
                      debugShowCheckedModeBanner: false ,
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
           return StoreProvider<AppState>(
                  store: store,
                  child: MaterialApp(
                      title: 'Azonka',
                      theme:  AppTheme.lightTheme.copyWith(
                        textTheme: GoogleFonts.muliTextTheme(
                          Theme.of(context).textTheme,
                        ),
                      ),
                      debugShowCheckedModeBanner: false ,
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
         return Container(color: Colors.white,);
      });
  }
}