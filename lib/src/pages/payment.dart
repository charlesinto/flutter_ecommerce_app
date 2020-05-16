import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecommerce_app/src/model/app_address.dart';
import 'package:flutter_ecommerce_app/src/model/app_cartlist.dart';
import 'package:flutter_ecommerce_app/src/model/app_product.dart';
import 'package:flutter_ecommerce_app/src/model/app_state.dart';
import 'package:flutter_ecommerce_app/src/model/app_user.dart';
import 'package:flutter_ecommerce_app/src/redux/actions.dart';
import 'package:flutter_ecommerce_app/util/app.dart';
import 'package:flutter_ecommerce_app/util/constants.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:flutter_ecommerce_app/src/themes/light_color.dart';
import 'package:flutter_ecommerce_app/src/themes/theme.dart';
import 'package:flutter_ecommerce_app/src/wigets/title_text.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
// import 'package:paystack_flutter/paystack_flutter.dart';

class Payment extends StatefulWidget{
  @override
  _PaymentState createState() => _PaymentState();
}





class _PaymentState extends State<Payment>{
  
  GlobalKey<ScaffoldState> _drawerWidget = GlobalKey<ScaffoldState>();
  String _paymentTypeValue ="card";
  String _deliveryAddressSelected = "";
  Charge charge = Charge();
  String transcation = "";
  bool _inProgress = false;
  String _cardNumber;
  String _cvv;
  int _expiryMonth = 0;
  int _expiryYear = 0;
  String _addressString = "";
  // static const platform = const MethodChannel('maugost.com/paystack_flutter');
  static const paystack_backend_url = "https://infinite-peak-60063.herokuapp.com";

