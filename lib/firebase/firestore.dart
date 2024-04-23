import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add data to collection
  static Future addData(String collection, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).add(data);
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Get data from collection
  static Future getData(String collection) async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(collection).get();
      List<Map<String, dynamic>> data = [];
      querySnapshot.docs.forEach((element) {
        data.add(element.data() as Map<String, dynamic>);
      });
      return data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Update data in collection
  static Future updateData(
      String collection, String docId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(docId).update(data);
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Delete data from collection
  static Future deleteData(String collection, String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
