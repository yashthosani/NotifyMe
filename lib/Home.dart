import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notifyme/EventPage.dart';
import 'package:notifyme/Models/Event.dart';
import 'Services/DataBaseService.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  static int i = 0;
  bool showNotification = false;
  String eventName;
  void showEventPage(String eventName) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return EventPage(eventName);
    }));
  }

  @override
  void initState() {
    super.initState();

    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      print("onmessage");
      print(message);

      if (i % 2 == 0) {
        setState(() {
          showNotification = true;
          eventName =message['data']['data'];
        });
        
      }
      i++;
    }, onResume: (Map<String, dynamic> message) async {
      print(message);
      print("onresume");
      if (i % 2 == 0) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return EventPage(message['data']['data']);
        }));
      }
      i++;
    }, onLaunch: (Map<String, dynamic> message) async {
      print(message);
      print("onLaunch");
      if (i % 2 == 0) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return EventPage(message['data']['data']);
        }));
      }
      i++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseService db = DatabaseService();
    return Scaffold(
      appBar: AppBar(
        title: Text("Events in Town"),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      DatabaseService db_service = DatabaseService();
                      return Container(
                        child: AddEventForm(db_service: db_service),
                      );
                    });
              },
              icon: Icon(Icons.add),
              label: Text("Add a Event"))
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(alignment: Alignment.topCenter, child: ListOfEvents()),
          showNotification
              ? Container(
                  color: Colors.blue,
                  alignment: Alignment.center,

                  height: 100,
                  width: 400,

                  child: Column(
                    children: <Widget>[
                      
                      Text("New Event Added"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton(
                              onPressed: () {
                                setState(() {
                                  showNotification = false;
                                });
                              },
                              child: Text("Ignore")),
                          FlatButton(
                              onPressed: () {
                                setState(() {
                                  showNotification = false;
                                });
                                showEventPage(eventName);
                              },
                              child: Text("Show"))
                        ],
                      )
                    ],
                  ),
                )
              : SizedBox(height: 0, width: 0),
        ],
      ),
    );
  }
}

class ListOfEvents extends StatelessWidget {
  const ListOfEvents({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseService().getEvents(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        List<Event> dat = snapshot.data;
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  enabled: true,
                  subtitle: Text(dat[index].address.toString()),
                  title: Text(dat[index].name.toString()),
                  trailing: Text(dat[index].date.toString()),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return EventPage(dat[index].name);
                    }));
                  },
                ),
              );
            },
          );
        } else {
          return Text("No Events");
        }
      },
    );
  }
}

class AddEventForm extends StatefulWidget {
  const AddEventForm({
    Key key,
    @required this.db_service,
  }) : super(key: key);

  final DatabaseService db_service;

  @override
  _AddEventFormState createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  String name;
  String date = "Select Date";
  String address;
  String description;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Form(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(hintText: "Name"),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
          RaisedButton.icon(
              onPressed: () async {
                DateTime selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2021),
                  builder: (BuildContext context, Widget child) {
                    return Theme(
                      data: ThemeData.light(),
                      child: child,
                    );
                  },
                );

                setState(() {
                  date = selectedDate.day.toString() +
                      "/" +
                      selectedDate.month.toString() +
                      "/" +
                      selectedDate.year.toString();
                });
              },
              icon: Icon(Icons.calendar_today),
              label: Text(date)),
          TextFormField(
              decoration: InputDecoration(hintText: "Address"),
              onChanged: (val) {
                setState(() {
                  address = val;
                });
              }),
          TextFormField(
              decoration: InputDecoration(hintText: "Description"),
              onChanged: (val) {
                setState(() {
                  description = val;
                });
              }),
          FlatButton(
              child: Text("Create Event"),
              onPressed: () {
                widget.db_service.createEvent(name, date, address, description);

                Navigator.pop(context);
              }),
        ],
      )),
    );
  }
}
