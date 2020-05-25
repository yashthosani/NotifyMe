import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notifyme/Models/Event.dart';

class DatabaseService {
  List<Event> maptoEventClass(QuerySnapshot snapshot) {
    return (snapshot.documents.map((aevent){
      print(aevent);
      return Event(aevent.data['Name'], aevent.data['Date'], aevent.data['address'], aevent.data['description']);

    })).toList();
  }

  Stream<List<Event>> getEvents() {
    var m =
        Firestore.instance.collection('Events').snapshots().map(maptoEventClass);
    print(m);
    return m;
  }

  Future<bool> createEvent(
      String name, String date, String address, String description) async {
    try {
      final Firestore firestoreInstance = Firestore.instance;
      CollectionReference events = firestoreInstance.collection('Events');
      await events.document(name).setData({
        'Name': name,
        'Date': date,
        'address': address,
        'description': description,
      });
      return true;
    } catch (e) {
      return (false);
    }
  }
}
