import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mla_app/user/phoneauth.dart';
import 'package:flutter_mla_app/user/user_model.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      // nameEditingController.text = '${loggedInUser.firstName} ${loggedInUser.lastName}';
      // addressEditingController.text = '${loggedInUser.address}';
      // emailEditingController.text = '${loggedInUser.email}';
      //
      // designationEditingController.text = '${loggedInUser.preference}';
      // numberEditingController.text = '${loggedInUser.contactNumber}';
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 250, 202, 23),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      key: _formKey,
      backgroundColor: Color.fromARGB(255, 250, 202, 23),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 250, 202, 23),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(0x00C52121),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                  child: Text(
                    '${loggedInUser.firstName}',
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.headline1,
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                elevation: 15,
                child: Container(
                  width: double.infinity,
                  height: 800,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    color: Color(0xFFEEEEEE),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Padding(
                        //   padding: EdgeInsetsDirectional.fromSTEB(65, 5, 0, 0),
                        //   child: Text(
                        //     'Full Name',
                        //     textAlign: TextAlign.start,
                        //     style: GoogleFonts.poppins(
                        //       textStyle: Theme.of(context).textTheme.bodyText1,
                        //       fontSize: 10,
                        //       color: Color(0xFF404040),
                        //     ),
                        //   ),
                        // ),

                        Padding(
                          padding: const EdgeInsets.all(25),
                          child: Text(
                            'DETAILS',
                            style: GoogleFonts.lato(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                width: 1,
                                color: Colors.black,
                              ),
                            ),
                            leading: Icon(
                              CupertinoIcons.person,
                              color: Colors.black,
                              size: 25,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            title: Text(
                              '${loggedInUser.firstName}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                width: 1,
                                color: Colors.black,
                              ),
                            ),
                            leading: Icon(
                              CupertinoIcons.location,
                              color: Colors.black,
                              size: 25,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            title: Text(
                              '${loggedInUser.address}',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ),
                        ),

                        //Phone ---->
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                width: 1,
                                color: Colors.black,
                              ),
                            ),
                            leading: Icon(
                              CupertinoIcons.phone,
                              color: Colors.black,
                              size: 25,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            title: Text(
                              '${loggedInUser.contactNumber}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => PhoneAuthPage(),
      ),
    );
  }
}
