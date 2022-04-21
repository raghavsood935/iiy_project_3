import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        backgroundColor: Color.fromARGB(255, 250, 202, 23),
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
          child: Container(
        child: Text(
          "No New Notifications",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      )),
    );
  }
}
