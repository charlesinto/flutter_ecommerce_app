

import 'package:flutter/cupertino.dart';
import 'package:flutter_ecommerce_app/src/model/app_wallet.dart';

class User{
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final int id;
  final String token;
  final String countryCode;
  final String type;
  final String gender;
  final String profileImage;
  final String isoCode;
  final String country;
  final bool isBlocked;
  final String blockedReason;
  final String referralCode;
  final String agentIdentification;
  final bool agentApproved;
  final String companyName;
  final String headOfficeAddress;
  final String contactLine;
  final String sellerIdentification ;
  final bool sellerApproved;
  bool pinSet = false;
  final int rating;
  final String passwordResetToken;
  final int passwordResetTokenExpiresAt;
  final int emailProofToken;
  final int emailProofTokenExpiresAt;
  final bool emailVerified;
  final String tosAcceptedByIp;
  final int lastSeenAt;
  Wallet wallet;
  final String referredBy;
  final String sellerAgent;

  User({@required this.firstName, @required this.lastName,
     @required this.email, @required this.phoneNumber, @required this.id,
     @required this.agentApproved, @required this.agentIdentification, @required this.blockedReason
     , @required this.companyName, @required this.contactLine, @required this.country, @required this.countryCode
     , @required this.emailProofToken, @required this.emailProofTokenExpiresAt, @required this.emailVerified, @required this.gender
     , @required this.headOfficeAddress, @required this.isBlocked, @required this.isoCode, @required this.lastSeenAt
     , @required this.passwordResetToken, @required this.passwordResetTokenExpiresAt, @required this.pinSet
     , @required this.profileImage, @required this.rating, @required this.referralCode, @required this.referredBy,
     @required this.sellerAgent, @required this.sellerApproved, @required this.sellerIdentification, @required this.token
     , @required this.tosAcceptedByIp, @required this.type, this.wallet});
  
  Map toJson(){
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'id': id,
      'token': token,
      'countryCode': countryCode,
      'type': type,
      'gender': gender,
      'profileImage': profileImage,
      'country': country,
      'isBlocked': isBlocked,
      'blockedReason': blockedReason,
      'referralCode': referralCode,
      'agentIdentification': agentIdentification,
      'agentApproved': agentApproved,
      'companyName': companyName,
      'headOfficeAddress': headOfficeAddress,
      'contactLine': contactLine,
      'sellerIdentification': sellerIdentification ,
      'sellerApproved': sellerApproved,
      'pinSet': pinSet,
      'rating': rating,
      'passwordResetToken': passwordResetToken,
      'passwordResetTokenExpiresAt': passwordResetTokenExpiresAt,
      'emailProofToken': emailProofToken,
      'emailProofTokenExpiresAt': emailProofTokenExpiresAt,
      'emailVerified': emailVerified,
      'tosAcceptedByIp': tosAcceptedByIp,
      'lastSeenAt': lastSeenAt,
      'referredBy': referredBy,
      'sellerAgent': sellerAgent,
      'wallet': wallet
    };
  }
}

/*
 "createdAt": 1583397807975,
    "updatedAt": 1587467767314,
    "id": 1,
    "emailAddress": "md@example.com",
    "firstName": "super",
    "lastName": "tester",
    "phoneNumber": "8163113450",
    "countryCode": "234",
    "type": "seller",
    "gender": "Male",
    "profileImage": "",
    "country": "Nigeria",
    "isoCode": "NG",
    "isBlocked": false,
    "blockedReason": "",
    "referralCode": "WCHAAJAX",
    "agentIdentification": "",
    "agentApproved": false,
    "companyName": "c&sons limited",
    "headOfficeAddress": "Lekki Phase 1",
    "contactLine": "09010502030",
    "sellerIdentification": "",
    "sellerApproved": false,
    "pinSet": true,
    "rating": 0,
    "passwordResetToken": "0",
    "passwordResetTokenExpiresAt": 0,
    "emailProofToken": 0,
    "emailProofTokenExpiresAt": 0,
    "emailVerified": true,
    "tosAcceptedByIp": "::ffff:105.112.179.181",
    "lastSeenAt": 1587470000000,
    "referredBy": null,
    "sellerAgent": null

    token

*/