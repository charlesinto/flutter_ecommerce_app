import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_ecommerce_app/src/model/app_state.dart';
import 'package:flutter_ecommerce_app/src/redux/actions.dart';
import 'package:flutter_ecommerce_app/src/themes/light_color.dart';
import 'package:flutter_ecommerce_app/src/themes/theme.dart';
import 'package:flutter_ecommerce_app/src/wigets/product_search.dart';
import 'package:flutter_ecommerce_app/src/wigets/title_text.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SearchPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage>{
  @override
  void initState() {
    super.initState();
    _searchState();
    SchedulerBinding.instance.addPostFrameCallback((_){
      _searchQuery.text = appState.searchString;
    });
  }
  BuildContext appContext;
  bool isSearched = false;
  AppState appState;
  final TextEditingController _searchQuery = TextEditingController();
  Timer debounceTimer;
  Widget _appBar(BuildContext context,AppState state) {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
              // Navigator.of(context).pop();
            },
            child: _icon(Icons.arrow_back_ios, color: Colors.black54,),
          ),
          Expanded(
            flex: 1,
            child: searchEntryField(state) ,),
            SizedBox(width: 8.0,),
            GestureDetector(
              onTap: (){
                searchValue(context, state);
              },
              child: Text('Search'),)
        ],
      ),
    );
  }
  searchValue(BuildContext context, AppState state) async{
    try{
      setState(() {
        isSearched =  false;
      });
    StoreProvider.of<AppState>(context).dispatch(SearchProduct(context));
    }catch(error){
      print('search error: '+ error);
    }
  }
  Widget searchEntryField(AppState state){
    return Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: LightColor.lightGrey.withAlpha(100),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextField(
                controller:  _searchQuery,
                autofocus: true,
                textInputAction: TextInputAction.search,
                autocorrect: false,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Products",
                    hintStyle: TextStyle(fontSize: 12),
                    contentPadding:
                        EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 5),
                    prefixIcon: Icon(Icons.search, color: Colors.black54)),
              ),
            );
  }
   Widget _icon(IconData icon, {Color color = LightColor.iconColor}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(13)),
        ),
      child: Icon(
        icon,
        color: Colors.black,
      ),
    );
  }
  _searchState() {
    _searchQuery.addListener(() {
      if (debounceTimer != null) {
        debounceTimer.cancel();
      }
      debounceTimer = Timer(Duration(milliseconds: 800), () {
        if (this.mounted) {
          performSearch(_searchQuery.text);
        }
      });
    });
  }
  void performSearch(String query) async {
    if (query.isEmpty) {
      return;
    }
    print(query);
    if(this.mounted && appState.searchString != query){
      StoreProvider.of<AppState>(appContext).dispatch(SearchStringChange(query));
      StoreProvider.of<AppState>(appContext).dispatch(SearchProduct(context));
    }
    
    
  }

  Widget _renderProducts(BuildContext context, AppState state){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: AppTheme.fullWidth(context),
      height: AppTheme.fullWidth(context),
      padding: EdgeInsets.only(bottom: 140.0),
      child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2/3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 20), 
                    scrollDirection: Axis.vertical,

                    children: state.searchResult.map((product){
                      return ProductCardSearch(
                              product: product,
                            );
                    }).toList()
              )
    );
              
  }
  renderSearchState(BuildContext context, AppState state){
    if(state.searchComplete){
      if(state.searchResult.length > 0)
        return _renderProducts(context, state);
      return Container(child: Center(child: Text('No Product(s) found'),));
    }
    return Container();
  }
  Widget _renderSearchResult(BuildContext context, AppState state){
    if(state.searchComplete){
      if(state.searchResult.length > 0){
        
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      child: TitleText(text: 'Searching for'),
                    ),
                    Container(
                      child: Text('Found(${state.searchResult.length})', 
                      style: TextStyle(color: LightColor.red, fontSize: 12),)
                    )
                ]
              ),
              SizedBox(height: 4),
              _renderSearchSuggestion(state)
            ],)
        );
      }
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      child: TitleText(text: 'Searching for'),
                    ),
                    Container(
                      child: Text('Found(${state.searchResult.length})', 
                      style: TextStyle(color: LightColor.red, fontSize: 12),)
                    )
                ]
              ),
              SizedBox(height: 4),
              _renderSearchSuggestion(state)
            ],)
        );
    }
    return Container();
  }
  Widget _renderSearchSuggestion(AppState state){
    if(state.searchString.startsWith('Search for:')){
      var category = state.searchString.split(':')[1];
      return Container(
                child: Text(
                  '$category > All Products'
                ),
              );
    }
    return Container(
                child: Text(
                  'All Categories > ${state.searchString}'
                ),
              );
  }
  @override
  Widget build(BuildContext context) {
    appContext = context;
    return StoreConnector<AppState, AppState>(
      builder: (BuildContext context, state){
        appState = state;
        return Scaffold(
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _appBar(context, state),
                    SizedBox(height: 10.0),
                    _renderSearchResult(context, state),
                    Expanded(
                      child:  SingleChildScrollView(
                          child: Column(
                            children:[ 
                              Container(
                                      height: AppTheme.fullHeight(context) - 20,
                                      margin: EdgeInsets.only(bottom: 120),
                                      child: renderSearchState(context, state)
                                ),
                              
                            ]
                          )
                      )
                   )
                    
                  ]
                )
            )
            )
            ,)
        );
      }, 
      converter: (store) => store.state);
  }
}