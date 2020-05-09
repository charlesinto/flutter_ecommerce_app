import 'package:flutter/cupertino.dart';

class Bank{
  final int createdAt;
  final int id;
  final String name;
  final String code;
  final String longcode;
  final String gateway;
  final bool active;
  final String accountNumber;
  final String accountName;
  final String slug;
  final int owner;
  Bank({@required this.id, @required this.createdAt, @required this.name, @required this.accountName, @required this.accountNumber,
  @required this.active, @required this.code, @required this.gateway, @required this.longcode, @required this.owner, @required this.slug});

  Map toJson(){
    return {
      "createdAt": createdAt,
      "id": id,
      "name": name,
      "accountNumber": accountNumber,
      "accountName": accountName,
      "slug": slug,
      "code": code,
      "longcode": longcode,
      "gateway": gateway,
      "active": active,
      "owner": owner
    };
  }

}

/*
{
      "createdAt": 1583405384523,
      "updatedAt": 1583405384523,
      "id": 1,
      "name": "Access Bank",
      "accountNumber": "20202010",
      "accountName": "onuorah charles",
      "slug": "access-bank",
      "code": "044",
      "longcode": "044150149",
      "gateway": "emandate",
      "active": true,
      "edited": false,
      "owner": 1
    }
*/