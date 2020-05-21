import 'package:flutter/material.dart';

class LightColor {
  static const Color background = Color(0XFFFFFFFF);

  static const Color titleTextColor = const Color(0xff1d2635);
  static const Color subTitleTextColor = const Color(0xff797878);

  static const Color skyBlue = Color(0xff2890c8);
  static const Color lightBlue = Color(0xff5c3dff);
  

  // static const Color orange = Color(0xffE65829);
  static const Color orange = Color(0xff0085cb);
  
  static const Color red = Color(0xffF72804);

  static const Color lightGrey = Color(0xffE1E2E4);
  static const Color grey = Color(0xffA1A3A6);
  static const Color darkgrey = Color(0xff747F8F);
  
  static const Color iconColor = Color(0xffa8a09b);
  static const Color yellowColor = Color(0xfffbba01);

  static const Color black = Color(0xff20262C);
  static const Color lightblack = Color(0xff5F5F60);

  static const Color primaryAccent = Color(0xff0bb5ff);

  static const Color lightColor = Color(0xff6be7ff);

  static const Color darkColor = Color(0xff0085cb);

  static List pieColors = [
    Colors.indigo[400],
    Colors.blue,
    Colors.green,
    Colors.indigo,
    Colors.deepOrange,
    Colors.brown,
    Colors.deepPurpleAccent,
    Colors.blueGrey,
    Colors.cyanAccent,
    Colors.greenAccent,
    Colors.black12,
    Colors.lightBlueAccent,
    Colors.orange[800],
    Colors.purpleAccent,
    Colors.blueGrey,
    Colors.red,
    Colors.tealAccent,
    Colors.redAccent,
    Colors.pinkAccent,
    Colors.lightBlueAccent,
    Colors.indigoAccent,
    Colors.deepOrangeAccent,
    Colors.amberAccent,
    Colors.cyan,
    Colors.purpleAccent,
    Colors.indigoAccent
  ];
  static List<BoxShadow> neumorpShadow = [
    BoxShadow(
        color: Colors.white.withOpacity(0.5), spreadRadius: -5, offset: Offset(0, 5), blurRadius: 30),
    BoxShadow(
        color: Colors.white.withOpacity(.2),
        spreadRadius: 2,

        offset: Offset(7, 7),
        blurRadius: 20)
  ];
  static Color getBackgroundColor(String text){
    var firstCharacter = text.substring(0,1).toLowerCase();
    return pieColors[getCharcterIndex(firstCharacter)];
  }
  static int getCharcterIndex(String firstCharacter){
    int index;
    switch(firstCharacter){
      case 'a':
        index = 0;
        break;
      case 'b':
        index = 1;
        break;
        case 'c':
        index = 2;
        break;
        case 'd':
        index = 3;
        break;
        case 'e':
        index = 4;
        break;
        case 'f':
        index = 5;
        break;
        case 'g':
        index = 6;
        break;
        case 'h':
        index = 7;
        break;
        case 'i':
        index = 8;
        break;
        case 'j':
        index = 9;
        break;
        case 'k':
        index = 10;
        break;
        case 'l':
        index = 11;
        break;
        case 'm':
        index = 12;
        break;
        case 'n':
        index = 13;
        break;
        case 'o':
        index = 14;
        break;
        case 'p':
        index = 15;
        break;
        case 'q':
        index = 16;
        break;
        case 'r':
        index = 17;
        break;
         case 's':
        index = 18;
        break;
        case 't':
        index = 18;
        break;
        case 'u':
        index = 19;
        break;
        case 'v':
        index = 20;
        break;
        case 'w':
        index = 21;
        break;
        case 'x':
        index = 22;
        break;
        case 'y':
        index = 23;
        break;
        case 'z':
        index = 24;
        break;
        default:
          index = 25;
    }
    return index;
  }
}