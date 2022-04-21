import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewGalleryImages extends StatefulWidget {
  @override
  State<ViewGalleryImages> createState() => ViewGalleryImagesState();
}

class ViewGalleryImagesState extends State<ViewGalleryImages> {
  FirebaseStorage storage=FirebaseStorage.instance;
  Future<List<Map<String, dynamic>>>? future;
  bool isLoading=false;
  @override
  void initState() {
    super.initState();
    future=_loadEvents();
  }

  Future<List<Map<String, dynamic>>> _loadEvents() async {
    List<Map<String, dynamic>> files = [];
    final ListResult result = await storage
        .ref()
        .child("admin")
        .child("/galleryimages")
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
            "date": fileMeta.customMetadata?['date'] ?? "No date"
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
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ViewGalleryImages()));
    setState(() {});
  }

  void AlertBox(String ref) {
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
            side:
            MaterialStateProperty.all(BorderSide(color: Colors.black)),
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
            side:
            MaterialStateProperty.all(BorderSide(color: Colors.black)),
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
          "Gallery Images",
          style: TextStyle(
              color: Colors.black,
            fontFamily: GoogleFonts.poppins().fontFamily
          ),
        ),
        backgroundColor: Color.fromARGB(255, 250, 202, 23),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
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
                        "No Images As Of Now",
                        style: TextStyle(
                            fontSize: 17
                        ),
                      ),
                    )
                        :GridView.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 3 / 4,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> image =
                        snapshot.data![index];
                        String name = image["path"].toString();
                        String ext = name
                            .split(".")
                            .last
                            .toLowerCase();
                        print(ext);
                        Image img = Image.network(image["url"],fit: BoxFit.cover,);
                        return InkWell(
                            onLongPress: () async {
                              await showMenu(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                context: context,
                                position: RelativeRect.fromLTRB(300, 20, 10, 100),
                                items: [
                                  PopupMenuItem<String>(
                                    child: TextButton(
                                      child: Row(
                                          children: [
                                            Text(
                                              'DELETE',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: GoogleFonts.lato().fontFamily,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(width: 20,),
                                            Icon(CupertinoIcons.delete,color: Colors.black,),
                                          ]),
                                      style: ButtonStyle(
                                          shadowColor: MaterialStateProperty.all(Colors.white),
                                          backgroundColor: MaterialStateProperty.all(Colors.white)),
                                      onPressed: () async {
                                        await storage.ref(image["path"]).delete();
                                        Fluttertoast.showToast(
                                            msg: "File Deleted Successfully",
                                            toastLength: Toast.LENGTH_SHORT,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 15.0);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ViewGalleryImages()));
                                      },
                                    ),
                                    value: '',
                                  ),
                                ],
                                elevation: 8.0,
                              );
                          },
                          onTap: () {
                            print(image["url"]);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OpenImage(
                                      pathImage: image['url'],
                                    )
                                )
                            );
                          },
                          child: card_widget(
                                ImagePath: image['url'],
                                LabelText: image['file_name'],
                                path:image["path"]
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
            icon: Icon(Icons.arrow_back,color: Colors.black,),
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
        )
    );
  }
}

// Card Widget

class card_widget extends StatelessWidget {
  final String? LabelText;
  final String? ImagePath;
  final String? path;
  FirebaseStorage storage=FirebaseStorage.instance;
  // Function router();

  card_widget(
      {@required this.LabelText,
        @required this.ImagePath,
        @required this.path,
      });

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  ImagePath!,
                  width: 190,
                  height: 190,
                  fit: BoxFit.cover

                  ,
                ),
              ),
              SizedBox(height: 10,),
              Center(
                child: Text(
                  LabelText!,
                  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyText1,
                      color: Color(0xFF2B2B2B),
                      fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
   }
}

