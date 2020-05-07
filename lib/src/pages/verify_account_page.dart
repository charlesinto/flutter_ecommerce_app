
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/model/app_user.dart';
import 'package:flutter_ecommerce_app/src/redux/actions.dart';
import 'package:flutter_ecommerce_app/src/wigets/title_text.dart';
import 'package:flutter_ecommerce_app/util/app.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:flutter_ecommerce_app/src/themes/light_color.dart';
import 'package:flutter_ecommerce_app/src/themes/theme.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/app_state.dart';

class VerifyAccount extends StatefulWidget{
  @override
  _VerifyAccountState createState() => _VerifyAccountState();
}

class _VerifyAccountState extends State<VerifyAccount>{
  String _errorMessage = "";
  String _code = "";
  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: _icon(Icons.arrow_back_ios, color: Colors.black54,),
          ),
          
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
  Widget _pageTitle(){
    return Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            TitleText(
                              text: 'Verify',
                              color: Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                            ),
                            SizedBox(
                              width: 8.0
                            ),
                            TitleText(
                              text: 'Account',
                              color: Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                            )
                        ]
                      )
                  );
  }
  Widget _verificationCodeEntryField(String title) {
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
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              obscureText: false,
              onChanged: (value) {
                setState(() {
                  _errorMessage = "";
                  _code = value;
                });
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true,
                  errorText: _errorMessage.isEmpty ? _errorMessage : null
              ))
        ],
      ),
    );
  }
  Widget _submitButton(BuildContext context) {
    return InkWell(
      onTap: ()  { verifyUserAccount(context);},
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
              'Verify Account',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          )
    );
  }
  verifyUserAccount(BuildContext context) async{
    setState((){
        _errorMessage = "Verification code is required";
    });
    if(_code.isEmpty){
      return setState((){
        _errorMessage = "Verification code is required";
      });
    }
    try{
      App.isLoading(context);
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var email = _prefs.getString('email');
      var password = _prefs.getString('password');
      await App.verifyEmail(email, password, _code);
      var response = await App.login(email, password);
        
        var data = json.decode(response.body);
        var user = User(firstName: data['user']['firstName'], lastName: data['user']['lastName'], 
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
              _prefs = await SharedPreferences.getInstance();
        
              _prefs.setString('user', json.encode(user));

              App.stopLoading(context);

              Navigator.of(context).pushReplacementNamed('/home');
    }catch(error){
       return Alert(
          context: context,
          type: AlertType.error,
          title: "Action error",
          desc: "Some erros were encountered, please try to login",
          buttons: [
            DialogButton(
              color: LightColor.orange,
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
              },
              width: 120,
            )
          ],
        ).show();
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
          child: Container(
            child: GestureDetector(
              onTap:  () => FocusScope.of(context).requestFocus(FocusNode()),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _appBar(),
                    _pageTitle(),
                    Center(
                        child: Text(
                          'Just one more step to go, let us verify your account',
                            textAlign: TextAlign.center,

                        )
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            SizedBox(
                                height: 20.0
                              ),
                              _verificationCodeEntryField("Verification Code"),
                              SizedBox(
                                height: 20.0
                              ),

                              SizedBox(
                                height: 10.0
                              ),
                              _submitButton(context),
                              SizedBox(
                                height: 16.0
                              ),
                              FlatButton(
                                onPressed: () async{
                                  
                                  SharedPreferences _prefs = await SharedPreferences.getInstance();
                                  var email = _prefs.getString('email');
                                  App.isLoading(context);
                                  await App.resendVerificationLink(email);
                                  App.stopLoading(context);
                                  return  Alert(
                                          context: context,
                                          type: AlertType.success,
                                          title: "Action Successful",
                                          desc: "Email Verification resent successfully",
                                          buttons: [
                                            DialogButton(
                                              color: LightColor.orange,
                                              child: Text(
                                                "Ok",
                                                style: TextStyle(color: Colors.white, fontSize: 20),
                                              ),
                                              onPressed: (){
                                                Navigator.pop(context);
                                              },
                                              width: 120,
                                            )
                                          ],
                                        ).show();
                                },
                                child: Center(child:
                                Text('Resend Email Verification Link', 
                                  style: TextStyle(
                                    color: LightColor.orange,
                                    decoration: TextDecoration.underline),
                                ),
                                ) 
                              ,)
                          ]
                        )
                      )
                  ]
                )
              )
            ),
          )
        ) ,
      );
  }
}

//del@example.com