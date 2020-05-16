import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/model/app_advert_product.dart';
import 'package:flutter_ecommerce_app/src/model/app_product.dart';
import 'package:flutter_ecommerce_app/src/model/app_product_category.dart';
import 'package:flutter_ecommerce_app/src/model/app_state.dart';
import 'package:flutter_ecommerce_app/src/model/app_state_products.dart';
import 'package:flutter_ecommerce_app/src/model/app_user.dart';
import 'package:flutter_ecommerce_app/src/model/data.dart';
import 'package:flutter_ecommerce_app/src/model/product.dart';
import 'package:flutter_ecommerce_app/src/redux/actions.dart';
import 'package:flutter_ecommerce_app/src/themes/light_color.dart';
import 'package:flutter_ecommerce_app/src/themes/theme.dart';
import 'package:flutter_ecommerce_app/src/wigets/BottomNavigationBar/bootom_navigation_bar.dart';
import 'package:flutter_ecommerce_app/src/wigets/prduct_icon.dart';
import 'package:flutter_ecommerce_app/src/wigets/product_adcart.dart';
import 'package:flutter_ecommerce_app/src/wigets/product_card.dart';
import 'package:flutter_ecommerce_app/src/wigets/title_text.dart';
import 'package:flutter_ecommerce_app/util/app.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    FocusNode _focus = new FocusNode();
    @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }
  void _onFocusChange(){
    print("Focus: "+_focus.hasFocus.toString());
  }
  Widget _icon(IconData icon, {Color color = LightColor.iconColor}) {
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

  Widget _categoryWidget(List<ProductCategory> categories) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: AppTheme.fullWidth(context),
      height: 80,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: categories
              .map((category) => ProducIcon(
                    model: category,
                  ))
                  
              .toList())
          // children: AppData.categoryList
          //     .map((category) => ProducIcon(
          //           model: category,
          //         ))

          //     .toList()),
    );
  }

  Widget _productWidget(List<AppProduct> product) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Container(
                padding: EdgeInsets.symmetric( horizontal: 20.0),
                child: TitleText(
                  text: 'Featured Products',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                )
              ),
              Container(
                
                margin: EdgeInsets.symmetric(vertical: 10),
                width: AppTheme.fullWidth(context),
                height: AppTheme.fullWidth(context) * .7,
                child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 4 / 3,
                        mainAxisSpacing: 30,
                        crossAxisSpacing: 20), 
                    padding: EdgeInsets.only(left: 20),
                    scrollDirection: Axis.horizontal,
                    // children: AppData.productList
                    //     .map((product) => ProductCard(
                    //           product: product,
                    //         ))
                    //     .toList()),
                    children: product.map((product) => ProductCard(
                              product: product,
                            ))
                        .toList()),
              )
        ],)
    );
  }


  Widget _homeProductWidget(List<AppProduct> product) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: TitleText(
                  text: 'Flash Sales Products',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                )
              ),
              Container(
                
                margin: EdgeInsets.symmetric(vertical: 10),
                width: AppTheme.fullWidth(context),
                height: AppTheme.fullWidth(context) * .7,
                child: GridView(
                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 4 / 3,
                        mainAxisSpacing: 30,
                        crossAxisSpacing: 20), 
                    padding: EdgeInsets.only(left: 20),
                    scrollDirection: Axis.horizontal,
                    // children: AppData.productList
                    //     .map((product) => ProductCard(
                    //           product: product,
                    //         ))
                    //     .toList()),
                    children: product.map((product) => ProductCard(
                              product: product,
                            ))
                        .toList()),
              )
        ],)
    );
  }

  Widget _search(BuildContext context) {
    return Container(
      margin: AppTheme.padding,
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () => searchProduct(context),
              child:  Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: LightColor.lightGrey.withAlpha(100),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: GestureDetector(
                onTap: () => searchProduct(context),
                child: TextField(
                enabled: false,
                focusNode: _focus,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Products",
                    hintStyle: TextStyle(fontSize: 12),
                    contentPadding:
                        EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 5),
                    prefixIcon: Icon(Icons.search, color: Colors.black54)),
              ),
              )
            )
            )
          ),
          SizedBox(width: 20),
          GestureDetector(
            onTap: (){
              loadProductCategory(context);
            },
            child: _icon(Icons.filter_list, color: Colors.black54)
          ),
        ],
      ),
    );
  }

  loadProductCategory(BuildContext context) async{
      App.isLoading(context);
      var categories = await App.getProductCategories(start: 0, stop: 100);
      App.stopLoading(context);
      var deviceHeight = MediaQuery.of(context).size.height;
      var deviceWidth = MediaQuery.of(context).size.width;
      return showDialog(context: context, 
        builder: (BuildContext context){
          return Dialog(
            child: Container(
            width: deviceWidth * 0.6,
            height: deviceHeight * 0.6 > 380 ? 380 : deviceHeight * 0.6 ,
            padding: EdgeInsets.only(bottom: 16.0, top: 20.0, left: 16.0, right: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: TitleText(text:'Search By Category')
                  ),
                  SizedBox(height: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: categories.map((entry){
                      return ListTile(
                        onTap: (){
                          searchByProductCategory(context, entry);
                        },
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: LightColor.getBackgroundColor(entry.name),
                          child: Center(child: 
                            Text(entry.name.substring(0,1).toUpperCase(),
                              style: TextStyle(color: Colors.white),
                            )
                          ),
                        ),
                        title: Text(entry.name) ,);
                    }).toList()
                  ) 
                ]
              ),
            )
          ),
          );
        }
      );

  }

  searchByProductCategory(BuildContext context, ProductCategory category){
      Navigator.pop(context);
      Navigator.of(context).pushNamed('/search');
      StoreProvider.of<AppState>(context).dispatch(SearchByCategory(category));
  }

  searchProduct(BuildContext context){
    return Navigator.of(context).pushNamed('/search');
  }

 Future<AppStateProducts> _initializeApp(BuildContext context) async{
   AppStateProducts appStateProducts;
    try{
      List<AppProduct> _featuredproducts = await App.getProducts('/api/v1/user/product/get-featured-products/0/20');
      
      List<AppProduct> _homeProducts = await App.getProducts('/api/v1/user/product/get-featured-products/0/20');
      List<ProductCategory> _categories = await App.getProductCategories();
     
      List<AdvertProduct> _adcategories = await App.getProductAdvertCategories();
      
      User user = await App.getCurrentUser();
      
      // var cart = await  App.getUserCart(user.token);
      appStateProducts = AppStateProducts(featuredProducts: _featuredproducts, homeProducts: _homeProducts,
                             categories: _categories, advertCategory: _adcategories, cart: null );
      return appStateProducts ;
    }catch(error){
      print(error);
      return null;
    }
  }

  Widget _advertWidget(AdvertProduct advert){
      // print(advert.name);
      print('name: ' + advert.name + ' lenght: '+ advert.productAd.length.toString());
      if(advert.productAd.length <= 0){
        return Container();
      }
      return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Container(
                padding: EdgeInsets.symmetric( horizontal: 20.0),
                child: TitleText(
                  text: advert.name,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                )
              ),
              Container(
                
                margin: EdgeInsets.symmetric(vertical: 10),
                width: AppTheme.fullWidth(context),
                height: AppTheme.fullWidth(context) * .7,
                child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1 / 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20), 
                    padding: EdgeInsets.only(left: 20),
                    scrollDirection: Axis.horizontal,
                    // children: AppData.productList
                    //     .map((product) => ProductCard(
                    //           product: product,
                    //         ))
                    //     .toList()),
                    children: advert.productAd.map((product) => ProductCard (
                              product: product,
                            ))
                        .toList()),
              )
        ],)
    );
  }

  Widget _adverCategoryWidgets(List<AdvertProduct> adverts){
    
    return Container(
      child: Column(
        children: adverts.map((advert) {
            return _advertWidget(advert);
        }).toList()
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          future: _initializeApp(context),
          builder: (BuildContext context, AsyncSnapshot<AppStateProducts> snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasData){
                      return StoreConnector<AppState, AppState>(
                        builder: (BuildContext context, state){
                          return ListView(
                                physics: ScrollPhysics(), // to disable GridView's scrolling
                                shrinkWrap: true,
                                children: <Widget>[
                                  _search(context),
                                   _categoryWidget(snapshot.data.categories),
                                   _productWidget(snapshot.data.featuredProducts),
                                   _homeProductWidget(snapshot.data.homeProducts),
                                   _adverCategoryWidgets(snapshot.data.advertCategory)
                                ]

                              );
                        }, converter: (store) => store.state
                      );
                    
                   
              }
              return Column(
                  children: [
                    _search(context),
                  ]
                );
            }
            return Column(
              children: [
                _search(context),
                SizedBox(height: 40,),
                Center(
                  child: CircularProgressIndicator()
                )
              ]
            );
          }
        );
  }
}


