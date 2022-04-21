import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mla_app/mla_admin/add_completed_projects.dart';
import 'package:flutter_mla_app/mla_admin/add_gallery_images.dart';
import 'package:flutter_mla_app/mla_admin/add_ongoing_projects.dart';
import 'package:flutter_mla_app/mla_admin/add_up_events.dart';
import 'package:flutter_mla_app/mla_admin/received_complaints.dart';
import 'package:flutter_mla_app/user/logoutpage.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminHomePage extends StatefulWidget {
  static const snackBarDuration = Duration(seconds: 3);
  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {

  final snackBar = SnackBar(
    content: Text('Press back again to leave'),
    duration: AdminHomePage.snackBarDuration,
  );

  late DateTime backButtonPressTime;
  Future<bool> handleWillPop() async {
    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null ||
            now.difference(backButtonPressTime) > AdminHomePage.snackBarDuration;

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: handleWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
              color: Colors.black
            ),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LogoutPage(),
                    ),
                  );
                },
                child: Row(children:[
                Center(child: Text(
                    "Logout",
                  style: TextStyle(color: Colors.black),
                 ),
                ),
                   Icon(
                    Icons.logout,
                    color: Colors.black,
                    size: 30,
                  ),

      ]),
              ),
            )
          ],
          backgroundColor: Color.fromARGB(255, 250, 202, 23),
          title: Text(
            "Admin Panel",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                 Text("SELECT BELOW",
                   style: TextStyle(
                       fontFamily: GoogleFonts.poppins().fontFamily,
                       fontSize: 20
                   ),
                 ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  indent: 10,
                  endIndent: 10,
                  thickness: 2.5,
                  color: Colors.black,
                ),
                GridView.count(
                  crossAxisCount: 2,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddUpcomingEvent(),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Color.fromARGB(255, 250, 202, 23),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                CupertinoIcons.calendar,
                                color: Colors.black,
                                size: 30,
                              ),
                              Text(
                                "Add +\nUpcoming\nEvents",
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddOngoingProjects(),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Color.fromARGB(255, 250, 202, 23),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                CupertinoIcons.bolt_horizontal,
                                color: Colors.black,
                                size: 35,
                              ),
                              Text(
                                "Add +\nOngoing\nProjects",
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddCompletedProjects(),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Color.fromARGB(255, 250, 202, 23),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                CupertinoIcons.checkmark_alt,
                                color: Colors.black,
                                size: 35,
                              ),
                              Text(
                                "Add +\nCompleted\nProjects",
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddGalleryImages(),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Color.fromARGB(255, 250, 202, 23),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                CupertinoIcons.photo,
                                color: Colors.black,
                                size: 30,
                              ),
                              Text(
                                "Add +\nGallery\nImages",
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  padding: EdgeInsets.all(10),
                  shrinkWrap: true,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReceivedComplaints()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 160,
                        width: 400,
                        color: Color.fromARGB(255, 250, 202, 23),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              CupertinoIcons.envelope,
                              color: Colors.black,
                              size: 40,
                            ),
                            Text(
                              "# Received Complaints #",
                              style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                color: Colors.black,
                                fontSize: 19,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Divider(
                  indent: 10,
                  endIndent: 10,
                  thickness: 2.5,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
