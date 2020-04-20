

import 'package:flutter_ecommerce_app/src/model/app_state.dart';
import 'package:flutter_ecommerce_app/src/redux/actions.dart';

AppState reducer(AppState prevState, dynamic action){
  
  AppState newState = AppState.fromAppState(prevState);
  if(action is AppStateProductsFetched){
    print('called');
    newState.appStateProducts = action.payload;
  }
  return newState;
}