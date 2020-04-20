

import 'package:flutter/cupertino.dart';
import 'package:flutter_ecommerce_app/src/model/app_state_products.dart';

class AppState{
  int selectedTabIndex;
  AppStateProducts appStateProducts;
  AppState({@required this.selectedTabIndex});

  AppState.fromAppState(AppState anotherState){
    selectedTabIndex = anotherState.selectedTabIndex;
    appStateProducts = anotherState.appStateProducts;
  }
}