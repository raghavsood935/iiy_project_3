import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mla_app/mla_admin/admin_view_up_events.dart';
import 'package:flutter_mla_app/user/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddUpcomingEvent extends StatefulWidget {
  @override
  State<AddUpcomingEvent> createState() => _AddUpcomingEventState();
}

class _AddUpcomingEventState extends State<AddUpcomingEvent> {
  bool isLoading=false;
  FirebaseStorage storage = FirebaseStorage.instance;
  PlatformFile? file;
  UserModel loggedInUser = UserModel();
  DateTime selectedDate = DateTime.now();
  String eventName="";
  String fileName="";
  String fileextension="";
  String date="";
  File? fileForFirebase;
  Future<void> getFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
          withReadStream: true,
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: [
            'jpg',
            'jpeg',
            'png',
            'pdf',
            'docx',
            'doc'
          ]);
      Fluttertoast.showToast(msg: "File Picked, you can select Date now !");
      if (result == null) return;
      file = result.files.first;
      fileForFirebase = File(file!.path.toString());
      int idx = file!.name.toString().lastIndexOf(".");
      fileName = file!.name.substring(0, idx).trim();
      fileextension = file!.path!.split(".").last.toLowerCase();
      print("File Name is $fileName");
      print("File Extension is $fileextension");
      final now = new DateTime.now();
      String formatter = now.toString();
      idx = formatter.indexOf(" ");
      String newdate =
      formatter.substring(0, idx).split('-').reversed.join("/");
      print("File is $fileName");

    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }
  uploadEvents(File fileForFirebase,String fileName,String fileextension) async {
    Fluttertoast.showToast(msg: "Uploading...");
    try {
      // Uploading the selected image with some custom meta data
      await storage
          .ref()
          .child("admin")
          .child("/upcomingevents")
          .child("/$fileName")
          .putFile(
        fileForFirebase,
        SettableMetadata(
          customMetadata: {
            'file_name': '$fileName',
            'date': '$date',
            'extension': '$fileextension'
          },
        ),
      );
      Fluttertoast.showToast(msg: "Event Scheduled !");
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }
  getDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),

    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        date="Date - ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
      });
    print(date);
  }

  Future<void> displayTextInputDialog(BuildContext context) async {
    final dialogController= TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.black, width: 1.5)),
            title: Text("What's the Event Name?"),
            content: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 60,
                color: Colors.grey.shade300,
                child: TextFormField(
                  cursorColor: Colors.black,
                  controller: dialogController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade200,
                      ),
                    ),

                    hintText: "Enter Here",
                    labelStyle: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              OutlinedButton(
                onPressed: () {
                  eventName=dialogController.text;
                  Navigator.of(context, rootNavigator: true).pop();
                },
                style: ButtonStyle(
                  side:
                  MaterialStateProperty.all(BorderSide(color: Colors.black)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed: (){
          Navigator.of(context).pop();
          },
        ),
        backgroundColor: Color.fromARGB(255, 250, 202, 23),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                ),
                Text("Add Event Details",
                  style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 21
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
                        getFile();
                        },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Color.fromARGB(255, 250, 202, 23),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                CupertinoIcons.photo_fill_on_rectangle_fill,
                                color: Colors.black,
                                size: 35,
                              ),
                              Text(
                                "Pick a File",
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
                        getDate(context);
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
                                size: 35,
                              ),
                              Text(
                                "Select Date",
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
                        displayTextInputDialog(context);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Color.fromARGB(255, 250, 202, 23),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                CupertinoIcons.pencil_ellipsis_rectangle,
                                color: Colors.black,
                                size: 35,
                              ),
                              Text(
                                "Add Event Name ",
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
                            builder: (context) => ViewUpcomingEvents(),
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
                                CupertinoIcons.eye,
                                color: Colors.black,
                                size: 30,
                              ),
                              Text(
                                "View\nUpcoming\nEvents",
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

                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 220,
                  height: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 250, 202, 23),
                          enableFeedback: true,
                        ),
                        onPressed: () {
                          setState(() {
                            isLoading=true;
                          });
                          uploadEvents(fileForFirebase!, eventName, fileextension);
                          Future.delayed(
                            Duration(milliseconds: 2000),
                                () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddUpcomingEvent(),
                                ),
                              );
                            },
                          );
                        },
                        label: Text(
                          "Schedule Event",
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 17),
                        ),
                        icon: (isLoading)
                            ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 1.5,
                            ))
                            : Icon(
                          CupertinoIcons.checkmark_alt,
                          color: Colors.black,
                          size: 32,
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
