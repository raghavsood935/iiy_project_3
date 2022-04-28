import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mla_app/user/user_phoneauth.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreenToSelectionPage extends StatefulWidget {
  @override
  State<SplashScreenToSelectionPage> createState() =>
      _SplashScreenToSelectionPageState();
}

class _SplashScreenToSelectionPageState
    extends State<SplashScreenToSelectionPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 3500), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => PhoneAuthPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: Scaffold(
        backgroundColor: Colors.yellow[600],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  Text(
                    "MERA MLA",
                    style: TextStyle(
                        fontSize: 45,
                        fontFamily: GoogleFonts.josefinSans().fontFamily,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "MERE NAAL",
                    style: TextStyle(
                        fontSize: 35,
                        fontFamily: GoogleFonts.josefinSans().fontFamily,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  CircleAvatar(
                    radius: 135,
                    backgroundImage: AssetImage(
                      "assets/images/splash.jpg",
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  CupertinoActivityIndicator(
                    radius: 20,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    "BY",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "IIY Software Pvt Ltd",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
