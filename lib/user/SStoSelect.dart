import 'package:flutter/material.dart';
import 'package:flutter_mla_app/user/phoneauth.dart';
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
        home: SingleChildScrollView(
          child: Material(
            color: Colors.yellow,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Image.asset(
                  "assets/images/splash.jpg",
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "MERA MLA\nMERE NAAL",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Container(
                  height: 40,
                  width: 40,
                  color: Colors.transparent,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "LOADING",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 135,
                ),
                Text(
                  "BY",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "IIY Software Pvt Ltd",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ));
  }
}
