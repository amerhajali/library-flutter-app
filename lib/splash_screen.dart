import 'dart:async';

import 'package:flutter/material.dart';
import 'package:task_library/shared/components.dart';
import 'package:task_library/shared/styles/constants.dart';
import 'package:task_library/shared/styles/themes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: MyColors.whiteColor,
                    radius: 100,
                    child: Image(image: AssetImage('assets/images/logos.jpg')),
                  )
                ],
              ),
            ],
          ),
          Text(
            'Library App',
            style: TextStyle(color: Colors.white, fontSize: 30),
          )
        ],
      ),
    );
  }
}
