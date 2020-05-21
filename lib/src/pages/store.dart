
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/model/app_product.dart';
import 'package:flutter_ecommerce_app/src/model/app_user.dart';
import 'package:flutter_ecommerce_app/src/pages/sellerProduct.dart';
import 'package:flutter_ecommerce_app/src/redux/actions.dart';
import 'package:flutter_ecommerce_app/src/themes/light_color.dart';
import 'package:flutter_ecommerce_app/src/themes/theme.dart';
import 'package:flutter_ecommerce_app/src/wigets/product_search.dart';
import 'package:flutter_ecommerce_app/src/wigets/title_text.dart';
import 'package:flutter_ecommerce_app/util/app.dart';
import 'package:flutter_ecommerce_app/util/place.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_ecommerce_app/src/model/app_state.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:file_picker/file_picker.dart';

class SellerStore extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SellerStoreState();
}


class _SellerStoreState extends State<SellerStore>{
  GlobalKey<ScaffoldState> _drawerWidget = GlobalKey<ScaffoldState>();
  double userRegFormHeight = 0.75;
  List<String> countries = ['Nigeria'];
  String _errorMessage = "";
  String _addressName = "";
  Map<dynamic, dynamic> _selectedState;
  String _selectedUserCountry;
  final TextEditingController _searchQuery = TextEditingController();
  String _referredBy = "";

  String _companyName = "";

  String _headOfficeAddress = "";

