import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/model/app_product.dart';
import 'package:flutter_ecommerce_app/src/themes/light_color.dart';
import 'package:flutter_ecommerce_app/src/themes/theme.dart';
import 'package:flutter_ecommerce_app/src/wigets/product_search.dart';


class SellerProduct extends StatefulWidget{
  List<AppProduct> products = [];
  SellerProduct();

  SellerProduct.anotherConstructor(this.products);
  @override
  State<StatefulWidget> createState() => _SellerProductState();
}

class _SellerProductState extends State<SellerProduct>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    products = widget.products;
  }
  List<AppProduct> products = [];
  final TextEditingController _searchQuery = TextEditingController();
  Timer debounceTimer;
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
    }catch(error){
      print('search error: '+ error);
    }
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
  Widget searchEntryField(){
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
  Widget _renderProducts(BuildContext context){
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

                    children: products.map((product){
                      return ProductCardSearch(
                              product: product,
                            );
                    }).toList()
              )
    );
              
  }
  // renderSearchState(BuildContext context){
  //   if(state.searchComplete){
  //     if(state.searchResult.length > 0)
  //       return _renderProducts(context, state);
  //     return Container(child: Center(child: Text('No Product(s) found'),));
  //   }
  //   return Container();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: CircleAvatar(backgroundColor: LightColor.orange,radius: 30,
      //       child: IconButton(icon: Icon(Icons.add, color: Colors.white), iconSize: 40.0, onPressed: (){}, )) ,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
          child: Column(
              children: <Widget>[
                _appBar(context),
                SizedBox(height: 10),
                Expanded(child: SingleChildScrollView(
                  child: Container(
                    height: AppTheme.fullHeight(context) - 20,
                    margin: EdgeInsets.only(bottom: 120),
                    width: AppTheme.fullWidth(context),
                    child: _renderProducts(context) ,)
                ))

              ],
            ) ,
        )
        ) ,
        )
    );
  }
}