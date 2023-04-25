import 'package:cloud_firestore/cloud_firestore.dart';

class Firestorehelper {
  Firestorehelper._();
  static final Firestorehelper firestorehelper = Firestorehelper._();
  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> insertrecord({required Map<String, dynamic> data}) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await firebaseFirestore.collection("Note").doc("1").get();
    Map<String, dynamic>? notecounterdata = documentSnapshot.data();

    int notecounter = notecounterdata!['notecount'];
    int length = notecounterdata['length'];
    notecounter++;
    length++;
    await firebaseFirestore.collection("Notes").doc("$notecounter").set(data);
    await firebaseFirestore
        .collection("Note")
        .doc("1")
        .update({"length": length, "notecount": notecounter});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> featchallrecord() {
    return firebaseFirestore.collection("Notes").snapshots();
  }

  Future<void> updaterecored(
      {required Map<String, dynamic> data, required String id}) async {
    await firebaseFirestore.collection('Notes').doc(id).update(data);
  }

  Future<void> deleterecored({required String id}) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await firebaseFirestore.collection('Note').doc('1').get();
    Map<String, dynamic>? notecount = documentSnapshot.data();

    int lengthcount = notecount!['length'];
    firebaseFirestore.collection("Notes").doc(id).delete();
    lengthcount--;
    await firebaseFirestore
        .collection('Note')
        .doc("1")
        .update({"length": lengthcount});
  }
}
