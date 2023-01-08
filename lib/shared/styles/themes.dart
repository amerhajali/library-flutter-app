import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

const MaterialColor defaultColor = Colors.indigo;

ThemeData darkTheme = ThemeData(
    fontFamily: 'MeriendaOne',
    scaffoldBackgroundColor: HexColor('333739'),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.red,
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light),
      backgroundColor: defaultColor,
      elevation: 0.0,
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        elevation: 20,
        backgroundColor: HexColor('333739')),
    primarySwatch: defaultColor,
    textTheme: const TextTheme(
        subtitle1: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.0),
        bodyText1: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w300, color: Colors.white),
        bodyText2: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white)));

ThemeData lightTheme = ThemeData(
    fontFamily: 'MeriendaOne',
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark),
      backgroundColor: defaultColor,
      elevation: 0.0,
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: defaultColor,
        elevation: 20),
    primarySwatch: defaultColor,
    textTheme: const TextTheme(
        subtitle1: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            height: 1.0),
        bodyText1: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black),
        bodyText2: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black)));
