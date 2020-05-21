

import 'package:flutter/cupertino.dart';
import 'package:flutter_ecommerce_app/src/model/app_transaction.dart';

class Wallet{
  final int createdAt;
  final int id;
  final int balance;
  final String currency;
  final List<Transaction> transactions;

  Wallet({@required this.currency, @required this.id, @required this.createdAt, @required this.balance,
  @required this.transactions});
  Map toJson(){
    return {
      'id': id,
      'createdAt': createdAt,
      'balance': balance,
      'transactions': transactions
    };
  }
}
