import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecommerce_app/src/model/app_user.dart';
import 'package:flutter_ecommerce_app/src/themes/light_color.dart';
import 'package:flutter_ecommerce_app/src/themes/theme.dart';
import 'package:flutter_ecommerce_app/src/wigets/title_text.dart';
import 'package:flutter_ecommerce_app/util/app.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'dart:async';

class AzonkaPay extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _AzonkaPayState();
}

class _AzonkaPayState extends State<AzonkaPay> with SingleTickerProviderStateMixin{
  @override
  void initState(){
    super.initState();
   animationController = new AnimationController(
     vsync: this,
      duration: new Duration(seconds: 3),
    );

    animationController.addListener(() {
      this.setState(() {});
    });
    animationController.forward();
    verticalPosition = Tween<double>(begin: 0.0, end: 300.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.linear))
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          animationController.reverse();
        } else if (state == AnimationStatus.dismissed) {
          animationController.forward();
        }
      });

  }
  GlobalKey<ScaffoldState> _drawerWidget = GlobalKey<ScaffoldState>();
  AnimationController animationController;
  Animation<double> verticalPosition;
  Future<User> getCurrentUser() async{
    var user = await App.getCurrentUser();
    return user;
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
      );
  }
   Widget _getInfo() {
    return Positioned(
      top: 150,
      left: 0,
      child: Container(
        margin: const EdgeInsets.all(20),
        height: 150,
        width: MediaQuery.of(context).size.width * 0.90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(
                height: 20,
              ),
              Align(
                
                alignment: Alignment.bottomRight,
                child:Container(
                  child:  RaisedButton.icon(
                  
                  color: Colors.green,
                  onPressed: (){
                    _scanCode(context);
                  },
                  label: Text('Scan To Pay', style: TextStyle(color: Colors.white),),
                  icon: Icon(Icons.camera_alt, color: Colors.white,)
                )
                )
              )
            ],
          ),
        ),
      ),
    );
  }
  _scanCode(BuildContext context) async{
    try{
      var result = await BarcodeScanner.scan();
      print(result);
    } on PlatformException catch(ex){
      if(ex.code == BarcodeScanner.cameraAccessDenied){
        return App.showActionError(context,message: 'Camera access is denied');
      }
      print(ex);
      return App.showActionError(context, message: 'Action could not be performed ${ex.code}');
    }
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
              // Navigator.of(context).pop();
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
          // color: Theme.of(context).backgroundColor,
          // boxShadow: AppTheme.shadow
        ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
   Widget _blueColor() {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [LightColor.primaryAccent, LightColor.darkColor]
                  )
        ),
        height: 250,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              children: [
                  _appBar(),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        child: TitleText(text: 'Azonka Pay', color: Colors.white,)
                      )
                    )
              ]
            ) 
          )
        ),
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
  
 

  

  void showInSnackBar(String message) {
    _drawerWidget.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _drawerWidget,
      endDrawer: Drawer(
        child: FutureBuilder(
              builder: (BuildContext context, snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  if(snapshot.hasData){
                    return _appDrawer(context, snapshot.data);
                  }
                }
                return _appDrawer(context, null);
              },
              future: getCurrentUser(),)
      ),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                  SingleChildScrollView(
                    child: Container(
                        height: AppTheme.fullHeight(context),
                        width: MediaQuery.of(context).size.width,
                      )
                  ),
                  _blueColor(),
                  _getInfo()
              ]
            ) ,
            )
        ) ,
        )
    );
  }
}