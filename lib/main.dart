import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mla_app/mla_admin/homepage_admin.dart';
import 'package:flutter_mla_app/user/SStoHome.dart';
import 'package:flutter_mla_app/user/SStoSelect.dart';
import 'package:flutter_mla_app/user/SstoAdminHome.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString("email");
  runApp(
    MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: email == null
          ? SplashScreenToSelectionPage()
          : email == "admin" ? SplashScreenToAdminHomePage() : SplashScreenToHomePage(),
    ),
  );
}
