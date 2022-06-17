import 'package:firebase_database/firebase_database.dart';

DatabaseReference dbRef = FirebaseDatabase.instance.ref();

void subscribeContacts(
    String currentUserUid, bool mounted, Function setState, List contacts) {
  dbRef.child('contacts/$currentUserUid').onValue.listen((event) async {
    List<Map> contactsListWithUserInfo = [];
    List contactsList =
        event.snapshot.exists ? event.snapshot.value as List : [];
    for (String contact in contactsList) {
      final snapshot = await dbRef.child('users/$contact').get();
      contactsListWithUserInfo.add(snapshot.value as Map);
    }
    if (mounted) {
      setState(() {
        contacts = contactsListWithUserInfo;
      });
    }
  });
}
