import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/model/app_banks.dart';
import 'package:flutter_ecommerce_app/src/model/app_product.dart';
import 'package:flutter_ecommerce_app/src/model/app_question.dart';
import 'package:flutter_ecommerce_app/src/model/app_transaction.dart';
import 'package:flutter_ecommerce_app/src/model/app_user.dart';
import 'package:flutter_ecommerce_app/src/model/app_wallet.dart';
import 'package:flutter_ecommerce_app/src/redux/actions.dart';
import 'package:flutter_ecommerce_app/src/themes/light_color.dart';
import 'package:flutter_ecommerce_app/src/themes/theme.dart';
import 'package:flutter_ecommerce_app/src/wigets/title_text.dart';
import 'package:flutter_ecommerce_app/util/app.dart';
import 'package:flutter_ecommerce_app/util/constants.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecommerce_app/src/model/app_state.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import '../model/app_transaction.dart' as WalletTransaction;
class WalletPage extends StatefulWidget{
  @override
  _WalletPageState createState() => _WalletPageState();
}


class _WalletPageState extends State<WalletPage>{
  GlobalKey<ScaffoldState> _drawerWidget = GlobalKey<ScaffoldState>();
  List<Question> questions = [];
  Question _selectedQuestion;
  String errorMessage = "";
  String _answer = "";
  String _answerValid = "";
  String _pinValid = "";
  String _pin = "";
  String _errorMessage = "";
  String _amount = "";static const paystack_backend_url = "https://infinite-peak-60063.herokuapp.com";
  String transcation = "";
  bool _inProgress = false;
  String _cardNumber;
  String _cvv;
  int _expiryMonth = 0;
  int _expiryYear = 0;
  String _addressString = "";
  String _walletId = "";
  int totalAmount = 0;
  Bank bank;
  Bank _selectedBank;
  String _selectedBankId = "";
  String _userPin = "";
  void initState() {
    PaystackPlugin.initialize(
            publicKey: pStackPublicKey);
    super.initState();
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
  handleBilling(BuildContext context, int totalAmount) async{
    
    var user = await App.getCurrentUser();
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
        await App.topUpWallet((totalAmount * 100).toString(), _cartResponse.reference);

        App.stopLoading(context);
        return Alert(
            context: context,
            type: AlertType.success,
            title: "Payment Successful",
            desc: "Your wallet has been funded with NGN ${App.formatAsMoney(totalAmount)}",
            buttons: [
              DialogButton(
                color: LightColor.orange,
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                width: 120,
              ),
            ],
          ).show();
      }
    }catch(error){
        App.stopLoading(context);
        print('Some errors were encountered: '+ error);
        
        Alert(
            context: context,
            type: AlertType.warning,
            title: "Action Error",
            desc: "Some error were encountered while processing payment",
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
        throw error;
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
                      Navigator.of(context).pushReplacementNamed('/home');
                      Navigator.pop(context);
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
                    onTap: () => Navigator.of(context).pushReplacementNamed('/wallet'),
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
                  GestureDetector(onTap: (){ },
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

  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
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

  Widget _walletBalanceScreen(BuildContext context, User _user){
    return Container(
            decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [LightColor.primaryAccent, LightColor.darkColor]
                )
            ),
            height: 280,
            child: Stack(children: <Widget>[
              _appBar(),
              SizedBox(
                  height: 10.0,
                ),
              Positioned(
                bottom: 130,
                left: 16,
                child: _moneyBalance(_user)
              ),
              SizedBox(
                  height: 30.0,
                ),
              Align(
                alignment:Alignment.bottomLeft,
                child: _actionBar(),
              )
            ],)
          );
  }
  
  Widget _banksField(String title, List<Bank> userBanks, StateSetter stateSet) {
    _selectedBank = null;
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
            
            child: 
            // TextFormField(
            //   initialValue: userBanks[0].name,
            // )
            new DropdownButtonHideUnderline(
              child: new InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  hintText: 'Choose Bank',
                ),
                isEmpty: _selectedBank == null ,
                child: new DropdownButton<Bank>(
                  value: _selectedBank,
                  isDense: true,
                  onChanged: (Bank  value) {
                    stateSet(() {
                      _selectedBank = value;
                    });
                  },
                  items: userBanks.map((Bank value) {
                    return new DropdownMenuItem<Bank>(
                      value: value,
                      child: Text(value.name + " - "+ value.accountNumber)
                      //  ListTile(
                      //       title: TitleText(text: value.name),
                      //       subtitle: Row(
                      //         children: <Widget>[
                      //           TitleText(
                      //             text: value.accountNumber,
                      //             color: Colors.grey,
                      //             fontSize: 11,
                      //           ),
                      //           SizedBox(width: 6),
                      //           TitleText(
                      //             text: '-',
                      //             color: Colors.grey,
                      //             fontSize: 11,
                      //           ),
                      //           TitleText(
                      //             text: value.accountName,
                      //             color: Colors.grey,
                      //             fontSize: 11,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
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
  Widget _moneyBalance(User _user){
    return  Container(
      height: 80,
      child: Column(
        children: <Widget>[
            Row(children: <Widget>[
            SizedBox(
            width: 8.0,
          ),
            Container(
            child: TitleText(
              text: 'NGN',
              fontSize: 16,
              color: Colors.white,
            )
          ),
          SizedBox(
            width: 8.0,
          ),
            Container(
            child: TitleText(
              text: _user == null ? '0.00' : App.formatAsMoney(_user.wallet.balance ~/ 100),
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            )
          )
        ],)
          ,SizedBox(
            height: 8
          ),
          Text('Available Balance', style: TextStyle(color: Colors.white),)
      ],)
    );
  }
  sendMoney(BuildContext context){
    var deviceHeight = MediaQuery.of(context).size.height;
    return Alert(
        context: context,
        title: "Send Money",
        content: StatefulBuilder(
          
          builder: (BuildContext context, StateSetter sta){
              return GestureDetector(
                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()) ,
                  child: Container(
                    height: deviceHeight * 0.4,
                    child: SingleChildScrollView(
                      child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Wallet ID',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        sta(() {
                          _errorMessage = "";
                          // var newValue = value.split(',').join('');
                          // print(App.formatAsMoney(int.parse(_amount)));
                          _walletId = value;
                          // _amount = App.formatAsMoney(int.parse(value));
                        });
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true
                      )),
                      SizedBox(height: 20),
                    SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Amount',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        sta(() {
                          _errorMessage = "";
                          // var newValue = value.split(',').join('');
                          // print(App.formatAsMoney(int.parse(_amount)));
                          _amount = value;
                          // _amount = App.formatAsMoney(int.parse(value));
                        });
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Security Pin',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        sta(() {
                          _errorMessage = "";
                          // var newValue = value.split(',').join('');
                          // print(App.formatAsMoney(int.parse(_amount)));
                          _userPin = value;
                          // _amount = App.formatAsMoney(int.parse(value));
                        });
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true
                      )),
                    ],
                  ) ,
                      
                    )
                  )
                );
          }),
        buttons: [
          DialogButton(
            onPressed: () {
              if(_userPin.isEmpty || _amount.isEmpty || _walletId.isEmpty){
                return ;
              }
              hanldeSendMoney(_userPin, int.parse(_amount), _walletId);
              // handleBilling(context, int.parse(_amount));
            },
            child: Text(
              "Send",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
  topUpMoney(BuildContext context){
    var deviceHeight = MediaQuery.of(context).size.height;
    return Alert(
        context: context,
        title: "Top Up Wallet",
        content: StatefulBuilder(
          
          builder: (BuildContext context, StateSetter sta){
              return GestureDetector(
                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()) ,
                  child: Container(
                    height: deviceHeight * 0.25,
                    child: SingleChildScrollView(
                      child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Amount',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        sta(() {
                          _errorMessage = "";
                          // var newValue = value.split(',').join('');
                          // print(App.formatAsMoney(int.parse(_amount)));
                          _amount = value;
                          // _amount = App.formatAsMoney(int.parse(value));
                        });
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true
                      )),
                      SizedBox(height: 20)
                    ],
                  ) ,
                      
                    )
                  )
                );
          }),
        buttons: [
          DialogButton(
            onPressed: () {
              if(_amount.isEmpty){
                return ;
              }
              handleBilling(context, int.parse(_amount));
            },
            child: Text(
              "Top Up",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
  withdrawMoney(BuildContext context) async{
    var deviceHeight = MediaQuery.of(context).size.height;
    App.isLoading(context);
    var user = await App.getUserBanks();
    App.stopLoading(context);
    print(user.banks.length);
    return Alert(
        context: context,
        title: "Withdraw to Bank",
        content: StatefulBuilder(
          
          builder: (BuildContext context, StateSetter sta){
              return GestureDetector(
                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()) ,
                  child: Container(
                    height: deviceHeight * 0.5,
                    child: SingleChildScrollView(
                      child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                        height: 10,
                      ),
                      _banksField("Withdraw Money", user.banks, sta),
                      SizedBox(height: 20),
                      Text(
                        'Amount To Withdraw',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        sta(() {
                          _errorMessage = "";
                          // var newValue = value.split(',').join('');
                          // print(App.formatAsMoney(int.parse(_amount)));
                          _amount = value;
                          // _amount = App.formatAsMoney(int.parse(value));
                        });
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true
                      )),
                      SizedBox(height: 20),
                      Text(
                        'Security Pin',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        sta(() {
                          _errorMessage = "";
                          // var newValue = value.split(',').join('');
                          // print(App.formatAsMoney(int.parse(_amount)));
                          _userPin = value;
                          // _amount = App.formatAsMoney(int.parse(value));
                        });
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true
                      )),
                    ],
                  ) ,
                      
                    )
                  )
                );
          }),
        buttons: [
          DialogButton(
            onPressed: () {
              if(_selectedBank == null || _amount.isEmpty || _userPin.isEmpty){
                return ;
              }
              handleTransfer(context, int.parse(_amount) * 100, _selectedBank, _userPin);
            },
            child: Text(
              "Withdraw",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
  Widget _actionBar(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      margin: EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: <Widget>[
          Container(
            height: 90,
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            
            children: [
              GestureDetector(
                onTap: () {
                  sendMoney(context);
                },
                child: Card(
              
              child: CircleAvatar(
                backgroundColor: Colors.white,
                // radius: Radius.circular(20.0),
                child: Icon(Icons.card_giftcard, color: LightColor.orange,),
              ),)
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: TitleText(
                  text: 'Send Money',
                  color: Colors.white,
                  )
                ,)
            ]
          )
          ),
          Container(
            height: 90,
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            
            children: [
              GestureDetector(
                onTap: () => topUpMoney(context),
                child: Card(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                // radius: Radius.circular(20.0),
                child: Icon(Icons.credit_card, color: LightColor.orange,),
              ),),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: TitleText(
                  text: 'Top Up',
                  color: Colors.white,
                  )
                ,)
            ]
          )
          ),
          Container(
            height: 90,
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            
            children: [
              GestureDetector(
                onTap: (){ withdrawMoney(context);},
                child: Card(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                // radius: Radius.circular(20.0),
                child: Icon(Icons.arrow_drop_down_circle, color: LightColor.orange,),
              ),)
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: TitleText(
                  text: 'Withdraw',
                  color: Colors.white,
                  )
                ,)
            ]
          )
          )
        ],
      )
      
      );
  }
  handleTransfer(BuildContext context, int amount, Bank selectedBank, String userPin) async{
    try{
      
      App.isLoading(context);
      var response = await App.requestWalletWithdraw(amount.toString(), userPin, 'NGN');
      var serverResponse = json.decode(response.body);
      if(serverResponse['success'] == false){
        App.stopLoading(context);
        return Alert(
            context: context,
            type: AlertType.warning,
            title: "Action Error",
            desc: "${serverResponse['message']}",
            buttons: [
              DialogButton(
                color: LightColor.orange,
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  setState(() {
                    selectedBank = null;
                    
                  });
                  Navigator.pop(context);
                  Navigator.pop(context);
                  
                },
                width: 120,
              ),
            ],
          ).show();
      }
      App.stopLoading(context);
      return Alert(
            context: context,
            type: AlertType.success,
            title: "Payment Successful",
            desc: "Your request to withdraw NGN ${App.formatAsMoney((amount ~/ 100))} is been processed",
            buttons: [
              DialogButton(
                color: LightColor.orange,
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  setState(() {
                    selectedBank = null;
                    
                  });
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                width: 120,
              ),
            ],
          ).show();
    }catch(error){
      print(error);
      return Alert(
            context: context,
            type: AlertType.warning,
            desc: "Some errors were encountered" ,
            title: "Action Error",
            buttons: [
              DialogButton(
                color: LightColor.orange,
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  setState(() {
                    selectedBank = null;
                    
                  });
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                width: 120,
              ),
            ],
          ).show();
    }
  }
  hanldeSendMoney(String pin, int amount, String walletId) async{
    try{
      
      App.isLoading(context);
      var response = await App.sendMoney(amount.toString(), walletId, pin);
      var serverResponse = json.decode(response.body);
      if(serverResponse['success'] == false){
        App.stopLoading(context);
        return Alert(
            context: context,
            type: AlertType.warning,
            title: "Action Error",
            desc: "${serverResponse['message']}",
            buttons: [
              DialogButton(
                color: LightColor.orange,
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  
                },
                width: 120,
              ),
            ],
          ).show();
      }
      App.stopLoading(context);
      return Alert(
            context: context,
            type: AlertType.success,
            title: "Payment Successful",
            desc: "Your request to send NGN ${App.formatAsMoney((amount ~/ 100))} is been processed",
            buttons: [
              DialogButton(
                color: LightColor.orange,
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                width: 120,
              ),
            ],
          ).show();
    }catch(error){
      print(error);
      return Alert(
            context: context,
            type: AlertType.warning,
            desc: "Some errors were encountered" ,
            title: "Action Error",
            buttons: [
              DialogButton(
                color: LightColor.orange,
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                width: 120,
              ),
            ],
          ).show();
    }
  }
  Future<User> getCurrentUser(BuildContext context) async{
    try{
      // App.isLoading(context);
      var user = await App.getUserWallet();
      // App.stopLoading(context);
      print(user.wallet.transactions.length.toString());
      return user;
    }catch(error){
      // App.stopLoading(context);
      print(error);
      return null;
    }
  }
  Widget _upArrow(){
    return Container(
      height: 70.0,
      width: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.greenAccent
      ),
      child: Center(
        child: Icon(Icons.arrow_drop_up, color: Colors.white,),),
    );
  }
  Widget _downArrow(){
    return Container(
      height: 40.0,
      width: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.redAccent
      ),
      child: Center(
        child: Icon(Icons.arrow_drop_down, color: Colors.white,),),
    );
  }
  String getOrderDate(int timeStamp){
    var date = DateTime.fromMicrosecondsSinceEpoch(timeStamp * 1000);
    // print(date);
    return date.toString();
  }
  viewWalletDetails(BuildContext context, WalletTransaction.Transaction _transcation){
    return showDialog(context: context,
       builder: (BuildContext context){
         return AlertDialog(
           content: Container(
             width: AppTheme.fullWidth(context),
             
             padding: EdgeInsets.symmetric(vertical: 8,),
             child: SingleChildScrollView(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                    TitleText(text: 'Wallet Transaction Details', fontSize: 18),
                    SizedBox(height: 10.0),
                     _transcation.transactionReference != null && _transcation.transactionReference.isNotEmpty ? Row(children: <Widget>[
                      TitleText(text: 'Transaction Reference: ', fontSize: 10),
                      SizedBox(width: 8),
                      Text(_transcation.transactionReference, style: TextStyle(fontSize: 12))
                    ],) : Container(),
                    SizedBox(height: 8.0),
                    Row(children: <Widget>[
                      TitleText(text: 'Transaction Type: ',fontSize: 10),
                      SizedBox(width: 8),
                      Text(_transcation.type.toUpperCase(), style: TextStyle(fontSize: 12))
                    ],),
                    SizedBox(height: 8.0),
                    Row(children: <Widget>[
                      TitleText(text: 'Transaction Amount: ',fontSize: 10),
                      SizedBox(width: 8),
                      Text('NGN ', style: TextStyle(color: LightColor.red, fontSize: 12)),
                      Text(App.formatAsMoney(_transcation.amount ~/ 100), style: TextStyle(fontSize: 12))
                    ],),
                    SizedBox(height: 8.0),
                    Row(children: <Widget>[
                      TitleText(text: 'Transaction Date: ',fontSize: 10),
                      SizedBox(width: 8),
                      Text(getOrderDate(_transcation.createdAt), style: TextStyle(fontSize: 12) ),
                    ],),
                    SizedBox(height: 8.0),
                 ]
               ),)
           ),
            actions: <Widget>[
              RaisedButton(onPressed: (){ Navigator.pop(context);}, child: Text('Close', style: TextStyle(color: Colors.white),), color: LightColor.orange)
            ],
         );
       } );
  }
  Widget _renderUserHistory(Wallet wallet){
    return Column(children: wallet.transactions.map(( WalletTransaction.Transaction _transaction){
                // print(json.encode(_transaction));
                return GestureDetector(
                  onTap: (){
                    viewWalletDetails(context, _transaction);
                  },
                  child: Container(
                  
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _transaction.type != 'deposit' ? _downArrow() : _upArrow(),
                              SizedBox(width: 16.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    TitleText(
                                      text: _transaction.type == 'deposit'  ? 'CREDIT' : 'DEBIT',
                                    ),
                                    SizedBox(height: 6.0),
                                    Text(getOrderDate(_transaction.createdAt),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12
                                      ),
                                    )
                                ]
                              )
                              ,TitleText(
                                text: 'NGN',
                                fontSize: 12,
                                color: LightColor.orange,
                              ),
                              TitleText(
                                text: App.formatAsMoney(_transaction.amount ~/ 100),
                                fontSize: 16,
                                color: LightColor.orange,
                              )
                            ]
                          ),
                          SizedBox(height: 20),
                          Divider(height: 2.0, color: Colors.grey,)
                      ],
                      
                  )
                )
                );
            }).toList(),
    );
  }
  Widget _answerEntryField(sta) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Answer',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    onChanged: (value) {
                      sta(() {
                         errorMessage = "";
                        _answer = value;
                      });
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xfff3f3f4),
                        filled: true,
                        errorText: _answerValid.isNotEmpty ? _answerValid : null
                    ))
          
        ],
      ),
    );
  }
  Widget _pinEntryField(sta) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Security Pin',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    onChanged: (value) {
                      sta(() {
                         errorMessage = "";
                        _pin = value;
                      });
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xfff3f3f4),
                        filled: true,
                        errorText: _pinValid.isNotEmpty ? _pinValid : null
                    ))
          
        ],
      ),
    );
  }
  Widget _questionsEntryField(List<Question> question, sta) {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Choose Question',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Container(child: Container(
            child:  DropdownButtonHideUnderline(
                
                    child:  Container(
                      child: InputDecorator(

                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        hintText: 'Choose Question',

                      ),
                      isEmpty: _selectedQuestion == null,
                      child:  DropdownButton<Question>(
                        value: _selectedQuestion,
                        isDense: true,
                        onChanged: (Question  value) {
                          sta(() {
                            _selectedQuestion = value;
                          });
                        },
                        items: question.map((Question value) {
                          return new DropdownMenuItem<Question>(
                            value: value,
                            child: new Text(value.question),
                          );
                        }).toList(),
                      ),
                    )
                    ),
                  )
          ))
        ],
      ),
    );
  }
   _onSetUpWalletPress(BuildContext context) async{
     
     var deviceHeight = MediaQuery.of(context).size.height;
     var deviceWidth = MediaQuery.of(context).size.width;
         setState((){
           _answerValid = "";
          _pinValid = "";
        });
     try{
       App.isLoading(context);
       questions = await App.getSecurityQuestions();
       App.stopLoading(context);
       showDialog(context: context,
          builder: (BuildContext context){
            return StatefulBuilder(
              builder: (BuildContext context, sta){
                  return AlertDialog(
                    content: Container(
                        height: deviceHeight * 0.5,
                        width: deviceWidth * 1,
                        child: GestureDetector(
                          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                          child: SingleChildScrollView(
                          
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: TitleText(
                                  text: 'Setup Wallet'
                                ) ,),
                                Divider(height: 4.0, color: Colors.grey),
                                SizedBox(height: 16.0),
                                Container(
                                  // padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Column(children: <Widget>[
                                    _questionsEntryField(questions, sta),
                                    _answerEntryField(sta),
                                    _pinEntryField(sta)
                                  ],)
                                )
                            ]
                          )
                        ) ,),
                    ),
                    actions: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        )
                      ),
                      RaisedButton(
                        padding: EdgeInsets.only(right: 8.0),
                        color: LightColor.orange,
                        onPressed: (){
                          _processSecurityQuestion(context, sta);
                        },
                        child: Text('Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  );
              },
            );
          }
       );
     }catch(error){
       print(error);
     }
  }
  _processSecurityQuestion(BuildContext context, sta) async {
    try{
      if(_selectedQuestion == null){
        return Alert(
              context: context,
              type: AlertType.error,
              title: "Action Error",
              desc: "Please choose a security question",
              buttons: [
                DialogButton(
                  color: LightColor.orange,
                  child: Text(
                    "Continue",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
                  width: 120,
                ),
              ],
            ).show();
      }

      if(_answer.isEmpty){
        return sta((){
          _answerValid = "Please provide answer";
        });
      }
      if(_pin.isEmpty){
        return sta((){
          _pinValid = "Please provide answer";
        });
      }
      App.isLoading(context);
      await App.setSecurityQuestion(_pin, _selectedQuestion.id, _answer);
      App.stopLoading(context);
      Alert(
        context: context,
        type: AlertType.success,
        title: "Action Successful",
        desc: "Wallet Setup Successfully",
        buttons: [
          DialogButton(
            color: LightColor.orange,
            child: Text(
              "Continue",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              setState((){
                errorMessage = "";

              });
              Navigator.pop(context);
              Navigator.pop(context);
            },
            width: 120,
          ),
        ],
      ).show();
    }catch(error){
      print(error);
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: IconButton(icon: Icon(Icons.add_circle), 
        iconSize: 40.0,
        onPressed: (){}, color: LightColor.orange,),
      key: _drawerWidget,
      endDrawer: Drawer(
        child: _appDrawer(context, null)
      ),
        body: SafeArea(
          child: Container(
            child:  Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [LightColor.primaryAccent, LightColor.darkColor]
                  // // colors: [Color(0xfffbb448), Color(0xfff7892b)]
                  )
                  // color: LightColor.darkColor
                ),
                child: FutureBuilder(
                  builder: (BuildContext context, AsyncSnapshot<User> snapshot){
                     if(snapshot.connectionState == ConnectionState.done){
                        if(snapshot.hasData){
                          return Column(
                                children: <Widget>[
                                  Container(
                                    // flex: 1,
                                    child: _walletBalanceScreen(context, snapshot.data),),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), 
                                      topRight: Radius.circular(20)),
                                      color: Colors.white
                                    ),
                                    child: SingleChildScrollView(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                             Row(
                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                               children: <Widget>[
                                               TitleText(
                                                  text: 'My Transactions',
                                                  color: LightColor.darkColor,
                                                  fontWeight: FontWeight.w700
                                                  ,),
                                                 snapshot.data.pinSet ?
                                                 Container() : 
                                                RaisedButton(
                                                  color: LightColor.orange,
                                                  onPressed: (){
                                                    _onSetUpWalletPress(context);
                                                  },
                                                  child: Text('Setup Wallet',
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                )

                                             ],),
                                              SizedBox(height: 20),
                                              _renderUserHistory(snapshot.data.wallet)
                                          ]
                                        ),
                                      )
                                    )
                                  )
                                  )
                              ],
                              );
                        }
                        return Column(
                                children: <Widget>[
                                  Container(
                                    // flex: 1,
                                    child: _walletBalanceScreen(context, null),),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), 
                                      topRight: Radius.circular(20)),
                                      color: Colors.white
                                    ),
                                    child: SingleChildScrollView(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                             TitleText(
                                               text: 'My Transactions',
                                               color: LightColor.darkColor,
                                               fontWeight: FontWeight.w700
                                              ,),
                                              SizedBox(height: 30),
                                              
                                          ]
                                        
                                        ),
                                      )
                                    )
                                  )
                                  )
                              ],
                          );
                     }
                     return Column(
                                children: <Widget>[
                                  Container(
                                    // flex: 1,
                                    child: _walletBalanceScreen(context, null),),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), 
                                      topRight: Radius.circular(20)),
                                      color: Colors.white
                                    ),
                                    child: SingleChildScrollView(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                             TitleText(
                                               text: 'My Transactions',
                                               color: LightColor.darkColor,
                                               fontWeight: FontWeight.w700
                                              ,),
                                              SizedBox(height: 30),
                                              Center(
                                                child: CircularProgressIndicator(),
                                              )
                                          ]
                                        
                                        ),
                                      )
                                    )
                                  )
                                  )
                              ],
                          );
                  },
                  future: getCurrentUser(context)
                )
              )
          )
        ),
      );
  }
}