import 'package:firebase_database/firebase_database.dart';

class FirebaseService {

  final DatabaseReference _db =
  FirebaseDatabase.instanceFor(
    app: FirebaseDatabase.instance.app,
    databaseURL:
    "https://smart-villa-prime-default-rtdb.asia-southeast1.firebasedatabase.app",
  ).ref();


  Future<void> setDeviceState(
      String deviceId,
      bool state,
      ) async {

    try {

      print("Sending to Firebase: $deviceId = $state");
      print(">>> SET DEVICE STATE CALLED: id=$deviceId state=$state");
      print(StackTrace.current);

      await _db
          .child("devices")
          .child(deviceId)
          .update({
        "state": state,
      });

      print("Firebase write completed");

    } catch (e) {

      print("Firebase ERROR: $e");

    }
  }


  Future<bool?> getDeviceState(
      String deviceId,
      ) async {

    final snapshot =
    await _db
        .child("devices")
        .child(deviceId)
        .child("state")
        .get();

    return snapshot.value as bool?;
  }


  Stream<DatabaseEvent> listenDeviceState(
      String deviceId,
      ) {

    return _db
        .child("devices")
        .child(deviceId)
        .child("state")
        .onValue;
  }

}