import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  final String eventName;
  EventPage(this.eventName);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  var theEventData;

  void getEventData() async {
    await Firestore.instance
        .collection("Events")
        .document(widget.eventName)
        .get()
        .then((doc) {
      print(doc.data);
      setState(() {
        theEventData = doc.data;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getEventData();
  }

  @override
  Widget build(BuildContext context) {
    return theEventData != null
        ? Scaffold(
            appBar: AppBar(
              title: theEventData['name'],
              leading: FlatButton(
                child: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            bottomNavigationBar: Container(
                padding: EdgeInsets.all(8.0),
                child: RaisedButton(
                    color: Colors.redAccent,
                    onPressed: () {},
                    child: Text("Buy Tickets"))),
            body: Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  child: Container(
                    height: 300,
                    child: Image.network(
                      'https://picsum.photos/250?image=319',
                    ),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        size: 30,
                      ),
                      Text(
                        theEventData['address'],
                        style: TextStyle(fontSize: 20),
                      )
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.map,
                        size: 30,
                      ),
                      Text(theEventData['Date'], style: TextStyle(fontSize: 20))
                    ]),
                Text(theEventData['description']),
              ],
            )))
        : Scaffold(
            body: Container(
            child: Text("Loading..."),
            alignment: Alignment.center,
          ));
  }
}
