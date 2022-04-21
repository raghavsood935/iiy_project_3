import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUs extends StatefulWidget {
  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Us !",
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 21,
            color: Colors.black,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 250, 202, 23),
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 70,
            ),
            Image.asset(
              "assets/images/2.png",
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 3),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black,
                    width: 1.5, // Underline thickness
                  ),
                ),
              ),
              child: Text(
                "IIY Software Private Limited",
                style: TextStyle(
                  fontFamily: GoogleFonts.lato().fontFamily,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              "OFFICES - PUNE | MOHALI | BATHINDA",
              style: TextStyle(
                fontFamily: GoogleFonts.lato().fontFamily,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Email:- hr@iiysoftware.com",
              style: TextStyle(
                fontFamily: GoogleFonts.lato().fontFamily,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
