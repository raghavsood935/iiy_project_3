import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mla_app/user/phoneauth.dart';
import 'package:flutter_mla_app/user/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutPage extends StatefulWidget {
  LogoutPage({Key? key}) : super(key: key);

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.logout,
              ),
              onPressed: () async {
                logout(context);
                Fluttertoast.showToast(msg: "Successfully Logged Out");
              },
              iconSize: 80,
            ),
            Text(
              'Logout',
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.headline1,
                fontSize: 28,
                color: Colors.black38,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }

  //Logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => PhoneAuthPage(),
      ),
    ); 
  }
}
