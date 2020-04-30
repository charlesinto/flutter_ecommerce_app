
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecommerce_app/src/model/app_user.dart';
import 'package:flutter_ecommerce_app/src/themes/theme.dart';
import 'package:flutter_ecommerce_app/src/wigets/title_text.dart';
import 'package:flutter_ecommerce_app/util/app.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/app_state.dart';
import '../redux/actions.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();
}




class _LoginPageState extends State<LoginPage>{
  String _emailAddress;
  String _password;
  String _errorMessage = "";
  User user;
  SharedPreferences _preferences;
  Widget _emailEntryField(String title,String type, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              keyboardType: type == 'email' ? TextInputType.emailAddress : TextInputType.text,
              obscureText: isPassword,
              onChanged: (value) {
                setState(() {
                  _errorMessage = "";
                  _emailAddress = value;
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

  Widget _passwordEntryField(String title,String type, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              keyboardType: type == 'email' ? TextInputType.emailAddress : TextInputType.text,
              obscureText: isPassword,
              onChanged: (value) {
                setState(() {
                  _errorMessage = "";
                  _password= value;
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
  
  Widget _divider() {
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
          Text('or'),
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
  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _emailEntryField("Email id", 'email'),
        _passwordEntryField("Password",'', isPassword: true),
      ],
    );
  }
  loginUser(BuildContext context) async{
    Response response;
    setState(() {
      _errorMessage = '';
    });
    try{
        App.isLoading(context);
        response = await App.login(_emailAddress, _password);
        
        var data = json.decode(response.body);
        user = User(firstName: data['user']['firstName'], lastName: data['user']['lastName'], 
                email: data['user']['emailAddress'], phoneNumber: data['user']['phoneNumber'], 
                id: data['user']['id'], agentApproved: data['user']['agentApproved'], 
                agentIdentification: data['user']['agentIdentification'], blockedReason: data['user']['blockedReason'],
                companyName: data['user']['companyName'], contactLine: data['user']['contactLine'], 
                country: data['user']['country'], countryCode: data['user']['countryCode'],
                emailProofToken: data['user']['emailProofToken'], emailProofTokenExpiresAt: data['user']['emailProofTokenExpiresAt'], 
                emailVerified: data['user']['emailVerified'], 
                gender: data['user']['gender'], headOfficeAddress: data['user']['headOfficeAddress'],
                 isBlocked: data['user']['isBlocked'], isoCode: data['user']['isCode'], lastSeenAt: data['user']['lastSeenAt'],
                passwordResetToken: data['user']['passwordResetToken'], passwordResetTokenExpiresAt: data['user']['passwordResetTokenExpiresAt'], pinSet: data['user']['pinSet'], 
                profileImage: data['user']['profileImage'], rating: data['user']['rating'], referralCode: data['user']['referralCode'], referredBy: data['user']['referredBy'], 
                sellerAgent: data['user']['sellerAgent'], sellerApproved: data['user']['sellerApproved'], sellerIdentification: data['user']['sellerIdentification'], 
               token: data['token'], tosAcceptedByIp: data['user']['tosAcceptedByIp'], type: data['user']['type']);
      
      StoreProvider.of<AppState>(context).dispatch(UserLoggedIn(user));
      _preferences = await SharedPreferences.getInstance();
 
      _preferences.setString('user', json.encode(user));

      App.stopLoading(context);

      Navigator.of(context).pushReplacementNamed('/home');

    }catch(error){
      App.stopLoading(context);
      if(response.statusCode == 400){
        setState(() {
          _errorMessage = json.decode(response.body)['message'];
        });
      }else{
        setState(() {
          _errorMessage = 'Some errors were enountered';
        });
      }
      print(error);
    }
  }
  Widget _submitButton(BuildContext context) {
    return InkWell(
      onTap: () => loginUser(context),
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
            child: Text(
              'Login',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          )
    );
  }
  _signupButton(){
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            child: OutlineButton(
              
              borderSide: BorderSide(width: 1.0,color: Color(0xfff7892b)),
              onPressed: () {},
              child: Container(
                decoration: BoxDecoration(
                  // boxShadow: <BoxShadow>[
                  //   BoxShadow(
                  //       color: Colors.grey.shade200,
                  //       offset: Offset(2, 4),
                  //       blurRadius: 5,
                  //       spreadRadius: 2)
                  // ]
                ),
                child: Text(
                'Signup',
                style: TextStyle(fontSize: 20, color: Colors.black),
              )
              ),
            )
          );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        
        child:  Container(
            // padding: EdgeInsets.symmetric(vertical: 16.0),
            child: SingleChildScrollView(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                height: AppTheme.fullHeight(context),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset('assets/logoBlack.png',
                                    fit: BoxFit.contain,
                                    height: 200.0,
                                    width: 200.0,
                          ),
                        ),
                    SizedBox(height: 10,),
                    _emailPasswordWidget(),
                    SizedBox(height: 6.0,),
                    _errorMessage.isNotEmpty ?
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(_errorMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: 
                        Colors.red, fontSize: 14.0),
                      )
                    )
                    : Container(),
                    SizedBox(height: 4.0,),
                    _submitButton(context),
                    SizedBox(height: 8,),
                    _divider(),
                    _signupButton()
                  ],
                  )
              ) ,
              )
            ) 
          ),
      ),
    );
  }
}