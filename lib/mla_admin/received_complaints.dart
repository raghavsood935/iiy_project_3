import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceivedComplaints extends StatefulWidget {
  @override
  State<ReceivedComplaints> createState() => _ReceivedComplaintsState();
}

class _ReceivedComplaintsState extends State<ReceivedComplaints> {
  FirebaseStorage storage = FirebaseStorage.instance;
  bool resolved = false;
  var status;
  Future<List<Map<String, dynamic>>>? future;
  bool isLoading = false;
  String search = "";
  final searchController = TextEditingController();
  Icon closeIcon = new Icon(Icons.close);
  Icon searchIcon = new Icon(
    CupertinoIcons.search,
    size: 25,
  );
  // ignore: unnecessary_new
  Widget appBarTitle = new Text(
    "Received Complaints",
    style: TextStyle(fontSize: 20, color: Colors.black),
  );

  @override
  void initState() {
    super.initState();
    future = _loadEvents();
    getStatus();
  }

  getStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    status = preferences.getString("updated").toString();
  }

  AlertBox() {
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.black, width: 1.5)),
      title: Text(
        "Are You Sure?",
        style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.bodyText1, fontSize: 22),
      ),
      content: Text(
        "Mark this complaint as RESOLVED ?",
        style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.bodyText1, fontSize: 15),
      ),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop();
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.setString("updated", "res");
            setState(() {
              resolved = true;
            });
          },
          style: ButtonStyle(
            side: MaterialStateProperty.all(BorderSide(color: Colors.black54)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
          ),
          child: Text(
            "YES",
            style: TextStyle(color: Colors.black),
          ),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          style: ButtonStyle(
            side: MaterialStateProperty.all(BorderSide(color: Colors.black)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0))),
          ),
          child: Text(
            "NO",
            style: TextStyle(color: Colors.black),
          ),
        )
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
        title: appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: searchIcon,
            onPressed: () {
              setState(() {
                if (searchIcon.icon == CupertinoIcons.search) {
                  searchIcon = Icon(
                    Icons.close,
                    size: 25,
                  );
                  appBarTitle = SizedBox(
                    height: 50,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          search = value;
                        });
                      },
                      controller: searchController,
                      cursorColor: Colors.black,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        prefixIcon: Icon(
                          CupertinoIcons.search,
                          color: Colors.black,
                        ),
                        hintText: "SEARCH BY NAME",
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  );
                } else {
                  searchIcon = Icon(CupertinoIcons.search);
                  appBarTitle = Text(
                    "Received Complaints",
                    style: TextStyle(
                      fontSize: 21,
                      color: Colors.black,
                    ),
                  );
                }
              });
            },
          ),
        ],
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
                        return image["name"]
                                .toString()
                                .toLowerCase()
                                .contains(search.toLowerCase())
                            ? InkWell(
                                onTap: () {
                                  ext == 'jpg' || ext == 'png'
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => OpenImage(
                                                    pathImage: image['url'],
                                                  )))
                                      : PdftronFlutter.openDocument(
                                          image["url"]);
                                },
                                child: SizedBox(
                                  height: 280,

                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: IntrinsicHeight(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
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
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "DATE  - ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontFamily: GoogleFonts.lato()
                                                      .fontFamily),
                                            ),
                                            Text(
                                              " ${image["date"]}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        Divider(
                                          thickness: 1,
                                          indent: 5,
                                          endIndent: 5,
                                          color: Colors.black,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            IntrinsicHeight(
                                              child: Row(
                                                children: [
                                                  Column(children: [
                                                    Image.network(
                                                      image['url'],
                                                      height: 110,
                                                      width: 120,
                                                    ),
                                                    Text(
                                                      "TAP TO VIEW",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          text: "MOBILE NO : ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  GoogleFonts
                                                                          .lato()
                                                                      .fontFamily,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text:
                                                                    " ${image['mobile']}",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontFamily: GoogleFonts
                                                                          .lato()
                                                                      .fontFamily,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
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
                                                          text:
                                                              "WARD NUMBER : ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  GoogleFonts
                                                                          .lato()
                                                                      .fontFamily,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text:
                                                                    " ${image['ward']}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontFamily:
                                                                        GoogleFonts.lato()
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
                                                                GoogleFonts
                                                                        .lato()
                                                                    .fontFamily,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 5,
                                                                bottom: 0),
                                                        child: Container(
                                                          height: 65,
                                                          width: 180,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    right: 5,
                                                                    top: 5),
                                                            child: Text(
                                                              "${image['complaint']}",
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontFamily: GoogleFonts
                                                                          .lato()
                                                                      .fontFamily),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        resolved == false
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  ElevatedButton.icon(
                                                    onPressed: () {
                                                      AlertBox();
                                                    },
                                                    label: Text(
                                                      "RESOLVED",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14),
                                                    ),
                                                    icon: Icon(CupertinoIcons
                                                        .checkmark_alt),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Color
                                                                  .fromARGB(
                                                                      255,
                                                                      250,
                                                                      202,
                                                                      23)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  ElevatedButton.icon(
                                                    onPressed: () {},
                                                    label: Text(
                                                      "NOT RESOLVED",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14),
                                                    ),
                                                    icon: Icon(
                                                        CupertinoIcons.clear),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Color
                                                                  .fromARGB(
                                                                      255,
                                                                      250,
                                                                      202,
                                                                      23)),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  ElevatedButton.icon(
                                                    onPressed: () async {
                                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                                      prefs.remove("updated");
                                                      setState(() {
                                                        resolved = false;
                                                      });
                                                    },
                                                    label: Text(
                                                      "MARKED RESOLVED",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    icon: Icon(CupertinoIcons
                                                        .checkmark_alt),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container();
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
