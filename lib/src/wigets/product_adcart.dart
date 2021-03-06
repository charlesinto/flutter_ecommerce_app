import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/model/app_adProduct.dart';
import 'package:flutter_ecommerce_app/src/model/app_product.dart';
import 'package:flutter_ecommerce_app/src/model/data.dart';
import 'package:flutter_ecommerce_app/src/model/product.dart';
import 'package:flutter_ecommerce_app/src/themes/light_color.dart';
import 'package:flutter_ecommerce_app/src/themes/theme.dart';
import 'package:flutter_ecommerce_app/src/wigets/title_text.dart';

class ProductAdCard extends StatefulWidget {
  // final Product product;
  final ProductAd product;
  ProductAdCard({Key key, this.product}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductAdCard> {
  // Product model;
  ProductAd model;
  @override
  void initState() {
    model = widget.product;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/detail');
        setState(() {
          // model.isSelected = !model.isSelected;
        //   AppData.productList.forEach((x) {
        //     if (x.id == model.id && x.name == model.name) {
        //       return;
        //     }
        //     x.isSelected = false;
        //   });
        //   var m = AppData.productList
        //       .firstWhere((x) => x.id == model.id && x.name == model.name);
        //   m.isSelected = !m.isSelected;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: LightColor.background,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Color(0xfff8f8f8), blurRadius: 15, spreadRadius: 10),
          ],
        ),
        margin: EdgeInsets.symmetric(vertical: !model.isSelected ? 20 : 0),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(height: model.isSelected ? 15 : 0),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: LightColor.orange.withAlpha(40),
                    ),
                    // Image.asset('assets/shooe_tilt_1.png')
                    Image.network(model.mainImageUrl,
                      fit: BoxFit.contain,
                      height: 150.0,
                      width: 150.0,
                    )
                  ],
                ),
                // SizedBox(height: 5),
                TitleText(
                  text: model.name,
                  fontSize: model.isSelected ? 16 : 14,
                ),
                TitleText(
                  // text: model.price.toString(),
                  text: model.finalPrice.toString(),
                  fontSize: model.isSelected ? 18 : 16,
                ),
              ],
            ),
            Positioned(
              left: 0,
              top: 0,
              child: IconButton(
                icon: Icon(model.isLiked ? Icons.favorite : Icons.favorite_border, color: model.isLiked ? LightColor.red : LightColor.iconColor,),
                 onPressed: (){
                   setState(() {
                     model.isLiked = !model.isLiked ;
                   });
                 })
            )
          ],
        ),
      ),
    );
  }
}
