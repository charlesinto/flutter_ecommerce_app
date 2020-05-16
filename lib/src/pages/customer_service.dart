import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/model/app_user.dart';
import 'package:flutter_ecommerce_app/src/themes/light_color.dart';
import 'package:flutter_ecommerce_app/src/themes/theme.dart';
import 'package:flutter_ecommerce_app/src/wigets/title_text.dart';
import 'package:flutter_ecommerce_app/util/app.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CustomerService extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CustomerServiceState();
}

class _CustomerServiceState extends State<CustomerService>{
  GlobalKey<ScaffoldState> _drawerWidget = GlobalKey<ScaffoldState>();
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
                  ListTile(
                    leading: Icon(Icons.call, color: LightColor.lightColor),
                    title: TitleText(
                            color: Colors.black ,
                            text: 'Costumer Service',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ) ,
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
  Widget _title(){
    return TitleText(
                  text: 'Customer Service',
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                );
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
  Future<User> getCurrentUser() async{
    var user = await App.getCurrentUser();
    return user;
  }
  Widget _renderProducts(BuildContext context){
    // print(_products[0].name);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: AppTheme.fullWidth(context),
      height: AppTheme.fullWidth(context),
      child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                    // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 2,
                    //     childAspectRatio: 2 / 3,
                    //     mainAxisSpacing: 10,
                    //     crossAxisSpacing: 20), 
                    scrollDirection: Axis.vertical,
                    // children: AppData.productList
                    //     .map((product) => ProductCard(
                    //           product: product,
                    //         ))
                    //     .toList()),

                    children: [
                      _manageOrders(context),
                      _help(context),
                      _contactus(context)
                    ]
              )
    );
              
  }
  Widget _manageOrders(BuildContext context){
    return GestureDetector(
            onTap: (){},
            child: Container(
              decoration: BoxDecoration(
                    color: LightColor.background,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color(0xfff8f8f8), blurRadius: 15, spreadRadius: 10),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Center(
                    child: Text('Manage Your Orders',style: TextStyle( fontWeight: FontWeight.bold), textAlign: TextAlign.center)
                  ),

            ),
          );
  }
  Widget _help(BuildContext context){
    return GestureDetector(
            onTap: (){},
            child: Container(
              decoration: BoxDecoration(
                    color: LightColor.background,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color(0xfff8f8f8), blurRadius: 15, spreadRadius: 10),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Center(
                    child: Text('Looking for help?',style: TextStyle( fontWeight: FontWeight.bold), textAlign: TextAlign.center)
                  ),

            ),
          );
  }
  Widget _contactus(BuildContext context){
    return GestureDetector(
            onTap: (){},
            child: Container(
              decoration: BoxDecoration(
                    color: LightColor.background,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color(0xfff8f8f8), blurRadius: 15, spreadRadius: 10),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Center(
                    child: Text('Contact Us',style: TextStyle( fontWeight: FontWeight.bold), textAlign: TextAlign.center,)
                  ),

            ),
          );
  }
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _appBar(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    SizedBox(height: 20.0,),
                    _title(),
                    SizedBox(height: 40.0),
                    _renderProducts(context)
                  ],)
                )
            ],)
          ),
        ) ,
      )
    );
  }
}