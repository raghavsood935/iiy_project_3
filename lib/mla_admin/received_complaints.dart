import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';

class ReceivedComplaints extends StatefulWidget {
  @override
  State<ReceivedComplaints> createState() => _ReceivedComplaintsState();
}

class _ReceivedComplaintsState extends State<ReceivedComplaints> {
  FirebaseStorage storage = FirebaseStorage.instance;
  Future<List<Map<String, dynamic>>>? future;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    future = _loadEvents();
    Fluttertoast.showToast(msg: "Current Complaints");
  }

  Future<List<Map<String, dynamic>>> _loadEvents() async {
    List<Map<String, dynamic>> files = [];
    final ListResult result = await storage
        .ref()
        .child("user")
        .child("/complaints")
        .child("/")
        .list();
    final List<Reference> allFiles = result.items;
    await Future.forEach<Reference>(
      allFiles,
      (file) async {
        final String fileUrl = await file.getDownloadURL();
        final FullMetadata fileMeta = await file.getMetadata();
        files.add(
          {
            "url": fileUrl,
            "path": file.fullPath,
            "file_name": fileMeta.customMetadata?['file_name'] ?? "Not Found",
            "date": fileMeta.customMetadata?['date'] ?? "No date",
            "complaint":
                fileMeta.customMetadata?['complaint'] ?? "No Complaint",
            "ward": fileMeta.customMetadata?['ward'] ?? "No Ward",
            "name": fileMeta.customMetadata?['name'] ?? "No Name",
            "mobile": fileMeta.customMetadata?['mobile'] ?? "No Mobile",
            "extension": fileMeta.customMetadata?['extension'] ?? "No Extension"
          },
        );
      },
    );
    return files;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Received Complaints",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color.fromARGB(255, 250, 202, 23),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: future,
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> image =
                            snapshot.data![index];
                        String name = image["path"].toString();
                        String ext = image["extension"];
                        return InkWell(
                          onTap: () {
                            ext == 'jpg' || ext == 'png'
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OpenImage(
                                              pathImage: image['url'],
                                            )))
                                : PdftronFlutter.openDocument(image["url"]);
                          },
                          child: SizedBox(
                            height: 200,
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 85),
                                      child: Row(
                                        children: [
                                          Text(
                                            "COMPLAINT FROM ",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "${image['name'].toString().toUpperCase()}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1,
                                      indent: 5,
                                      endIndent: 5,
                                      color: Colors.black,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(1.0),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          children: [
                                            Column(children: [
                                              Image.network(
                                                image['url'],
                                                height: 110,
                                                width: 130,
                                              ),
                                              Text(
                                                "TAP TO VIEW ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ]),
                                            VerticalDivider(
                                              color: Colors.black,
                                              thickness: 1,
                                              indent: 5,
                                              endIndent: 5,
                                            ),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    text: "MOBILE NO : ",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontFamily:
                                                            GoogleFonts.lato()
                                                                .fontFamily,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text:
                                                              " ${image['mobile']}",
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                            fontFamily:
                                                                GoogleFonts
                                                                        .lato()
                                                                    .fontFamily,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    text: "WARD NUMBER : ",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontFamily:
                                                            GoogleFonts.lato()
                                                                .fontFamily,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text:
                                                              " ${image['ward']}",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontFamily:
                                                                  GoogleFonts
                                                                          .lato()
                                                                      .fontFamily,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  "MESSAGE :  ",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily:
                                                          GoogleFonts.lato()
                                                              .fontFamily,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 5, bottom: 0),
                                                  child: Container(
                                                    height: 65,
                                                    width: 230,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10,
                                                          right: 5,
                                                          top: 5),
                                                      child: Text(
                                                        "${image['complaint']}",
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontFamily:
                                                                GoogleFonts
                                                                        .lato()
                                                                    .fontFamily),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OpenImage extends StatefulWidget {
  String pathImage = "";
  OpenImage({required this.pathImage});

  @override
  State<OpenImage> createState() => _OpenImageState(pathImage: pathImage);
}

class _OpenImageState extends State<OpenImage> {
  String pathImage = "";
  bool isLoading = false;
  _OpenImageState({required this.pathImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        //view PDF
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 250, 202, 23),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
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
        body: Center(
          child: Container(
            child: Image.network(pathImage),
            height: double.infinity,
            width: double.infinity,
          ),
        ));
  }
}
