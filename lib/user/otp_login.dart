import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mla_app/user/homepage.dart';
import 'package:flutter_mla_app/user/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../datanextscreen.dart';

class AuthClass {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  User_Info obj = User_Info(
      firstName: 'Update Required',
      lastName: 'Update Required',
      contactNumber: 'Update Required',
      email: '',
      password: '',
      address: 'Update Required');

  void storeTokenAndData(UserCredential userCredential) async {
    print("Storing token and data");
    await storage.write(
      key: "Token",
      value: userCredential.credential!.token.toString(),
    );
    await storage.write(
        key: "usercredential", value: userCredential.toString());
  }

  AlertBox(BuildContext context, String ref) {
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.black, width: 1.5)),
      title: Text(
        "Can't Proceed",
        style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.bodyText1, fontSize: 22),
      ),
      content: Text(
        "Please Enter Your Mobile Number",
        style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.bodyText1, fontSize: 15),
      ),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () {},
          style: ButtonStyle(
            side: MaterialStateProperty.all(BorderSide(color: Colors.black)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
          ),
          child: Text(
            "OK",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context, Function setData) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      showSnackBar(context, "Enter The Received OTP Above");
    };
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException exception) {
      showSnackBar(context, "Invalid Mobile Number !");
    };
    void Function(String verificationID, [int? forceResnedingtoken]) codeSent =
        (String verificationID, [int? forceResnedingtoken]) {
      showSnackBar(context, "Verification Code Sent To Your Number");
      setData(verificationID);
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationID) {
      showSnackBar(context, "Request Time Out");
    };
    try {
      await _auth.verifyPhoneNumber(
          timeout: Duration(seconds: 60),
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signInwithPhoneNumber(
      String verificationId, String smsCode, BuildContext context) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      storeTokenAndData(userCredential);
      postDetailsToFirestore();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => Homepage()),
          (route) => false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', 'user');
      showSnackBar(context, "You're now Logged In");
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
  }

  postDetailsToFirestore() async {
    //calling firestore
    //calling user model
    //sending data
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    //writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = obj.firstName;
    userModel.lastName = obj.lastName;
    userModel.contactNumber = obj.contactNumber.toString();
    userModel.address = obj.address;

    await firebaseFirestore.collection("users").doc(user.uid).set(
          userModel.toMap(),
        );
  }
}

void showSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(content: Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