  String _contactLine ="";
  int currentProductId = 0;
  int numberOfRecordsPerPage = 100;
  List<AppProduct> products = [];
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
                 GestureDetector(
                    onTap: () {Navigator.pop(context); Navigator.of(context).pushNamed('/home');},
                    child: ListTile(
                      leading: Icon(Icons.home, color: LightColor.lightColor),
                      title: TitleText(
                              color: Colors.black ,
                              text: 'Home',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ) ,
                    )
                  ),
                  GestureDetector(
                    onTap: () {
                      StoreProvider.of<AppState>(context).dispatch(BottomIconSelected(1));
                      Navigator.pop(context);
                    },
                    child: ListTile(
                    leading: Icon(Icons.history, color: LightColor.lightColor),
                    title: TitleText(
                            color: Colors.black ,
                            text: 'My Orders',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ) ,
                  )
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
                  GestureDetector(
                    onTap: (){ 
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed('/azonkapay');},
                    child: ListTile(
                      leading: Icon(Icons.credit_card, color: LightColor.lightColor),
                      title: TitleText(
                              color: Colors.black ,
                              text: 'Azonka Pay',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ) ,
                    )
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
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed('/store'),
                    child: ListTile(
                      leading: Icon(Icons.store, color: LightColor.lightColor),
                      title: TitleText(
                              color: Colors.black ,
                              text: 'My Store',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ) ,
                    ),
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
  
  Widget _blueColorWithOutPosition(){
    return Container(
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
                        child: TitleText(text: 'My Store', color: Colors.white,)
                      )
                    )
              ]
            ) 
          )
        ),
        width: MediaQuery.of(context).size.width,
      );
  }
  Widget _addressField(){
    var states = Place.getState(); 
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Select State',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: new DropdownButtonHideUnderline(
              child: new InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  hintText: 'Choose State',
                ),
                isEmpty: _selectedState == null,
                child: new DropdownButton(
                  value: _selectedState,
                  isDense: true,
                  onChanged: ( value) {
                    setState(() {
                      _selectedState = value;
                    });
                  },
                  items: states.map((var value) {
                    return new DropdownMenuItem(
                      value: value,
                      child: new Text(value['state']['name']),
                    );
                  }).toList(),
                ),
              ),
            )
          )
        ],
      ),
    );
  }
  Widget _companyNameField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Company Name',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              keyboardType: TextInputType.text,
              onChanged: (value) {
                setState(() {
                  _errorMessage = "";
                  _companyName = value;
                });
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true
              ))
        ],
      ),
    );
  }
  Widget _headOfficeField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Head office address',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              keyboardType: TextInputType.text,
              onChanged: (value) {
                setState(() {
                  _errorMessage = "";
                  _headOfficeAddress = value;
                });
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true
              ))
        ],
      ),
    );
  }
  Widget _contactField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Contact line',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              keyboardType: TextInputType.text,
              onChanged: (value) {
                setState(() {
                  _errorMessage = "";
                  _contactLine = value;
                });
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true
              ))
        ],
      ),
    );
  }
  Widget _referredByField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Referred By',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              keyboardType: TextInputType.text,
              onChanged: (value) {
                setState(() {
                  _errorMessage = "";
                  _referredBy = value;
                });
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true
              ))
        ],
      ),
    );
  }
  Widget _selectFileField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Seller Identification',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton.icon(onPressed: () async{
             var files = await FilePicker.getFile(
              type: FileType.custom,
              allowedExtensions: ['jpg', 'pdf', 'doc'],
            );
            print('called');
          }, 
          label: Text('Select file', style: TextStyle(color:Colors.white),), icon: Icon(Icons.file_upload, color: Colors.white), color: Colors.green,)
        ],
      ),
    );
  }
  Widget _upgradeAccount(){
    return Container(
      child: Center(child: RaisedButton(onPressed: (){}, child: Text('Submit', style: TextStyle(color: Colors.white),), color: LightColor.darkColor),)
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
                        child: TitleText(text: 'My Store', color: Colors.white,)
                      )
                    )
              ]
            ) 
          )
        ),
        width: MediaQuery.of(context).size.width,
      ));
  }
  Future<User> getCurrentUser() async{
    var user = await App.getCurrentUser();
    return user;
  }
  Future<bool> isUserAccessAllowed() async{
    var user = await App.getCurrentUser();
    print(user.type);
    if(user.type == 'seller'){
      return true;
    }
    return false;
  }
  Widget _renderApp (BuildContext context){
    return FutureBuilder(
      future: isUserAccessAllowed(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasData && snapshot.data == true){

          }
          return _userRegistrationForm();
        }
        return Container();
      });
  }
  Widget _userRegistrationForm() {
    return DraggableScrollableSheet(
        maxChildSize: .3,
        initialChildSize: 0.3,
        minChildSize: 0.1,
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
                  SizedBox(height: 16.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('You are not a seller, kindly register to become a seller', textAlign: TextAlign.center,)
                  ),
                ]
              ),
            ),
          );
        },
      );
  }
  Widget _sellerForm(){
    return Container(
      height: AppTheme.fullHeight(context) - 250,
      width: AppTheme.fullWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Colors.white),
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
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('You are not a seller, kindly register to become a seller', textAlign: TextAlign.center,)
                  ),
                  SizedBox(height: 16.0),
                  _companyNameField(),
                  _headOfficeField(),
                  _contactField(),
                  _referredByField(),
                  _selectFileField(),
                  SizedBox(height: 10),
                  _upgradeAccount()
                ]
              ),
            )
    );
  }
  Widget _countryField(){
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Select Country',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: new DropdownButtonHideUnderline(
              child: new InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  hintText: 'Choose Country',
                ),
                isEmpty: _selectedUserCountry == null,
                child: new DropdownButton<String>(
                  value: _selectedUserCountry,
                  isDense: true,
                  onChanged: ( value) {
                    setState(() {
                      _selectedUserCountry = value;
                    });
                  },
                  items: countries.map((String value) {
                    print(value);
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                ),
              ),
            )
          )
        ],
      ),
    );
  }
   Widget _getInfo() {
    return Positioned(
      top: 100,
      left: 0,
      child: Container(
        margin: const EdgeInsets.all(20),
        height: 320,
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
              Text("Seller information:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: getCurrentUser(),
                builder: (BuildContext context, AsyncSnapshot<User> snapshot){
                  if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasData){
                      User user = snapshot.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                // CircleAvatar(
                                //   backgroundColor: Colors.white,
                                //   radius: 60,
                                //   backgroundImage: AssetImage('assets/man.png'),
                                // ),
                                Container(
                                  height: 120.0,
                                  width: 120.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/man.png'),
                                      fit: BoxFit.contain,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(user.firstName),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(user.lastName),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Company Name:"),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(user.companyName)
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Contact Line:"),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(user.countryCode),
                                SizedBox(width: 4,),
                                Text(user.contactLine)
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Head Office Address"),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(user.headOfficeAddress)
                              ],
                            ),
                        ]
                      );
                    }
                  }
                  return Container();
                }),
            ],
          ),
        ),
      ),
    );
  }

   Widget _products() {
    return Positioned(
      top: 440,
      left: 0,
      child: Container(
        margin: const EdgeInsets.all(20),
        height: 120,
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
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                Text("My Prducts"),
                  RaisedButton.icon(onPressed: (){
                    _showSellerProduct(context);
                  }, icon: Icon(Icons.view_list, color: Colors.white), label: Text('View Products',
                   style: TextStyle(color: Colors.white),), color: LightColor.orange)
              ],),
            ],
          ),
        ),
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
    var itemHeight = (AppTheme.fullHeight(context) - 24) / 2;
    var itemWidth = (AppTheme.fullWidth(context)  / 2);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: AppTheme.fullWidth(context),
      height: AppTheme.fullWidth(context),
      padding: EdgeInsets.only(bottom: 140.0),
      child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: itemWidth / itemHeight,
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

  _showSellerProduct(BuildContext context) async{
    try{
        App.isLoading(context);
        var sellerProducts = await App.getSellersProduct(start: 0, stop: 100);
        App.stopLoading(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => SellerProduct.anotherConstructor(sellerProducts)));
    }catch(error){
      print(error);
    }
    // return showDialog(context: context,
    //   builder: (BuildContext context){
    //     return AlertDialog(
    //       content: Container(
    //         height: AppTheme.fullHeight(context) * 0.85,
    //         width: AppTheme.fullWidth(context),
    //         child: Column(
    //           children: [
    //             // searchEntryField(),
    //             SingleChildScrollView(
    //               child: Column(
    //                         children:[ 
                             
    //                           SingleChildScrollView(child: Container(
    //                                   height: AppTheme.fullHeight(context),
    //                                   // margin: EdgeInsets.only(bottom: 120),
    //                                   child: _renderProducts(context)
    //                             ),)
                              
    //                         ]
    //                       )
    //             )
    //           ]
    //         )
    //       ),
    //       actions: <Widget>[
    //         RaisedButton(onPressed: (){ Navigator.pop(context);}, child: Text('Close', style: TextStyle(color: Colors.white),), color: LightColor.orange)
    //       ],
    //     );
    //   }
    // );
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
  Widget _userView(){
    return Stack(
          children: <Widget>[
             Column(
              children: <Widget>[
                _blueColorWithOutPosition()
              ],
            ),
            // Container(
            //   height: AppTheme.fullHeight(context),
            //   width: AppTheme.fullWidth(context)
            // ),
            // _blueColor(),
            // Positioned(
            //   top: 200,
            //   child: _sellerForm()
            // )
            _userRegistrationForm()
          ]

        );
  }
  Widget _sellerView(){
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            height: AppTheme.fullHeight(context),
            width: AppTheme.fullWidth(context)
          ),),
          _blueColor(),
          _getInfo(),
          _products()
      ]
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // floatingActionButton: FutureBuilder(
      //   future: isUserAccessAllowed(),
      //   builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
      //     if(snapshot.connectionState == ConnectionState.done){
      //       if(snapshot.hasData && snapshot.data == true){
      //           return CircleAvatar(backgroundColor: LightColor.orange,radius: 30,
      //               child: IconButton(icon: Icon(Icons.add, color: Colors.white), iconSize: 40.0, onPressed: (){}, ));
      //       }
      //       return Container();
      //     }
      //     return Container();
      //   }),
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
      ) ,
      body: SafeArea(
        child: Container(

          child: FutureBuilder(
            future: isUserAccessAllowed(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasData && snapshot.data == true){
                  return _sellerView();
                }
                return _userView(); 
              }
              return Container();
            }
          )
        ))
    );
  }
}
