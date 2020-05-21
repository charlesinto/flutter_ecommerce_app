import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/model/app_advertpage_product.dart';
import 'package:flutter_ecommerce_app/src/model/app_product.dart';
import 'package:flutter_ecommerce_app/src/themes/light_color.dart';
import 'package:flutter_ecommerce_app/src/themes/theme.dart';
import 'package:flutter_ecommerce_app/src/wigets/product_card.dart';
import 'package:flutter_ecommerce_app/src/wigets/title_text.dart';
import 'package:flutter_ecommerce_app/util/app.dart';

class AdvertPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return _AdvertPageState();
  }
}

class _AdvertPageState extends State<AdvertPage>{
 List<AppProduct> product = [];
 Widget renderNewArrival(BuildContext context, List<AppProduct> product){
   return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Container(
                          padding: EdgeInsets.symmetric( horizontal: 20.0),
                          child: TitleText(
                            text: 'New Arrivals',
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          )
                        ),
                        Container(
                          
                          width: AppTheme.fullWidth(context),
                          height: AppTheme.fullHeight(context) * .39,
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
                  ],);
 }
 Widget renderProductsYoumayLike(BuildContext context, List<AppProduct> product){
   return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Container(
                padding: EdgeInsets.symmetric( horizontal: 20.0),
                child: TitleText(
                  text: 'Products you may like',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                )
              ),
              Container(
                
                width: AppTheme.fullWidth(context),
                height: AppTheme.fullHeight(context) * .39,
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
        ],);
 }
  Future<AdvertPageProduct> getProducts(BuildContext context) async{
    try{
      // App.isLoading(context);
      var products = await App.getProducts('/api/v1/user/product/get-homepage-products/0/5');
      var products2 = await App.getProducts('/api/v1/user/product/get-homepage-products/6/12');
      // App.stopLoading(context);
      return new AdvertPageProduct(newArrival: products, productYouMayLike: products2);
    }catch(error){
      // App.stopLoading(context);
      Navigator.of(context).pushReplacementNamed('/home');
      throw error;
    }
  }
@override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: getProducts(context),
              builder: (BuildContext context,AsyncSnapshot<AdvertPageProduct> snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  if(snapshot.hasData){
                    return Stack(
                        children: [
                            Container(
                              height: AppTheme.fullHeight(context) - 20,
                              child: SingleChildScrollView(
                                child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: 8.0),
                                        child: renderNewArrival(context, snapshot.data.newArrival)
                                      ),
                                        SizedBox(height: 10),
                                        Container(
                                            padding: EdgeInsets.symmetric(vertical: 8.0),
                                            child: renderProductsYoumayLike(context, snapshot.data.productYouMayLike),
                                          ),
                                        SizedBox(height: 10),
                                    ]
                                  ) ,
                              )
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                width: AppTheme.fullWidth(context),
                                child: Center(
                                  child: RaisedButton.icon(onPressed: (){
                                    Navigator.of(context).pushNamed('/home');
                                  }, icon: Icon(Icons.arrow_forward, color: Colors.white,), 
                                    label: Text('Continue to Home', style: TextStyle(color: Colors.white),), color: LightColor.orange,) ),)
                              )
                          ]
                        );
                  }
                }
                return Container(
                  height: AppTheme.fullHeight(context),
                  width: AppTheme.fullWidth(context),
                  child: Center(child: CircularProgressIndicator(),),
                );
              },)
          ),
        ),
      )
    );
  }
}