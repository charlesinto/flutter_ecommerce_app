import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/model/app_adProduct.dart';
import 'package:flutter_ecommerce_app/src/model/app_cartlist.dart';
import 'package:flutter_ecommerce_app/src/model/app_product.dart';
import 'package:flutter_ecommerce_app/src/model/app_state.dart';
import 'package:flutter_ecommerce_app/src/model/app_user.dart';
import 'package:flutter_ecommerce_app/src/model/category.dart';
import 'package:flutter_ecommerce_app/src/model/data.dart';
import 'package:flutter_ecommerce_app/src/redux/actions.dart';
import 'package:flutter_ecommerce_app/src/themes/light_color.dart';
import 'package:flutter_ecommerce_app/src/themes/theme.dart';
import 'package:flutter_ecommerce_app/src/wigets/prduct_icon.dart';
import 'package:flutter_ecommerce_app/src/wigets/title_text.dart';
import 'package:flutter_ecommerce_app/util/app.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ProductDetailPage extends StatefulWidget {
  ProductDetailPage({Key key}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
         CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  AppProduct _selectedProduct;

  bool isLiked = true;
  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: _icon(Icons.arrow_back_ios,
                color: Colors.black54, size: 15, padding: 12, isOutLine: true),
          ),
          InkWell(
            onTap: () {
              setState(() {
                isLiked = !isLiked;
              });
            },
            child: _icon(isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? LightColor.red : LightColor.lightGrey,
                size: 15,
                padding: 12,
                isOutLine: false),
          )
        ],
      ),
    );
  }

  Widget _icon(IconData icon,
      {Color color = LightColor.iconColor,
      double size = 20,
      double padding = 10,
      bool isOutLine = false}) {
    return Container(
      height: 40,
      width: 40,
      padding: EdgeInsets.all(padding),
      // margin: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(
            color: LightColor.iconColor,
            style: isOutLine ? BorderStyle.solid : BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(13)),
        color:
            isOutLine ? Colors.transparent : Theme.of(context).backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Color(0xfff8f8f8),
              blurRadius: 5,
              spreadRadius: 10,
              offset: Offset(5, 5)),
        ],
      ),
      child: Icon(icon, color: color, size: size),
    );
  }

  _onAlertButtonPressed(context, AppProduct product, Cart cartItem)  async{
    try{
        int orderNumber = 0;
        App.isLoading(context);
        print(product.orderNumber.toString());
        List<AppProduct> cart = cartItem.products;
        AppProduct doc =  cart.firstWhere((AppProduct element) => element.id == product.id, orElse: () => null);
        if(doc != null){
          // get the index

          int index = cart.indexOf(doc);
          orderNumber = cart[index].orderNumber + 1;
          print(orderNumber);
        }else{
          orderNumber = 1;
        }
        await App.addProductToCart(product.id, orderNumber);
        App.stopLoading(context);
        Alert(
          context: context,
          type: AlertType.success,
          title: "Add to cart",
          desc: "Product added to cart successfully",
          buttons: [
            DialogButton(
              color: LightColor.orange,
              child: Text(
                "Continue",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            ),
            DialogButton(
              color: Colors.white,
              child: Text(
                "Buy Now",
                style: TextStyle(color: Colors.orange, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                StoreProvider.of<AppState>(context).dispatch(BottomIconSelected(2));
                Navigator.of(context).pushNamed('/');
              },
              width: 120,
            )
          ],
        ).show();

    }catch(error){
      App.stopLoading(context);
      print(error);
    }
  }


  Widget _productImage(AppProduct selectedProduct, BuildContext context2) {
    print(selectedProduct.name);
    return AnimatedBuilder(
      builder: (context, child) {
        return AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: animation.value,
          child: child,
        );
      },
      animation: animation,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          TitleText(
            text: selectedProduct.name,
            fontSize: 20,
            color: LightColor.lightGrey,
          ),
          Image.network(selectedProduct.mainImageUrl, 
            width: AppTheme.fullWidth(context2),
            fit: BoxFit.contain,)
          // Image.asset('assets/show_1.png')
        ],
      ),
    );
  }

  Widget _categoryWidget(AppProduct selectedProduct) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0),
      width: AppTheme.fullWidth(context),
      height: 80,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              AppData.showThumbnailList.map((x) => _thumbnail(x)).toList()),
    );
  }

  Widget _thumbnail(String image) {
    return AnimatedBuilder(
        animation: animation,
        //  builder: null,
        builder: (context, child) => AnimatedOpacity(
              opacity: animation.value,
              duration: Duration(milliseconds: 500),
              child: child,
            ),
        child: Container(
          height: 40,
          width: 50,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: LightColor.grey,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(13),
            ),
            // color: Theme.of(context).backgroundColor,
          ),
          child: Image.asset(image),
        ));
  }

  Widget _detailWidget(AppProduct selectedProduct) {
    return DraggableScrollableSheet(
      maxChildSize: .8,
      initialChildSize: .4,
      minChildSize: .4,
      builder: (context, scrollController) {
        return Container(
          padding: AppTheme.padding.copyWith(bottom: 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Colors.white),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: 5),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                        color: LightColor.iconColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TitleText(text: selectedProduct.name, fontSize: 25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              TitleText(
                                text: "NGN ",
                                fontSize: 18,
                                color: LightColor.red,
                              ),
                              TitleText(
                                text: App.formatAsMoney(selectedProduct.finalPrice),
                                fontSize: 25,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              /*
                                  Icons.start
                                  color: LightColor.yellowColor
                              */
                              Icon(Icons.star_border,
                                   size: 17),
                              Icon(Icons.star_border,
                                   size: 17),
                              Icon(Icons.star_border,
                                   size: 17),
                              Icon(Icons.star_border,
                                   size: 17),
                              Icon(Icons.star_border, size: 17),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // _availableSize(),
                SizedBox(
                  height: 20,
                ),
                // _availableColor(),
                // SizedBox(
                //   height: 20,
                // ),
                _description(selectedProduct.description),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _availableSize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "Available Size",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _sizeWidget("US 6"),
            _sizeWidget("US 7", isSelected: true),
            _sizeWidget("US 8"),
            _sizeWidget("US 9"),
          ],
        )
      ],
    );
  }

  Widget _sizeWidget(String text,
      {Color color = LightColor.iconColor, bool isSelected = false}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
            color: LightColor.iconColor,
            style: !isSelected ? BorderStyle.solid : BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color:
            isSelected ? LightColor.orange : Theme.of(context).backgroundColor,
      ),
      child: TitleText(
        text: text,
        fontSize: 16,
        color: isSelected ? LightColor.background : LightColor.titleTextColor,
      ),
    );
  }

  Widget _availableColor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "Available Size",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _colorWidget(LightColor.yellowColor, isSelected: true),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.lightBlue),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.black),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.red),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.skyBlue),
          ],
        )
      ],
    );
  }

  Widget _colorWidget(Color color, {bool isSelected = false}) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: color.withAlpha(150),
      child: isSelected
          ? Icon(
              Icons.check_circle,
              color: color,
              size: 18,
            )
          : CircleAvatar(radius: 7, backgroundColor: color),
    );
  }

  Widget _description(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "Description",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Text(description),
      ],
    );
  }

  FloatingActionButton _flotingButton(BuildContext context, AppProduct _product, Cart cart) {
    return FloatingActionButton(
      onPressed: () {
        print(_product);
        StoreProvider.of<AppState>(context).dispatch(AddPrductToCart(_product));
        _onAlertButtonPressed(context, _product, cart);
      },
      backgroundColor: LightColor.orange,
      child: Icon(Icons.shopping_cart,

          color: Colors.white),
    );
  }
  Future<Cart> getCart() async{
      User user = await App.getCurrentUser();
      var cart = await  App.getUserCart(user.token);
      return cart;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCart(),
      builder: (BuildContext context, AsyncSnapshot<Cart> snapshot){
        return StoreConnector<AppState, AppState>(
        builder: (BuildContext context, state){
          _selectedProduct = state.selectedProduct;
          return Scaffold(
            floatingActionButton: _flotingButton(context, _selectedProduct, snapshot.data),
            body: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [
                      Color(0xfffbfbfb),
                      Color(0xfff7f7f7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          _appBar(),
                          _productImage(_selectedProduct, context),
                          _categoryWidget(_selectedProduct),
                        ],
                      ),
                      _detailWidget(_selectedProduct)
                    ],
                  ),
                ),
              )
          );
        },
         converter: (store) => store.state
      );
      },
      );
  }
}
