import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpdesk_shift/Screens/authentication/login.dart';
import 'package:helpdesk_shift/main.dart';
import 'package:helpdesk_shift/provider/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key key,
  }) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    super.initState();
    displaySplash();
  }

  displaySplash() {
    Timer(
      Duration(milliseconds: 1500),
      () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeController()),
          (Route<dynamic> route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;

    double _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: _screenWidth,
        height: _screenHeight,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(50)),
                child: Column(
                  children: [
                    Image.asset(
                      Assets.covidBackground,
                    ),
                    Text("NO COVID: HELP DESK", style: myStyle(20, Colors.blue, FontWeight.bold),
                            textAlign: TextAlign.center,),
                  ],
                ),
                
              ),
              SizedBox(height: 10),
              CircularProgressIndicator(
                backgroundColor: Colors.black,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
