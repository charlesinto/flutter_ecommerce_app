import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/model/app_address.dart';
import 'package:flutter_ecommerce_app/src/model/app_banks.dart';
import 'package:flutter_ecommerce_app/src/model/app_paystackBank.dart';
import 'package:flutter_ecommerce_app/src/model/app_user.dart';
import 'package:flutter_ecommerce_app/src/themes/light_color.dart';
import 'package:flutter_ecommerce_app/src/themes/theme.dart';
import 'package:flutter_ecommerce_app/src/wigets/title_text.dart';
import 'package:flutter_ecommerce_app/util/app.dart';
import 'package:flutter_ecommerce_app/util/place.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
class Settings extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SettingsPage();
}

class _SettingsPage extends State<Settings>{
  GlobalKey<ScaffoldState> _drawerWidget = GlobalKey<ScaffoldState>();
  PayStackBank bank;
  Map<dynamic, dynamic> _selectedState;
  String _errorMessage = "";
  String _accountNumber = "";
  String _accountName = "";
  String _addressName = '';
  List<String> countries = ['Nigeria'];
  String _selectedUserCountry;
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
                        child: TitleText(text: 'Profile', color: Colors.white,)
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
              Text("User information:",
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
                                Text("Email:"),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(user.email)
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Phone Number:"),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(user.countryCode),
                                SizedBox(width: 4,),
                                Text(user.phoneNumber)
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Referral Code:"),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(user.referralCode)
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            user.referredBy != null ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Referral By"),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(user.referredBy)
                              ],
                            ) : Container()
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
  Future<List<Address>> getUserAddress() async{
    var address = await App.getUserAddress();
    return address;
  }
  Widget _userAddress(List<Address> address){
    return Column(
      children: address.map((Address entry){
        return Column(
          children: [
            GestureDetector(
              child: ListTile(
                // leading: GestureDetector(
                //   child: Icon(Icons.edit, color: Colors.green,),),
                title: Text(entry.address1,),
                subtitle: Text("${entry.state}, ${entry.country}"),
                trailing: GestureDetector(
                    onTap: (){
                      return App.showConfirmDialog(context,'Delete Address' ,'Are you sure?', onConfirmDeleteAddressById, parmas: entry.id);
                    },
                    child: Icon(Icons.delete_outline,color: Colors.red,) ,),
                )
            ),
            // SizedBox(height: 4.0),
            // Divider(height: 2.0, color: Colors.grey)
          ]
        );
      }).toList()
    );
  }
  onConfirmDeleteAddressById(int id) async{
    App.isLoading(context);
    await App.deleteAddressById(id.toString());
    App.stopLoading(context);
    App.showActionSuccess(context,message: 'Address deleted successfully');
    setState(() {
      _errorMessage = "";
    });
  }
  Widget _addressField(StateSetter setState){
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
  Widget _countryField(StateSetter setState){
    
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
   Widget _userAdress() {
    return Positioned(
      top: 440,
      left: 0,
      child: Container(
        margin: EdgeInsets.all(20),
        height: 200,
        width: MediaQuery.of(context).size.width * 0.90,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Text(
                    "Delivery Address:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  IconButton(icon: Icon(Icons.add, color: LightColor.primaryAccent,), onPressed: (){
                    _addAddress(context);
                  })
                ]
              ),
              SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: getUserAddress(),
                builder: (BuildContext context, AsyncSnapshot<List<Address>> snapshot){
                  List<Address> address = snapshot.data;
                  if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasData && address.length > 0){
                      return _userAddress(address);
                    }
                    return Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: Center(child: Text('No address added')),
                    );
                  }
                  return Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: CircularProgressIndicator()
                  );
                },)
            ],
          )
          ),
        ),
      ),
    );
  }
  _addAddress(BuildContext context) async{
    _selectedUserCountry = null;
    _selectedState = null;
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return StatefulBuilder(
          
          builder: (BuildContext context,StateSetter sta){
            return GestureDetector(
                    onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                    child: AlertDialog(
                    content: Container(
                      width: deviceWidth * 0.6,
                      height: deviceHeight * 0.6 > 380 ? 380 : deviceHeight * 0.6 ,
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TitleText(text: 'Add Delivery Address',fontWeight: FontWeight.bold,),
                            SizedBox(height: 16.0),
                            Container(
                              
                              child: Column(
                              children: [
                                _addressNameField(sta),
                                _addressField(sta),
                                _countryField(sta)
                              ]
                            )
                            )
                          ],
                        )
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text('Cancel', style: TextStyle(color: LightColor.red),)),
                        RaisedButton(
                          color: LightColor.orange,
                        onPressed: (){
                          _saveAddress(context);
                        },
                        child: Text('Save', style: TextStyle(color: Colors.white),)),
                        SizedBox(width: 8.0,)
                    ],
                  )
            );
            
          } 
        );
      }
    );
  }
  Widget _userBillingAccounts(User user){
    List<Bank> banks = user.banks;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: banks.map((Bank bank){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: LightColor.getBackgroundColor(bank.name),
                  child: Center(child: 
                    Text(bank.name.substring(0,1).toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    )
                  ),
                ),
                title: Text(bank.accountName.toUpperCase()) ,
                subtitle: Text("${bank.accountNumber} - ${bank.name}",) ,
                trailing: IconButton(icon: Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: (){
                    return App.showConfirmDialog(context,'Delete Bank Account' ,'Are you sure?', onConfirmDeleteBankById, parmas: bank.id);
                  }),
              )
            ),
            // Divider(height:2.0, color: Colors.grey,)
          ]
        );
      }).toList()
    );
  }
  onConfirmDeleteBankById(int id) async{
    App.isLoading(context);
    await App.deleteBankAcountById(id.toString());
    App.stopLoading(context);
    App.showActionSuccess(context,message: 'Bank Account deleted successfully');
    setState(() {
      _errorMessage = "";
    });
  }
  Future<User> getUserBanks() async{
    var user = App.getUserBanks();
    return user;
  }
  Widget _bankField(List<PayStackBank> pbanks, StateSetter setState, {int bankId}) {
    // print('bank lenghth: '+ pbanks.length.toString());
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Select Bank',
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
                  hintText: 'Choose Bank',
                ),
                isEmpty: bank == null,
                child: new DropdownButton<PayStackBank>(
                  value: bank,
                  isDense: true,
                  onChanged: (PayStackBank  value) {
                    setState(() {
                      bank = value;
                    });
                  },
                  items: pbanks.map((PayStackBank value) {
                    return new DropdownMenuItem<PayStackBank>(
                      value: value,
                      child: new Text(value.name),
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
  Widget _accountNumberField(StateSetter setState) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Account Number',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _errorMessage = "";
                  _accountNumber = value;
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
  Widget _accountNameField(StateSetter setState) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Account Name',
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
                  _accountName = value;
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
  Widget _addressNameField(StateSetter setState) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Address',
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
                  _addressName = value;
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
  _addBank(BuildContext context) async{
    App.isLoading(context);
    bank = null;
    var pbank = await App.getPayStackBanks();
    App.stopLoading(context);
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return StatefulBuilder(
          
          builder: (BuildContext context,StateSetter sta){
            return GestureDetector(
                    onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                    child: AlertDialog(
                    content: Container(
                      width: deviceWidth * 0.6,
                      height: deviceHeight * 0.6 > 380 ? 380 : deviceHeight * 0.6 ,
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TitleText(text: 'Add Bank',fontWeight: FontWeight.bold,),
                            SizedBox(height: 16.0),
                            Container(
                              
                              child: Column(
                              children: [
                                _bankField(pbank, sta),
                                _accountNumberField(sta),
                                _accountNameField(sta)
                              ]
                            )
                            )
                          ],
                        )
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text('Cancel', style: TextStyle(color: LightColor.red),)),
                        RaisedButton(
                          color: LightColor.orange,
                        onPressed: (){
                          _saveBank(context);
                        },
                        child: Text('Save', style: TextStyle(color: Colors.white),)),
                        SizedBox(width: 8.0,)
                    ],
                  )
            );
            
          } 
        );
      }
    );
  }
  _saveBank(BuildContext context) async{
    if(bank == null || _accountName.isEmpty || _accountNumber.isEmpty){
      return App.showActionError(context,message: 'Please fill all fields and try again');
    }
    try{
      App.isLoading(context);
      await App.addBank(bank, _accountName, _accountNumber);
      
      App.stopLoading(context);
      App.showActionSuccess(context,message: 'Bank added successfully',onConfirm: dismissAlert);
    }catch(error){
      App.stopLoading(context);
      print('error is: '+ error.toString());
    }
  }
  _saveAddress(BuildContext context) async{
    if(_selectedState == null || _selectedUserCountry == null || _addressName.isEmpty){
      return App.showActionError(context,message: 'Please fill all fields and try again');
    }
    try{
      App.isLoading(context);
      var response = await App.addAddress(_selectedUserCountry, _selectedState['state']['name'], _selectedState['state']['name'], _addressName);
      print(response.body);
      App.stopLoading(context);
      App.showActionSuccess(context,message: 'Address added successfully',onConfirm: dismissAlert);
    }catch(error){
      App.stopLoading(context);
      print('error is: '+ error.toString());
    }
  }
  dismissAlert(BuildContext context){
    setState(() {
      _errorMessage = "";
    });
    Navigator.pop(context);
  }
     Widget _userBank() {
    return Positioned(
      top: 660,
      child: Container(
        margin: EdgeInsets.all(20),
        height: 200,
        width: MediaQuery.of(context).size.width * 0.90,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Text(
                    "Billing Account:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  IconButton(icon: Icon(Icons.add, color: LightColor.primaryAccent,), onPressed: (){
                    _addBank(context);
                  })
                ]
              ),
              SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: getUserBanks(),
                builder: (BuildContext context, AsyncSnapshot<User> snapshot){
                   var user = snapshot.data;
                  if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasData && user.banks.length > 0){
                      return _userBillingAccounts(user);
                    }
                    return Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: Center(child: Text('No Bank added')),
                    );
                  }
                  return Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: CircularProgressIndicator()
                  );
                },)
            ],
          )
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    // var deviceHeight = MediaQuery.of(context).size.height;
    print("width: " + MediaQuery.of(context).size.width.toString());
    // var boxOneHeight = deviceHeight * 0.35 > 180.0 ? 180.0 : deviceHeight;
    // var deviceWidth = MediaQuery.of(context).size.width;
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
      body: SafeArea(child: Container(
        child: SingleChildScrollView(
          child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                  height: 920,
                  width: MediaQuery.of(context).size.width,
                )
            ),
            _blueColor(),
            _getInfo(),
            _userAdress(),
            _userBank()
          ]
        ),
        )
      )),
    );
  }
}