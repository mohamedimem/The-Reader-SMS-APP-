import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:proxyapp/firebase_options.dart';

final FlutterSecureStorage secureStorage = FlutterSecureStorage();

Future<String?> getUid() async {
  var x = await secureStorage.read(key: 'uid');
  print("this is our $x");
  return await secureStorage.read(key: 'uid');
}

final db = FirebaseFirestore.instance;

class MockServices {
  createData(
    Map<String, dynamic> phoneInformations,
  ) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final uid = await getUid();
    RealtimeDatabase.write(userID: uid, data: phoneInformations);
  }

  Future<Map<String, dynamic>> readData() async {
    final uid = await getUid();

    Map<String, dynamic> ff = await RealtimeDatabase.read(userID: uid);
    return ff;
  }
}

class RealtimeDatabase {
  static void write({
    required String? userID,
    required Map<String, dynamic> data,
  }) async {
    try {
      final uid = await getUid();

      // Get the existing list of phone information
      final DocumentSnapshot snapshot =
          await db.collection("users").doc(uid).get();
      // find where ihave id and email and add phone informationList to it
      if (snapshot.exists) {
        db.collection("users").doc(uid).update({
          "phoneInformationsList": FieldValue.arrayUnion([data])
        });
      } else {
        List<Map<String, dynamic>> phoneInformationList = [data];
        // Document doesn't exist, create a new one with the initial map
        await db.collection("users").doc(uid).set({
          "phoneInformationsList": phoneInformationList,
        });
      }
    } catch (e) {
      print("Error adding phone information: $e");
    }
  }

  static Future<Map<String, dynamic>> read({required String? userID}) async {
    try {
      DocumentReference _documentReference =
          FirebaseFirestore.instance.collection('users').doc('$userID');
      final snapshot = await _documentReference.get();
      print('--------------------------------');
      print(snapshot.data());
      print('--------------------------------');
      if (snapshot.exists) {
        Map<String, dynamic> _snapshotValue =
            Map<String, dynamic>.from(snapshot.data() as Map);
        return _snapshotValue;
      } else {
        return {};
      }
    } catch (e) {
      rethrow;
    }
  }
}
