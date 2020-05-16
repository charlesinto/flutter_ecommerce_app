import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/model/app_adProduct.dart';
import 'package:flutter_ecommerce_app/src/model/app_product.dart';
import 'package:flutter_ecommerce_app/src/model/app_state.dart';
import 'package:flutter_ecommerce_app/src/redux/actions.dart';
import 'package:flutter_ecommerce_app/src/themes/light_color.dart';
import 'package:flutter_ecommerce_app/src/themes/theme.dart';
import 'package:flutter_ecommerce_app/src/wigets/product_adcart.dart';
import 'package:flutter_ecommerce_app/src/wigets/product_card.dart';
import 'package:flutter_ecommerce_app/src/wigets/product_search.dart';
import 'package:flutter_ecommerce_app/util/app.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SearchPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage>{
  
  String _searchString = "";
  bool isSearched = false;
  List<AppProduct> _products = [];
  Widget _appBar(BuildContext context) {
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
            child: searchEntryField() ,),
            SizedBox(width: 8.0,),
            GestureDetector(
              onTap: (){
                searchValue(context);
              },
              child: Text('Search'),)
        ],
      ),
    );
  }
  searchValue(BuildContext context) async{
    try{
      setState(() {
        isSearched =  false;
      });
      App.isLoading(context);
    List<AppProduct> products = await App.searchProduct(_searchString);
    // await StoreProvider.of<AppState>(context).dispatch(SearchProduct());
    print(products.length);
    App.stopLoading(context);
    
    setState(() {
      _products = products;
      isSearched = true;
    });
    }catch(error){
      App.stopLoading(context);
      print('search error: '+ error.toString());
    }
  }
  Widget searchEntryField(){
    return Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: LightColor.lightGrey.withAlpha(100),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextField(
                onSubmitted: (value){
                  setState(() {
                    _searchString = value;
                  });
                  // StoreProvider.of<AppState>(context).dispatch(SearchStringChange(value));
                  searchValue(context);
                },
                autofocus: true,
                textInputAction: TextInputAction.search,
                autocorrect: false,
                onChanged: (value){
                  setState(() {
                    _searchString = value;
                  });
                  // StoreProvider.of<AppState>(context).dispatch(SearchStringChange(value));
                },
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
          // color: Theme.of(context).backgroundColor,
          // boxShadow: AppTheme.shadow
        ),
      child: Icon(
        icon,
        color: Colors.black,
      ),
    );
  }
  Widget _renderProducts(BuildContext context, AppState state){
    // print(_products[0].name);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: AppTheme.fullWidth(context),
      height: AppTheme.fullWidth(context),
      child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 20), 
                    scrollDirection: Axis.vertical,
                    // children: AppData.productList
                    //     .map((product) => ProductCard(
                    //           product: product,
                    //         ))
                    //     .toList()),

                    children: _products.map((product){
                      print(product.name);
                      return ProductCardSearch(
                              product: product,
                            );
                    }).toList()
              )
    );
              
  }
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      builder: (BuildContext context, state){
        return Scaffold(
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Container(
              padding: EdgeInsets.only(bottom: 60.0),  
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _appBar(context),
                    SizedBox(height: 40.0),
                     _renderProducts(context, state),
                    
                  ]
                )
              ),
            )
            )
            ,)
        );
      }, 
      converter: (store) => store.state);
  }
}