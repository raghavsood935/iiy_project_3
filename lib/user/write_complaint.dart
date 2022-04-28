import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_mla_app/user/homepage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

class WriteComplaint extends StatefulWidget {
  @override
  State<WriteComplaint> createState() => _WriteComplaintState();
}

class _WriteComplaintState extends State<WriteComplaint> {
  String? dropDownValue;
  bool isLoading = false;
  bool a = false;
  String newdate = "";
  String complaint = "";
  String fileName = "";
  String ward = "";
  String name = "";
  String mobile = "";
  String fileextension = "";
  bool filePicked = false;
  var pickedFile;
  var imageFile;
  final complaintController = TextEditingController();
  final wardController = TextEditingController();
  final numberController = TextEditingController();
  final nameController = TextEditingController();
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> getFile() async {
    final result = await FilePicker.platform.pickFiles(
        withReadStream: true,
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
          'pdf',
        ]);
    if (result == null) return;
    final file = result.files.first;
    pickedFile = File(
      file.path.toString(),
    );
    filePicked = true;
    fileextension = file.path!.split(".").last.toLowerCase();
    int idx = file.name.toString().lastIndexOf(".");
    fileName = file.name.substring(0, idx).trim();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Add New Complaint",
          style: TextStyle(
              color: Colors.black,
              fontSize: 21,
              fontFamily: GoogleFonts.poppins().fontFamily),
        ),
        backgroundColor: Color.fromARGB(255, 250, 202, 23),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 5,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Text(
                  "Write Your Complaint",
                  style: TextStyle(fontSize: 19),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: TextField(
                      controller: complaintController,
                      minLines: 4,
                      maxLines: 4,
                      maxLength: 300,
                      cursorColor: Colors.black,
                      decoration: InputDecoration.collapsed(
                        hintText: "Type Here",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  height: 130,
                  width: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Text(
                  "Add Attachment",
                  style: TextStyle(fontSize: 19),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: pickedFile != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                              Icon(
                                Icons.check,
                                size: 35,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "File Picked !",
                                style:
                                    TextStyle(fontSize: 21, color: Colors.blue),
                              )
                            ])
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Pick A File ?",
                              style:
                                  TextStyle(fontSize: 21, color: Colors.blue),
                            ),
                          ],
                        )),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 140,
                  vertical: 10,
                ),
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 250, 202, 23),
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.black),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      getFile();
                    },
                    child: Text(
                      "PICK",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Text(
                  "Enter Your Ward Number",
                  style: TextStyle(fontSize: 19),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: 13, left: 10, right: 10),
                    child: TextField(
                      controller: wardController,
                      minLines: 1,
                      maxLines: 1,
                      cursorColor: Colors.black,
                      decoration: InputDecoration.collapsed(
                        hintText: "Type Here",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  height: 60,
                  width: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Text(
                  "Enter Your Name",
                  style: TextStyle(fontSize: 19),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: 13, left: 10, right: 10),
                    child: TextField(
                      controller: nameController,
                      minLines: 1,
                      maxLines: 1,
                      cursorColor: Colors.black,
                      decoration: InputDecoration.collapsed(
                        hintText: "Type Here",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  height: 60,
                  width: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Text(
                  "Enter Your Mobile Number",
                  style: TextStyle(fontSize: 19),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: 13, left: 10, right: 10),
                    child: TextField(
                      controller: numberController,
                      minLines: 1,
                      maxLines: 1,
                      cursorColor: Colors.black,
                      decoration: InputDecoration.collapsed(
                        hintText: "Type Here",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  height: 60,
                  width: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 110, vertical: 20),
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
                              )))
                      : MaterialButton(
                          onPressed: () async {
                            setState(() {
                              final now = DateTime.now();
                              String formatter = now.toString();
                              int idx = formatter.indexOf(" ");
                              newdate = formatter
                                  .substring(0, idx)
                                  .split('-')
                                  .reversed
                                  .join("/");
                              isLoading = true;
                              ward = wardController.text;
                              name = nameController.text;
                              mobile = numberController.text;
                              complaint = complaintController.text;
                            });
                            try {
                              // Uploading the selected image with some custom meta data
                              await storage
                                  .ref()
                                  .child("user")
                                  .child("/complaints")
                                  .child("/$fileName")
                                  .putFile(
                                    pickedFile,
                                    SettableMetadata(
                                      customMetadata: {
                                        'file_name': '$fileName',
                                        'date': '$newdate',
                                        'complaint': "$complaint",
                                        'ward': "$ward",
                                        'name': "$name",
                                        'mobile': "$mobile",
                                        'extension': "$fileextension"
                                      },
                                    ),
                                  );
                              setState(() {});
                            } on FirebaseException catch (error) {
                              if (kDebugMode) {
                                print(error);
                              }
                            }
                            Future.delayed(Duration(milliseconds: 1000), () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Homepage(),
                                ),
                              );
                              Fluttertoast.showToast(
                                msg: "Complaint Has Been Registered !",
                              );
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'SUBMIT',
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
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
    );
  }
}
