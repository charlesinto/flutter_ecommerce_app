
import 'package:flutter/material.dart';

class PayStackBank{
  final String name;
  final String slug;
  final String longcode;
  final int id;
  final String gateway;
  final String code;
  final String country;
  final String currency;
  final bool active;
  PayStackBank({@required this.name, @required this.code, @required this.country,
  @required this.currency, @required this.gateway, @required this.id, @required this.longcode, @required this.slug, @required this.active});
}