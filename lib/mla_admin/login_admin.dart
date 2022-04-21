import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mla_app/datanextscreen.dart';
import 'package:flutter_mla_app/mla_admin/homepage_admin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminLoginPage extends StatefulWidget {
  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading=false;
  User_Info obj = User_Info(
      firstName: '',
      lastName: '',
      contactNumber: "0",
      email: '',
      password: '',
      address: '');
  //Editing COntroler
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool passwordVisibility1 = false;
  final _auth = FirebaseAuth.instance;
  String? errorMessage;

  onAlertButtonPressed1(context) {
    AlertDialog alert = AlertDialog(
      title: Text(
        "Some Error Occured!",
        style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.bodyText1, fontSize: 22),
      ),
      content: Text(
        "Please Enter The Email ",
        style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.bodyText1, fontSize: 15),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'OK',
            style: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.bodyText1, fontSize: 15),
          ),
          onPressed: () {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context, rootNavigator: true).pop();
          },
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

  onAlertButtonPressed2(context) {
    AlertDialog alert = AlertDialog(
      title: Text(
        "Some Error Occured !",
        style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.bodyText1, fontSize: 22),
      ),
      content: Text(
        "Please Enter The Password ",
        style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.bodyText1, fontSize: 15),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'OK',
            style: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.bodyText1, fontSize: 15),
          ),
          onPressed: () {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context, rootNavigator: true).pop();
          },
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

  onAlertButtonPressed3(context) {
    AlertDialog alert = AlertDialog(
      title: Text(
        "Some Error Occured!",
        style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.bodyText1, fontSize: 22),
      ),
      content: Text(
        "Please Check Your Username/Email",
        style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.bodyText1, fontSize: 15),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'OK',
            style: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.bodyText1, fontSize: 15),
          ),
          onPressed: () {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context, rootNavigator: true).pop();
          },
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

  onAlertButtonPressed4(context) {
    AlertDialog alert = AlertDialog(
      title: Text(
        "Some Error Occured!",
        style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.bodyText1, fontSize: 22),
      ),
      content: Text(
        "Please Check Your Password\nMin 6 Characters Required",
        style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.bodyText1, fontSize: 15),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'OK',
            style: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.bodyText1, fontSize: 15),
          ),
          onPressed: () {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context, rootNavigator: true).pop();
          },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ADMIN LOGIN !",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: GoogleFonts.lato().fontFamily,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,color: Colors.black
          ),
          onPressed: (){
          Navigator.of(context).pop();
        },),
        backgroundColor: Color.fromARGB(255, 250, 202, 23),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Image.asset(
                  "assets/images/1.png",
                  fit: BoxFit.cover,
                ),
                Text(
                  "WELCOME !",
                  style: TextStyle(
                    fontFamily: GoogleFonts.lato().fontFamily,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 20.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            onAlertButtonPressed1(context);
                            return ("Please Enter your Email");
                          }
                          // reg expression for email validation
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            onAlertButtonPressed3(context);
                            return ("Please Enter a valid email");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          var emailController;
                          emailController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Username or Email',
                          labelStyle: TextStyle(
                            fontFamily: GoogleFonts.lato().fontFamily,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordController,
                        validator: (value) {
                          RegExp regex = new RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            onAlertButtonPressed2(context);
                            return ("Password is required for Login");
                          }
                          if (!regex.hasMatch(value)) {
                            onAlertButtonPressed4(context);
                            return ("Enter Valid Password(Min. 6 Characters)");
                          }
                        },
                        onSaved: (value) {
                          passwordController.text = value!;
                        },
                        textInputAction: TextInputAction.done,
                        obscureText: !passwordVisibility1,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontFamily: GoogleFonts.lato().fontFamily,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          suffixIcon: InkWell(
                            onTap: () => setState(
                              () => passwordVisibility1 = !passwordVisibility1,
                            ),
                            child: Icon(
                              passwordVisibility1
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.black,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      SizedBox(
                        width: 370,
                        height: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black)),
                            color: Color.fromARGB(255, 250, 202, 23),
                            onPressed: () async {
                              signIn(emailController.text,
                                  passwordController.text);
                              setState(() {
                                isLoading = true;
                              });
                              await Future.delayed(const Duration(seconds: 5));
                            },
                            child: (isLoading)
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 2,
                                    ))
                                : Text(
                                    'L O G I N',
                                    style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.lato().fontFamily,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.black),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(msg: "Login Successful"),
                  prefs.setString('email', 'useremail@gmail.com'),
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminHomePage(),
                    ),
                  ),
                });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";

            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(
            msg: errorMessage!, toastLength: Toast.LENGTH_LONG);
        setState(() {
          isLoading = false;
        });
      }
    }
    @override
    void dispose() {
      super.dispose();
    }
  }
}
