

import 'package:flutter/cupertino.dart';

class Transaction{
  final int createdAt;
  final int id;
  final int amount;
  final String currency;
  final String type;
  final bool isApproved;
  final String transactionReference;
  final int owner;
  final int wallet;
  Transaction({@required this.createdAt, @required this.id, @required this.amount, @required this.currency
  , @required this.type, @required this.isApproved, @required this.transactionReference, 
  @required this.owner, @required this.wallet} );

  Map toJson(){
    return {
      'id': id,
      'createdAt': createdAt,
      'amount': amount,
      'currency': currency,
      'type': type,
      'isApproved': isApproved,
      'transactionReference': transactionReference,
      'owner': owner,
      'wallet': wallet
    };
  }
}
