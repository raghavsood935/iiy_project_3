import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';

class OngoingProjects extends StatefulWidget {
  @override
  State<OngoingProjects> createState() => _OngoingProjectsState();
}

class _OngoingProjectsState extends State<OngoingProjects> {
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
        .child("/ongoingevents")
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ongoing Projects",
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
        padding: EdgeInsets.all(10),
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
                              "No Ongoing Projects As Of Now",
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
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          CupertinoIcons.bolt_horizontal,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Ongoing",
                                          style: TextStyle(fontSize: 14),
                                        )
                                      ],
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