  void initState() {
    PaystackPlugin.initialize(
            publicKey: pStackPublicKey);
    super.initState();
  }
  Widget _appDrawer(BuildContext context, User user){
    return Column(
      children: [
         Container(
            height: 180,
            color: LightColor.primaryAccent,
            child: Container(
              color: LightColor.primaryAccent,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.asset('assets/logo.png',
                        fit: BoxFit.cover,
                        width: 75,
                        height:75,
                      ),
                    // CircleAvatar(
                    //   radius: 20,
                    //   backgroundColor: Colors.white,
                    //   child: Image.asset('assets/logo.png',
                    //     fit: BoxFit.contain,
                    //     width: 200,
                    //     height:200,
                    //   ),)
                  ),
                  Container(
                    child: TitleText(
                      color: Colors.white ,
                      text: user == null ? '' : "${user.firstName} ${user.lastName}",
                      fontSize: 27,
                      fontWeight: FontWeight.w700,
                    ),
                    ),

                  Container(
                    child: TitleText(
                      color: Colors.white ,
                      text: user == null ? '' : "${user.email}",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    )
              ],) ,
            )
        ),
        Expanded(
          // flex: 6,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: SingleChildScrollView(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(Icons.home, color: LightColor.lightColor),
                    title: TitleText(
                            color: Colors.black ,
                            text: 'Home',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ) ,
                  ),
                  ListTile(
                    leading: Icon(Icons.history, color: LightColor.lightColor),
                    title: TitleText(
                            color: Colors.black ,
                            text: 'My Orders',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ) ,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed('/wallet'),
                    child: ListTile(
                        leading: Icon(Icons.card_membership, color: LightColor.lightColor),
                        title: TitleText(
                                color: Colors.black ,
                                text: 'Azonka Wallet',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ) ,
                      ),
                  ),
                  ListTile(
                    leading: Icon(Icons.credit_card, color: LightColor.lightColor),
                    title: TitleText(
                            color: Colors.black ,
                            text: 'Azonka Pay',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ) ,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed('/settings');
                    },
                    child: ListTile(
                      leading: Icon(Icons.settings, color: LightColor.lightColor),
                      title: TitleText(
                              color: Colors.black ,
                              text: 'Settings',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ) ,
                    )
                  ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed('/customerService');
                      },
                      child: ListTile(
                        leading: Icon(Icons.call, color: LightColor.lightColor),
                        title: TitleText(
                                color: Colors.black ,
                                text: 'Costumer Service',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ) ,
                      )
                    ),
                  ListTile(
                    leading: Icon(Icons.store, color: LightColor.lightColor),
                    title: TitleText(
                            color: Colors.black ,
                            text: 'My Store',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ) ,
                  ),
                  GestureDetector(onTap: (){ _signOutUser(context);},
                    child: ListTile(
                    leading: Icon(Icons.arrow_back_ios, color: LightColor.lightColor),
                    title: TitleText(
                            color: Colors.black ,
                            text: 'Sign Out',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ) ,
                  )
                  ,)
                  
                ]
              )
            )
          )
        )
      ],
    );
  }
  _signOutUser(BuildContext context) async{
      App.isLoading(context);
      var isSignedOut =  await App.signOutUser();
      App.stopLoading(context);
      return isSignedOut ? Navigator.of(context).pushReplacementNamed('/login') : Alert(
                                context: context,
                                type: AlertType.error,
                                title: "Action Error",
                                desc: "Some errors were encountered signing you out",
                                buttons: [
                                  DialogButton(
                                    color: LightColor.orange,
                                    child: Text(
                                      "Ok",
                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    width: 120,
                                  )
                                ],
                              ).show();
  }
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
            child: _icon(Icons.arrow_back_ios, color: Colors.black54,),
          ),
          InkWell(
            onTap: () {
            },
            child: RotatedBox(
                  quarterTurns: 4,
                  child: GestureDetector(onTap: (){
                      _drawerWidget.currentState.openEndDrawer();
                  }, child: _icon(Icons.sort, color: Colors.black54) ),
                ),
          )
        ],
      ),
    );
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
  Widget _title(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: TitleText(
                  text: 'Checkout',
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                )
    );
  }
  Widget _detailWidget(Cart cart) {
    return DraggableScrollableSheet(
      maxChildSize: .8,
      initialChildSize: .2,
      minChildSize: .2,
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
            child: Container(
              margin: EdgeInsets.only(bottom: 80.0),
              child: SingleChildScrollView(
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
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 4.0),
                        child: TitleText(
                        text: 'Cart Summary',
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      )
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // _availableSize(),
                _item(cart.products),
                _totalDeliveryPrice(cart.products),
                _totalPrice(cart.products)
                // _availableColor(),
                // SizedBox(
                //   height: 20,
                // ),
                // _description(selectedProduct.description),
              ],
            )
            )
            ),
          ),
        );
      },
    );
  }
  Widget _totalDeliveryPrice(List<AppProduct> products){
    var total = 0;
    products.forEach((product){
      total += product.finalPrice * product.orderNumber;
    });

    return Row(
      // mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          flex: 3,
          child: Text(
          'Delivery/Shipping Fee',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Colors.black,
            
          ),
        ) ),
        SizedBox(width: 8.0),
        Expanded(
          flex: 1,
          child: TitleText(
          color: Colors.black,
          text: "NGN ${App.formatAsMoney(0)}",
          fontWeight: FontWeight.w400,
          fontSize: 15.0,
        ))
      ]
    );
  }
  Widget _totalPrice(List<AppProduct> products){
    var total = 0;
    products.forEach((product){
      total += product.finalPrice * product.orderNumber;
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          flex: 3,
          child: Text(
          'Total',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Colors.black,
            
          ),
        ) ),
        SizedBox(width: 8.0),
        Expanded(
          flex: 1,
          child: TitleText(
          color: Colors.black,
          text: "NGN ${App.formatAsMoney(total)}",
          fontWeight: FontWeight.w800,
          fontSize: 15.0,
        ))
      ]
    );
  }
  Widget _item(List<AppProduct> products){
    return Column(
      children: products.map((AppProduct product){
          return Column(
            children: [
            
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                    TitleText(
                      text: product.name.toUpperCase(),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                    Container(
                      child: Row(children: <Widget>[
                        TitleText(
                          color: Colors.red,
                          text: 'NGN',
                          fontSize: 14.0,
                        ),
                        SizedBox(
                          width: 8.0
                        ),
                        TitleText(
                          color: Colors.black,
                          text: "${App.formatAsMoney(product.finalPrice * product.orderNumber)}",
                          fontSize: 18.0,
                        )
                      ],
                      ),
                      
                    )
                ]
              ),
              
              _divider()
            ]
          );
      }).toList()
    );
  }
  Widget _divider(){
    return Divider(
            thickness: 1,
            height: 50,
          );
  }

   Widget _submitButton(BuildContext context, List<AppProduct> cart) {
    return InkWell(
      onTap: () {
        processPayment(context, cart);
      },
      child: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xff6be7ff), Color(0xff0085cb)]
              // colors: [Color(0xfffbb448), Color(0xfff7892b)]
              )),
            child: TitleText(
              text: 'Pay Now',
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          )
    );
  }
  Widget _dividerPaymentType() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('Payment Type'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
  Widget _payNowButton(BuildContext context, List<AppProduct> cart){
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      child: _submitButton(context, cart)
    );
  }
  Widget __dividerDeliveryLocation() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('Delivery Location'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
  Widget _paymentType(){
    return Row(
      children: [
        Expanded(
          child: ListTile(
        title: const TitleText(
          text: 'Card',
          fontSize: 16,
          fontWeight: FontWeight.w800
        ),
        leading: Radio(
          value: 'card',
          groupValue: _paymentTypeValue,
          onChanged: (String  value) {
            setState(() { _paymentTypeValue = value; }) ;
          },
        ),
      ) ,
        ),
        Expanded(
          child: ListTile(
            title: const  TitleText(
              text: 'Wallet',
              fontSize: 16,
              fontWeight: FontWeight.w800
            ),
            leading: Radio(
            
              value: 'wallet',
              groupValue: _paymentTypeValue,
              onChanged: (String  value) {
                setState(() { _paymentTypeValue = value; });
              },
            ),
          ) ,
        )
      ]
    );
    
  }
  Future<List<Address>> getUserAddress(BuildContext context) async{
    try{
      // App.isLoading(context);
      var response = await App.getUserAddress();
      return response;
      // App.stopLoading(context);
    }catch(error){
      print(error);
      App.stopLoading(context);
      return null;
    }
    
  }
  processPayment(BuildContext context, List<AppProduct> cart) async{
    if(_paymentTypeValue.isEmpty ){
        return Alert(
          context: context,
          type: AlertType.error,
          title: "Action error",
          desc: "Failed, please provide payment type",
          buttons: [
            DialogButton(
              color: LightColor.orange,
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            ),
          ],
        ).show();
    }
    if(_deliveryAddressSelected.isEmpty && _addressString.isEmpty){
      return Alert(
          context: context,
          type: AlertType.error,
          title: "Action error",
          desc: "Failed, please provide delivery location",
          buttons: [
            DialogButton(
              color: LightColor.orange,
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            ),
          ],
        ).show();
    }
    var total = 0;
    cart.forEach((AppProduct item) => total += item.orderNumber * item.finalPrice);
    var user = await App.getCurrentUser();
    // connectPaystack(user, total);
    if(_paymentTypeValue.toLowerCase() == 'card'){
        return _handleCheckout(context, total, user, cart, total);
    }else{
      if(!user.pinSet){
        return Alert(
            context: context,
            type: AlertType.error,
            title: "Action wallet",
            desc: "Wallet is not set, please kinldy set up wallet",
            buttons: [
              DialogButton(
                color: LightColor.orange,
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  StoreProvider.of<AppState>(context).dispatch(ClearCartItems());
                  Navigator.pop(context);
                },
                width: 120,
              ),
            ],
          ).show();
      }
      try{
          App.isLoading(context);
          await App.orderProduct("${total * 100}", '', cart, true, _deliveryAddressSelected, _addressString);
          
          cart.forEach( ( AppProduct product) async{
            await App.removeCartItem(product.id);
          });

          App.stopLoading(context);

          return Alert(
            context: context,
            type: AlertType.success,
            title: "Payment Successful",
            desc: "Payment successful, your order is been processed",
            buttons: [
              DialogButton(
                color: LightColor.orange,
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  StoreProvider.of<AppState>(context).dispatch(ClearCartItems());
                  Navigator.pop(context);
                },
                width: 120,
              ),
            ],
          ).show();
      }catch(error){
        print(error);
        String message = json.decode(error.body)['message'];
        return  Alert(
          context: context,
          type: AlertType.warning,
          title: "Payment error",
          desc: "${message.substring(0,50)}",
          buttons: [
            DialogButton(
              color: LightColor.orange,
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            ),
          ],
        ).show();
      }
    }
    
  }
  Widget _deliveryAddress(List<Address> userAddress){
     
      return  Container(
        // padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: userAddress.map<Widget>((address){
              return Column(
                children: [
                  ListTile(
                    title:   TitleText(
                      text:  "${address.address1}, ${address.state}, ${address.country}",
                      fontSize: 16,
                      fontWeight: FontWeight.w400
                    ),
                    leading: Radio(
                      value: "${address.id}",
                      groupValue: _deliveryAddressSelected,
                      onChanged: (value) {
                        setState(() { _deliveryAddressSelected = value; });
                      },
                    ),
                  ) ,
                  
                  _divider()
                ]
              );
          }).toList()
        )
      );
  }
  

  _handleCheckout(BuildContext context,int totalAmount, User user, 
    List<AppProduct> products, int amount) async {
   
    Charge charge = Charge()
      ..amount = totalAmount * 100 // In base currency
      ..email = user.email
      ..card = _getCardFromUI();

    
      charge.reference = _getReference();
    

    try {
      CheckoutResponse _cartResponse = await PaystackPlugin.checkout(
        context,
        method: CheckoutMethod.card,
        charge: charge,
        fullscreen: false,
        
      );
      
      print('Response = $_cartResponse');
      if(_cartResponse.message.toLowerCase() == 'success'){
        App.isLoading(context);
        // var cart = json.encode(products);
        print(_cartResponse);
        await App.orderProduct("${amount * 100}",
         _cartResponse.reference, products, false, _deliveryAddressSelected, _addressString);
        // print(response.body);
        products.forEach( ( AppProduct product) async{
          await App.removeCartItem(product.id);
        });

        App.stopLoading(context);
        return Alert(
            context: context,
            type: AlertType.success,
            title: "Payment Successful",
            desc: "Payment successful, your order is been processed",
            buttons: [
              DialogButton(
                color: LightColor.orange,
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  StoreProvider.of<AppState>(context).dispatch(ClearCartItems());
                  Navigator.pop(context);
                },
                width: 120,
              ),
            ],
          ).show();
      }
      // setState(() => _inProgress = false);
      // _updateStatus(response.reference, '$response');
    } catch (e) {
      String message = json.decode(e.body)['message'];
      App.stopLoading(context);
      print(e);
      return Alert(
          context: context,
          type: AlertType.error,
          title: "Payment error",
          desc: "${message.substring(0,50)}",
          buttons: [
            DialogButton(
              color: LightColor.orange,
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            ),
          ],
        ).show();
      // _showMessage("Check console for error");
      // throw e;
    }
  }

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: _cardNumber,
      cvc: _cvv,
      expiryMonth: _expiryMonth,
      expiryYear: _expiryYear,
    );
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  Widget _addressEntryField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Enter Delivery Adddress',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            scrollPadding: EdgeInsets.all(200),
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    onChanged: (value) {
                      setState(() {
                        _addressString = value;
                      });
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xfff3f3f4),
                        filled: true,
                    ))
          
        ],
      ),
    );
  }

  getUserLocationAddress(BuildContext context) async{
    try{
      var _locationData = await App.getUserLocation();
      print(_locationData);

      var response = await App.getAddressFromLocation(_locationData);
      var googleResonse = json.decode(response.body);
      print(response.body);
      if(googleResonse['status'] == "REQUEST_DENIED"){
        return App.showToast(context, 'Some error encountered while fetching location') ;
      }
      //update state with address
    }catch(error){
      print(error);
      throw error;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var deviceHeight = MediaQuery.of(context).size.height;
    return StoreConnector<AppState, AppState>(
      builder: (BuildContext context, state){
        return Scaffold(
          key: _drawerWidget,
          endDrawer: Drawer(
            child: _appDrawer(context, null)
          ),
          body: SafeArea(
            child: Container(
            
              child:  GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: deviceHeight * 0.65,
                      child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              _appBar(),
                              _title(),
                              SizedBox(
                                height: 20
                              ),
                              _dividerPaymentType(),
                               SizedBox(
                                height: 20
                              ),
                              _paymentType(),
                              SizedBox(
                                height:10
                              ),
                              
                              __dividerDeliveryLocation(),
                              SizedBox(
                                height: 4
                              ),
                              ListView(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                reverse: true,
                                children: [
                                  _addressEntryField(),
                                ].toList()
                              ),
                              SizedBox(
                                height: 5
                              ),
                              GestureDetector(
                                onTap: (){
                                  getUserLocationAddress(context);
                                },
                                child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 24.0),
                                child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Card(child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                    child: Row(children: [
                                    Icon(Icons.location_on,
                                      color: LightColor.primaryAccent
                                    ),
                                  SizedBox(width: 8.0),
                                  TitleText(
                                      text: 'Find my location',
                                      fontSize: 14.0,
                                      color: Colors.orangeAccent
                                    )
                                  ])
                                  ),)
                                ],
                              ),
                              )
                              ),
                              SizedBox(
                                height: 10
                              ),
                               
                              
                              Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Divider(
                                              thickness: 1,
                                            ),
                                          ),
                                        ),
                                        Text('My Delivery Addresses'),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Divider(
                                              thickness: 1,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                              FutureBuilder(
                                builder: (BuildContext context,AsyncSnapshot<List<Address>> snapshot){
                                  if(snapshot.connectionState == ConnectionState.done){
                                    if(snapshot.hasData){
                                      return _deliveryAddress(snapshot.data);
                                    }
                                  }
                                   return Container();
                                } ,
                                future: getUserAddress(context),
                              )
                          ]
                        )
                    )
                    ),
                    _detailWidget(state.userCart),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: _payNowButton(context, state.userCart.products)
                      )
                  ],
                )
              )
                
            ) ,)
        );
      }, 
      
      converter: (store) => store.state);
  }
}