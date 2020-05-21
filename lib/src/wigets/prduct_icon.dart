import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/model/app_product_category.dart';
import 'package:flutter_ecommerce_app/src/model/app_searchCategory.dart';
import 'package:flutter_ecommerce_app/src/themes/light_color.dart';
import 'package:flutter_ecommerce_app/src/themes/theme.dart';
import 'package:flutter_ecommerce_app/src/wigets/title_text.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_ecommerce_app/src/model/app_state.dart';
import 'package:flutter_ecommerce_app/src/redux/actions.dart';

class ProducIcon extends StatelessWidget {
  // final String imagePath;
  // final String text;
  // final bool isSelected;
  // final  Category model;
  final ProductCategory model;
  final BuildContext context;
  ProducIcon({Key key,this.model, this.context})
      : super(key: key);

  Widget build(BuildContext context) {
    return model.id == null ? Container(width: 5,)
    : GestureDetector(
        onTap: () {
          StoreProvider.of<AppState>(this.context).dispatch(SearchByCategory(SearchProductsByCategory(context: this.context, category: this.model)));
        },
        child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        padding: AppTheme.hPadding,
        alignment: Alignment.center,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: model.isSelected ? LightColor.background : Colors.transparent,
          border: Border.all(
              color: model.isSelected ? LightColor.orange : LightColor.grey,
              width: model.isSelected ? 2 : 1),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: model.isSelected ?  Color(0xfffbf2ef) : Colors.white,
              blurRadius: 10,
                spreadRadius: 5,
                offset: Offset(5,5)
                ),
          ],
        ),
        child: Row(
          children: <Widget>[
            model.image != null ? Image.asset(model.image) : SizedBox(),
            model.name == null ? Container()
            : Container(
              child: TitleText(
                text: model.name,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            )
          ],
        ),
      )
    );
  }
}
