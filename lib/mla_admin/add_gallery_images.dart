import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mla_app/user/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'admin_view_gallery_images.dart';

class AddGalleryImages extends StatefulWidget {
  @override
  State<AddGalleryImages> createState() => _AddGalleryImagesState();
}

class _AddGalleryImagesState extends State<AddGalleryImages> {
  FirebaseStorage storage = FirebaseStorage.instance;
  UserModel loggedInUser = UserModel();
  String imageName="";
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
          ]);
      Fluttertoast.showToast(msg: "Image Picked, you can Enter Name now !");
      if (result == null) return;
      final file = result.files.first;
      fileForFirebase = File(file.path.toString());
      Future.delayed(const Duration(milliseconds: 1000), () {
        displayTextInputDialog(context);
      });
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
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
            title: Text("What's the Image Name ?"),
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
                onPressed: () async {
                  imageName=dialogController.text;
                  Navigator.of(context, rootNavigator: true).pop();
                  Fluttertoast.showToast(msg: "Please Wait");
                  try {
                    // Uploading the selected image with some custom meta data
                    await storage
                        .ref()
                        .child("admin")
                        .child("/galleryimages")
                        .child("/$imageName")
                        .putFile(
                      fileForFirebase!,
                      SettableMetadata(
                        customMetadata: {
                          'file_name': '$imageName',
                        },
                      ),
                    );
                    Fluttertoast.showToast(msg: "Successfully Added To Gallery");
                  } on FirebaseException catch (error) {
                    if (kDebugMode) {
                      print(error);
                    }
                  }
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
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed: (){
          Navigator.of(context).pop();
        },),
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
                  height: 150,
                ),
                Text("ADD IMAGES",
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
                                CupertinoIcons.arrow_up,
                                color: Colors.black,
                                size: 35,
                              ),
                              Text(
                                "Upload an Image",
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
                            builder: (context) => ViewGalleryImages(),
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
                                size: 35,
                              ),
                              Text(
                                "View\nGallery\nImages",
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
