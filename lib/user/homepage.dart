import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mla_app/user/about_us.dart';
import 'package:flutter_mla_app/user/completed_projects.dart';
import 'package:flutter_mla_app/user/edit_profile.dart';
import 'package:flutter_mla_app/user/gallery.dart';
import 'package:flutter_mla_app/user/logoutpage.dart';
import 'package:flutter_mla_app/user/notifications.dart';
import 'package:flutter_mla_app/user/ongoing_projects.dart';
import 'package:flutter_mla_app/user/profile.dart';
import 'package:flutter_mla_app/user/registered_complaints.dart';
import 'package:flutter_mla_app/user/upcoming_events.dart';
import 'package:flutter_mla_app/user/write_complaint.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  static const snackBarDuration = Duration(seconds: 3);
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final snackBar = SnackBar(
    content: Text('Press back again to leave'),
    duration: Homepage.snackBarDuration,
  );

  late DateTime backButtonPressTime;
  Future<bool> handleWillPop() async {
    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null ||
            now.difference(backButtonPressTime) > Homepage.snackBarDuration;

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
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(
                height: 100,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 250, 202, 23),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: Center(
                    child: Text(
                      'MERA MLA MERE NAAL ',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: GoogleFonts.poppins().fontFamily),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
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
                    CupertinoIcons.home,
                    color: Color.fromARGB(255, 250, 202, 23),
                    size: 25,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  title: Text(
                    'HomePage',
                    style: TextStyle(
                        color: Color.fromARGB(255, 250, 202, 23), fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                  right: 5,
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      width: 1,
                      color: Colors.black,
                    ),
                  ),
                  leading: Icon(
                    Icons.edit_note_sharp,
                    color: Color.fromARGB(255, 250, 202, 23),
                    size: 30,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileUpdation(),
                      ),
                    );
                  },
                  title: Text(
                    'Edit Profile',
                    style: TextStyle(
                        color: Color.fromARGB(255, 250, 202, 23), fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                  right: 5,
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      width: 1,
                      color: Colors.black,
                    ),
                  ),
                  leading: Icon(
                    Icons.edit_note_sharp,
                    color: Color.fromARGB(255, 250, 202, 23),
                    size: 30,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisteredComplaints(),
                      ),
                    );
                  },
                  title: Text(
                    'View Complaints',
                    style: TextStyle(
                        color: Color.fromARGB(255, 250, 202, 23), fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
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
                    Icons.logout,
                    color: Color.fromARGB(255, 250, 202, 23),
                    size: 25,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LogoutPage(),
                      ),
                    );
                  },
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Color.fromARGB(255, 250, 202, 23),
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
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
                    CupertinoIcons.question,
                    color: Color.fromARGB(255, 250, 202, 23),
                    size: 25,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutUs(),
                      ),
                    );
                  },
                  title: Text(
                    'About Us',
                    style: TextStyle(
                      color: Color.fromARGB(255, 250, 202, 23),
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 375,
              ),
              Container(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    '  Version - 1.0.0',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                CupertinoIcons.bell,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Notifications()));
              },
            )
          ],
          title: Text(
            "DASHBOARD",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: GoogleFonts.poppins().fontFamily),
          ),
          backgroundColor: Color.fromARGB(255, 250, 202, 23),
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 15,
            ),
            CarouselSlider(
              items: [
                //1st Image of Slider
                Container(
                  margin: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage("assets/images/carousel 3.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                //2nd Image of Slider
                Container(
                  margin: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage("assets/images/carousel 2.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage("assets/images/carousel 1.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage("assets/images/carousel 4.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],

              //Slider Container properties
              options: CarouselOptions(
                height: 190.0,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: const Duration(milliseconds: 3000),
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 500),
                viewportFraction: 0.8,
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
              crossAxisCount: 3,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpcomingEvents(),
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
                            "Upcoming\nEvents",
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
                        builder: (context) => OngoingProjects(),
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
                            "Ongoing\nProjects",
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
                        builder: (context) => CompletedProjects(),
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
                            "Completed\nProjects",
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
                        builder: (context) => Gallery(),
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
                            "Gallery",
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
                        builder: (context) => ProfilePage(),
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
                            CupertinoIcons.profile_circled,
                            color: Colors.black,
                            size: 30,
                          ),
                          Text(
                            "Profile",
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
                        builder: (context) => WriteComplaint(),
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
                            CupertinoIcons.envelope,
                            color: Colors.black,
                            size: 30,
                          ),
                          Text(
                            "Complaints",
                            style: TextStyle(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
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
            Divider(
              indent: 10,
              endIndent: 10,
              thickness: 2.5,
              color: Colors.black,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Message From MLA",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
              child: Container(
                height: 130,
                width: 190,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 250, 202, 23),
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    ' "THANKS For All The Support !" ',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
