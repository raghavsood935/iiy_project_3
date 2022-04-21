import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Gallery extends StatefulWidget {
  @override
  State<Gallery> createState() => GalleryState();
}

class GalleryState extends State<Gallery> {
  FirebaseStorage storage = FirebaseStorage.instance;
  Future<List<Map<String, dynamic>>>? future;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    future = _loadEvents();
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gallery Images",
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
                              style: TextStyle(fontSize: 17),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 3 / 4,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final Map<String, dynamic> image =
                                  snapshot.data![index];
                              return InkWell(
                                onTap: () {
                                  print(image["url"]);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OpenImage(
                                                pathImage: image['url'],
                                              )));
                                },
                                child: card_widget(
                                    ImagePath: image['url'],
                                    LabelText: image['file_name'],
                                    path: image["path"]),
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

// Card Widget

class card_widget extends StatelessWidget {
  final String? LabelText;
  final String? ImagePath;
  final String? path;
  FirebaseStorage storage = FirebaseStorage.instance;
  // Function router();

  card_widget({
    @required this.LabelText,
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
        height: 150,
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
                width: 150,
                height: 190,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                LabelText!.toUpperCase(),
                style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyText1,
                    color: Color(0xFF2B2B2B),
                    fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
