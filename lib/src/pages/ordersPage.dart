import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/model/app_order.dart';
import 'package:flutter_ecommerce_app/src/model/app_product.dart';
import 'package:flutter_ecommerce_app/src/themes/light_color.dart';
import 'package:flutter_ecommerce_app/util/app.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_ecommerce_app/src/wigets/title_text.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class OrderPage extends StatefulWidget{
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>{

  Future<List<Order>> getUserOrders() async{
    try{
      var orders = await App.getUserOrders();
      return orders;
    }catch(error){
      Alert(
          context: context,
          type: AlertType.error,
          title: "Action Error",
          desc: "Some errors were encountered fetching your orders",
          buttons: [
            DialogButton(
            
              color: Colors.white,
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.orange, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              width: 120,
            )
          ],
        ).show();
      return null;
    }
  }
  List<Widget> _renderOrderProducts(Order _order){
    return _order.products.map((AppProduct product){

      return Container(
      height: 80,
      child: Row(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.2,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 70,
                    width: 70,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            decoration: BoxDecoration(
                                color: LightColor.lightGrey,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  // left: -20,
                  // bottom: -20,
                  child: Image.network(product.mainImageUrl,
                      height: 75.0,
                      width: 75.0, 
                      fit: BoxFit.cover,
                    )
                )
              ],
            ),
          ),
          Expanded(
              child: ListTile(
                  title: TitleText(
                    text: product.name,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      TitleText(
                        text: 'NGN ',
                        color: LightColor.red,
                        fontSize: 12,
                      ),
                      TitleText(
                        text:App.formatAsMoney(product.finalPrice),
                        fontSize: 14,
                      ),
                    ],
                  ),
                  trailing: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                          Container(
                            width: 35,
                            height: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: LightColor.lightGrey.withAlpha(150),
                                borderRadius: BorderRadius.circular(10)),
                            child: TitleText(
                                    text: 'x${product.orderNumber}',
                                    fontSize: 12,
                                  )
                            
                          ),
                      ]
                    )
                  )
                  
                  
                   
                )
              )
        ],
      ),
    );
    }).toList();
  }
  _hanlderOrderViewDetail(BuildContext context, Order _order){
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    return showDialog(context: context,
      builder: (BuildContext context){
          return AlertDialog(
            content: Container(
              width: deviceWidth * 0.7 ,
              height: deviceHeight * 0.4 ,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: TitleText(
                        text: 'Your Products',
                        fontSize: 16,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    Divider(
                      height: 2.0
                    ),
                    SizedBox(height: 8.0),
                    Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:_renderOrderProducts(_order) ,)
                  ]
                )
              )
            ),
            actions: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0) ,
                child: RaisedButton(
                onPressed: (){ Navigator.pop(context);},
                color: LightColor.orange,
                child: Text('Ok'),
              )
              )
            ],);
      }
    );
  }
  _renderItem(BuildContext context, Order _order){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
                Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                    FlatButton(
                      onPressed: (){ _hanlderOrderViewDetail(context, _order);},
                      child: TitleText(
                        text: "View All(${_order.products.length})",
                        fontSize: 12,
                        color: LightColor.darkColor,
                        fontWeight: FontWeight.w600
                      ),
                    )
                ],
              ),
              Divider(height: 2.0,),
              ListTile(
                title: TitleText(
                  text: "#${_order.id.toString()}",
                  fontSize: 18,
                  fontWeight: FontWeight.w800
                ),
                subtitle: TitleText(
                  text: getOrderDate(_order.createdAt),
                  fontSize: 14,
                  color: Colors.grey,
                ),
                trailing: TitleText(
                  text: "NGN ${App.formatAsMoney(_order.totalAmount)}",
                  fontSize: 16,
                  color: LightColor.orange,
                ),
              )
          ],
        ),
      )
    );
  }
  Widget renderOrders(BuildContext context, List<Order> orders){
    return Container(
            child: Column(
                children: orders.map((order) {
                return Column(
                  children: [
                    _renderItem(context, order)
                  ]
                );
              }).toList()
          )
    );
  }
  String getOrderDate(int timeStamp){
    var date = DateTime.fromMicrosecondsSinceEpoch(timeStamp * 1000);
    // print(date);
    return date.toString();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 60.0),
      child: SingleChildScrollView(
        child: FutureBuilder(
          builder: (BuildContext context,AsyncSnapshot<List<Order>> snapshot){
            if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasData && snapshot.data.length > 0){
                  print(snapshot.data.length);
                  return Container(
                    padding: EdgeInsets.only(bottom: 60.0, top: 10.0),
                    child: Column(
                          children: [
                            renderOrders(context, snapshot.data)
                          ]
                        )
                  );
                }
                return Center(
                  child: TitleText(
                    text: 'Your order history is empty',
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                  )
                );
            }
            return Center(
              child: CircularProgressIndicator()
            );
          },
          future: getUserOrders() ,)
      )
    );
  }
}