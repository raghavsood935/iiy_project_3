import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';

class ViewCompletedProjects extends StatefulWidget {
  @override
  State<ViewCompletedProjects> createState() => _ViewCompletedProjectsState();
}

class _ViewCompletedProjectsState extends State<ViewCompletedProjects> {
  FirebaseStorage storage = FirebaseStorage.instance;
  Future<List<Map<String, dynamic>>>? future;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    future = _loadEvents();
  }

  Future<List<Map<String, dynamic>>> _loadEvents() async {
    List<Map<String, dynamic>> files = [];
    final ListResult result = await storage
        .ref()
        .child("admin")
        .child("/completedprojects")
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
            "extension": fileMeta.customMetadata?['extension'] ?? "No Extension"
          },
        );
      },
    );
    return files;
  }

  Future<void> _delete(String ref) async {
    await storage.ref(ref).delete();
    Fluttertoast.showToast(
        msg: "File Deleted Successfully",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 15.0);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => ViewCompletedProjects()));
    setState(() {});
  }

  AlertBox(String ref) {
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
        "This File Will Be Deleted",
        style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.bodyText1, fontSize: 15),
      ),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            _delete(ref);
          },
          style: ButtonStyle(
            side: MaterialStateProperty.all(BorderSide(color: Colors.black)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
          ),
          child: Text(
            "Yes, Delete !",
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
            "No",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Completed Projects",
          style: TextStyle(
              color: Colors.black,
              fontFamily: GoogleFonts.poppins().fontFamily),
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
                    return snapshot.data!.length == 0
                        ? Center(
                            child: Text(
                              "No Completed Projects As Of Now",
                              style: TextStyle(fontSize: 17),
                            ),
                          )
                        : ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final Map<String, dynamic> image =
                                  snapshot.data![index];
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
                                      : PdftronFlutter.openDocument(
                                          image["url"]);
                                },
                                child: SizedBox(
                                  height: 80,
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                          color: Colors.blue.shade200),
                                    ),
                                    tileColor: Colors.yellow[50],
                                    leading: image["extension"] == 'jpg' ||
                                            image["extension"] == 'jpeg' ||
                                            image["extension"] == 'png'
                                        ? Image.network(
                                            image['url'],
                                            height: 60,
                                            width: 60,
                                          )
                                        : Image.asset(
                                            "assets/images/doc.png",
                                            height: 60,
                                            width: 60,
                                          ),
                                    title: Text(image['file_name'],
                                        style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.lato().fontFamily,
                                            fontSize: 18)),
                                    subtitle: Text("Date - " + image['date'],
                                        style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.lato().fontFamily,
                                            fontSize: 15)),
                                    trailing: IconButton(
                                      onPressed: () {
                                        AlertBox(image['path']);
                                      },
                                      icon: Icon(CupertinoIcons.delete),
                                      color: Colors.black,
                                    ),
                                  ),
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
