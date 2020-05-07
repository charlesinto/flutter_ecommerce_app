
import 'package:flutter/cupertino.dart';

class Owner{
  final int createdAt;
  final int updatedAt;
  final int id;
  final String emailAddress;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String countryCode;
  final String type;
  final String gender;
  final String profileImage;
  final String country;
  final String isoCode;
  final bool isBlocked;
  final String blockedReason;
  final String referralCode;
  final String agentIdentification;
  final String agentApproved;
  final String companyName;
  final String headOfficeAddress;
  final String contactLine;
  final String sellerIdentification;
  final bool sellerApproved;
  final bool pinSet;
  final int rating;
  final String passwordResetToken;
  final int passwordResetTokenExpiresAt;
  final String emailProofToken;
  final int emailProofTokenExpiresAt;
  final bool emailVerified;
  final String tosAcceptedByIp;
  final int lastSeenAt;
  final String referredBy;
  final String sellerAgent;

  Owner({@required this.id, this.createdAt, this.updatedAt, @required this.emailAddress, @required this.firstName,
    @required this.lastName, @required this.phoneNumber, @required this.country, this.countryCode, this.type,
    this.isoCode, this.isBlocked, this.blockedReason, this.referralCode, this.referredBy, this.agentIdentification,
    this.agentApproved, this.sellerAgent, this.lastSeenAt, this.tosAcceptedByIp, this.emailProofToken,
    this.emailProofTokenExpiresAt, this.passwordResetToken, this.passwordResetTokenExpiresAt, this.rating, this.pinSet,
    this.sellerApproved, this.sellerIdentification, this.contactLine, this.companyName, this.profileImage, this.gender,
    this.emailVerified, this.headOfficeAddress});
}

/*
"owner": {
        "createdAt": 1583397807975,
        "updatedAt": 1587197906291,
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
        "lastSeenAt": 1587200000000,
        "referredBy": null,
        "sellerAgent": null
      }

*/