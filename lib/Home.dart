import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  @override
  void initState() {
    super.initState();

    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      print("onmessage");
      print(message);

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  content: ListTile(
                    title: Text(message['notification']['title']),
                    subtitle: Text(message['notification']['body']),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ]));
    }, onResume: (Map<String, dynamic> message) async {
      print(message);
      print("onresume");
    }, onLaunch: (Map<String, dynamic> message) async {
      print(message);
      print("onLaunch");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events in Town"),
      ),
      body: Column(
        children: <Widget>[
          // ListView.builder(itemBuilder: (context,index){

          //   return Card(child: ListTile(),);
          // })
        ],
      ),
    );
  }
}
