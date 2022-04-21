import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mla_app/user/homepage.dart';
import 'package:flutter_mla_app/user/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileUpdation extends StatefulWidget {
  const ProfileUpdation({Key? key}) : super(key: key);

  @override
  _ProfileUpdationState createState() => _ProfileUpdationState();
}

class _ProfileUpdationState extends State<ProfileUpdation> {
  final _formKey = GlobalKey<FormState>();
  String dropDownValue = "";
  final nameEditingController = TextEditingController();
  final addressEditingController = TextEditingController();
  final numberEditingController = TextEditingController();
  bool _displayNameValid = true;
  bool _addressValid = true;
  bool _numberValid = true;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> updateUser() {
    print(FirebaseAuth.instance.currentUser!.uid);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    //users.doc(FirebaseAuth.instance.currentUser!.uid).update;
    return users.doc(FirebaseAuth.instance.currentUser!.uid).update({
      'firstName': '${nameEditingController.text}',
      'contactNumber': '${numberEditingController.text}',
      'address': '${addressEditingController.text}'
    }).then((value) {
      Future.delayed(Duration(milliseconds: 1700), () {
        Fluttertoast.showToast(msg: "Profile Has Been Updated");
      });
    }).catchError((error) {
      Future.delayed(Duration(milliseconds: 1700), () {
        Fluttertoast.showToast(msg: "Couldn't Update Profile :$error");
      });
    });
  }

// Function to update data
  Future<void> updateProfileData() async {
    setState(() {
      //Condition to check name field
      nameEditingController.text.trim().length < 3 ||
              nameEditingController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;

      //Condition to check number
      numberEditingController.text.trim().length < 10 ||
              numberEditingController.text.trim().length > 10
          ? _numberValid = false
          : _numberValid = true;
    });

    //  if(_displayNameValid && _addressValid && _numberValid){
    //    loggedInUser.doc(widget.user.uid)

    if (_displayNameValid && _addressValid && _numberValid) {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      print('Success');
      await updateUser();
    }

    //  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                    'EDIT PROFILE',
                    style: GoogleFonts.lato(
                      fontSize: 22,
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 5, 0, 0),
                        child: Text(
                          'FULL NAME',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.bodyText1,
                            fontSize: 15,
                            color: Color(0xFF404040),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 15),
                        child: TextFormField(
                          cursorColor: Colors.black,
                          controller: nameEditingController,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'Update Name',
                            errorText:
                                _displayNameValid ? null : "Name is too short",
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF222222),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF222222),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            prefixIcon: Icon(
                              Icons.person_outline_rounded,
                              color: Colors.black,
                            ),
                          ),
                          style: GoogleFonts.lato(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 5, 0, 0),
                        child: Text(
                          'MOBILE NO.',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            textStyle: Theme.of(context).textTheme.bodyText1,
                            fontSize: 15,
                            color: Color(0xFF404040),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 15),
                        child: TextFormField(
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.black,
                          controller: numberEditingController,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'Update Mobile Number',
                            errorText: _numberValid
                                ? null
                                : 'Enter valid number - 10 digits',
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF222222),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF222222),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            prefixIcon: Icon(
                              Icons.local_phone,
                              color: Colors.black,
                            ),
                          ),
                          style: GoogleFonts.lato(
                            fontSize: 16,
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 5, 0, 0),
                        child: Text(
                          'ADDRESS',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            textStyle: Theme.of(context).textTheme.bodyText1,
                            fontSize: 15,
                            color: Color(0xFF404040),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                          15,
                          0,
                          15,
                          15,
                        ),
                        child: TextFormField(
                          cursorColor: Colors.black,
                          controller: addressEditingController,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'Update Address',
                            errorText: _numberValid
                                ? null
                                : 'Enter valid number - 10 digits',
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF222222),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF222222),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: Colors.black,
                            ),
                          ),
                          style: GoogleFonts.lato(
                            fontSize: 16,
                          ),
                        ),
                      ),

                      //Button

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 110, vertical: 32),
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 250, 202, 23),
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Colors.black),
                          ),
                          child: (isLoading)
                              ? Center(
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    color: Color.fromARGB(255, 250, 202, 23),
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 2.0,
                                    ),
                                  ),
                                )
                              : MaterialButton(
                                  onPressed: () {
                                    updateProfileData();
                                    setState(() {
                                      isLoading = true;
                                    });
                                    Future.delayed(
                                      Duration(milliseconds: 2000),
                                      () {
                                        /*Fluttertoast.showToast(
                                          msg: "Profile Has Been Updated");*/
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Homepage(),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'SUBMIT',
                                        style: GoogleFonts.lato(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
