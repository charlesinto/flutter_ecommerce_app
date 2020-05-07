import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/wigets/title_text.dart';
import 'package:flutter_ecommerce_app/util/app.dart';import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:flutter_ecommerce_app/src/themes/light_color.dart';
import 'package:flutter_ecommerce_app/src/themes/theme.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatefulWidget{
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>{
  String _errorMessage = "";
  String _firstName = "";
  String _firstNameValid = "";
  String _lastName = "";
  String _lastNameValid = "";
  String _email = "";
  String _emailValid = "";
  String _phoneNumber ="";
  String _phoneNumberValid = "";
  String _referralCode = "";
  String _password = "";
  String _passwordValid= "";
  String _confirmPassword = "";
  String _gender = "Male";
  bool error = false;
  String _confirmPasswordValid = "";
  bool _agreeToTerms = false;
  Country _selected = Country(
            asset: "assets/flags/gb_flag.png",
            dialingCode: "44",
            isoCode: "GB",
            name: "United Kingdom",
            currency: "British pound",
              currencyISO: "GBP",
          );
  List<String> genderList = ['Male', 'Female', 'I don\'t want to disclose'];
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
                              text: 'Si',
                              color: LightColor.darkColor,
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                            ),
                            TitleText(
                              text: 'gn',
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                            ),
                            TitleText(
                              text: 'Up',
                              color: LightColor.orange,
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                            )
                        ]
                      )
                  );
  }
 
  Widget _fNameEntryField(String title) {
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
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    onChanged: (value) {
                      setState(() {
                        _errorMessage = "";
                        _firstName = value;
                      });
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xfff3f3f4),
                        filled: true,
                        errorText: _firstNameValid.isNotEmpty ? _firstNameValid : null
                    ))
          
        ],
      ),
    );
  }
  Widget _lNameEntryField(String title) {
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
              keyboardType: TextInputType.text,
              obscureText: false,
              onChanged: (value) {
                setState(() {
                  _errorMessage = "";
                  _lastName = value;
                });
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true,
                  errorText: _lastNameValid.isNotEmpty ? _lastNameValid : null
              ))
        ],
      ),
    );
  }
  Widget _emailEntryField(String title) {
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
              keyboardType: TextInputType.text,
              obscureText: false,
              onChanged: (value) {
                setState(() {
                  _errorMessage = "";
                  _email = value;
                });
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true,
                  errorText: _emailValid.isNotEmpty ? _emailValid : null
              ))
        ],
      ),
    );
  }
  Widget _phoneNumberEntryField(String title) {
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
          Row(
            children: [
              Container(
                child: CountryPicker(
                  showDialingCode: true,
                  onChanged: (Country country) {
                    setState(() {
                      _selected = country;
                    });
                    print(country.dialingCode);
                  },
                  selectedCountry: _selected,
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                flex: 1,
                child: TextField(
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    onChanged: (value) {
                      setState(() {
                        _errorMessage = "";
                        _phoneNumber = value;
                      });
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xfff3f3f4),
                        filled: true,
                        errorText: _phoneNumberValid.isNotEmpty ? _phoneNumberValid : null
                    ))
              
              )
            ]
          )
        ],
      ),
    );
  }
  Widget _referralCodeEntryField(String title) {
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
              keyboardType: TextInputType.text,
              obscureText: false,
              onChanged: (value) {
                setState(() {
                  _errorMessage = "";
                  _referralCode = value;
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
  Widget _passwordEntryField(String title) {
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
              keyboardType: TextInputType.text,
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  _errorMessage = "";
                  _password = value;
                });
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true,
                  errorText: _passwordValid.isNotEmpty ? _phoneNumberValid : null
              ))
        ],
      ),
    );
  }
  Widget _confrimPasswordEntryField(String title) {
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
              keyboardType: TextInputType.text,
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  _errorMessage = "";
                  _confirmPassword = value;
                });
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true,
                  errorText: _confirmPasswordValid.isNotEmpty ? _confirmPasswordValid : null
              ))
        ],
      ),
    );
  }
   Widget _genderEntryField(String title) {
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
          Container(
            child: new DropdownButtonHideUnderline(
              child: new InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  hintText: 'Gender',
                ),
                isEmpty: _gender.isEmpty,
                child: new DropdownButton(
                  value: _gender,
                  isDense: true,
                  onChanged: (String  value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                  items: genderList.map((String value) {
                    return new DropdownMenuItem(
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
  Widget _submitButton(BuildContext context) {
    return InkWell(
      onTap: ()  { createAccount(context);},
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
              'Sign Up',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          )
    );
  }
  Widget _agreeToTermsField(){
    return CheckboxListTile(
    title: const Text('I agree to terms and conditions'),
    value: _agreeToTerms,
    onChanged: (bool value) {
      setState(() { _agreeToTerms = value; });
    },
    secondary: const Icon(
      Icons.check_circle_outline,
      color: LightColor.orange,
    ),
  );
  }
  
  createAccount(BuildContext context) async{
    error = false;
    setState(() {
      _lastNameValid = "";
      _firstNameValid = "";
      _phoneNumberValid = "";
      _emailValid = "";
      _passwordValid = "";
      _confirmPasswordValid = "";
    });
    if(_firstName.isEmpty){
      setState(() {
         
        _firstNameValid = "First Name is required and can not be null";
      });
      error = true;
    }
    if(_lastName.isEmpty){
      setState(() {
        _lastNameValid = "Last Name is required and can not be null";
      });
      error = true;
    }
    if(_phoneNumber.isEmpty){
      setState(() {
        _phoneNumberValid = "Phone Number is required and can not be null";
      });
      error = true;
    }
    if(_password.isEmpty){
      setState(() {
        
        _passwordValid = "Password is required and can not be null";
      });
      error = true;
    }
    if(_email.isEmpty){
      setState(() {
        _emailValid = "First Name is required and can not be null";
      });
      error = true;
    }else{
      if(!App.isEmail(_email)){
          setState(() {
          _emailValid = "Email format is invalid";
        });
        error = true;
      }
    }
    if(_confirmPassword != _password){
        setState(() {
        _confirmPasswordValid = "Confirm Password and Password do not match";
      });
      error = true;
    }
    
    if(!error){
        if(!_agreeToTerms){
           return  Alert(
              context: context,
              type: AlertType.error,
              title: "Action Error",
              desc: "You must agree to terms and conditions",
              buttons: [
                DialogButton(
                  color: LightColor.orange,
                  child: Text(
                    "Continue",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
                  width: 120,
                )
              ],
            ).show();
        }
        try{
          App.isLoading(context);
          var response = await  App.signUp(_firstName, _lastName, _email, _password, _phoneNumber, 
            _selected.name, _selected.dialingCode, _gender, _referralCode, _selected.isoCode);
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          _prefs.setString('email', _email);
          _prefs.setString('password', _password);
          App.stopLoading(context);
          var resp = json.decode(response.body);
          if(resp['status'] == false){
              return  Alert(
              context: context,
              type: AlertType.error,
              title: "Action Error",
              desc: resp['message'].substring(0, 50),
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
          return  Alert(
              context: context,
              type: AlertType.success,
              title: "Action Successful",
              desc: "Account created successful, please check your email to verify your account",
              buttons: [
                DialogButton(
                  color: LightColor.orange,
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed('/verifyAccount');
                  },
                  width: 120,
                )
              ],
            ).show();
          // print(response.body);
        }catch(error){
          print(error);
          return  Alert(
              context: context,
              type: AlertType.error,
              title: "Action Error",
              desc: "Some erros were encountered completing your request",
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
    }
  }
  
  @override 



  
  Widget build(BuildContext context) {
    // TODO: implement build   
    return Scaffold(
      body: SafeArea(child: 
        Container(
          padding: EdgeInsets.only(bottom: 60.0),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _appBar(),
                      _pageTitle(),
                      SizedBox(
                        height: 10.0
                      ),
                      Center(
                        child: Text(
                          'We are excited to have you, signup to enjoy benefits',
                            textAlign: TextAlign.center,

                        )
                      ),
                      SizedBox(
                        height: 10.0
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _fNameEntryField("First Name"),
                            _lNameEntryField("Last Name"),
                            _genderEntryField("Gender"),
                            _emailEntryField("Email Address"),
                            _phoneNumberEntryField("Phone Number"),
                            _referralCodeEntryField("Referral Code"),
                            _passwordEntryField("Password"),
                            _confrimPasswordEntryField("Confrim Password"),
                            SizedBox(
                              height: 10
                            ),
                            _agreeToTermsField(),
                            SizedBox(
                              height: 10
                            ),
                            _submitButton(context)
                          ]
                        ),
                      )
                      )
                  ]
                )
            )
          
          ,)
        )
      )
    );
  }

}