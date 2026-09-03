import 'package:firebase_database/firebase_database.dart';


class FirebaseSetupService {

  final DatabaseReference _db = FirebaseDatabase.instanceFor(
    app: FirebaseDatabase.instance.app,
    databaseURL:
    "https://smart-villa-prime-default-rtdb.asia-southeast1.firebasedatabase.app",
  ).ref().child("devices");


  Future<void> createInitialDevices() async {

    print("===== CREATE DEVICES START =====");

    try {

      await _db.set({

        "1": {
          "name": "Light",
          "type": "light",
          "roomId": "1",
          "state": false,
          "espId": "ESP32_001",
        },

        "2": {
          "name": "Fan",
          "type": "fan",
          "roomId": "1",
          "state": false,
          "espId": "ESP32_001",
        },

        "3": {
          "name": "AC",
          "type": "ac",
          "roomId": "1",
          "state": false,
          "espId": "ESP32_001",
        },

        "4": {
          "name": "Light",
          "type": "light",
          "roomId": "2",
          "state": false,
          "espId": "ESP32_001",
        },

        "5": {
          "name": "Fan",
          "type": "fan",
          "roomId": "2",
          "state": false,
          "espId": "ESP32_001",
        },

        "6": {
          "name": "AC",
          "type": "ac",
          "roomId": "2",
          "state": false,
          "espId": "ESP32_001",
        },

        "7": {
          "name": "Light",
          "type": "light",
          "roomId": "3",
          "state": false,
          "espId": "ESP32_001",
        },

      });

      print("===== FIREBASE WRITE SUCCESS =====");

    } catch(e) {

      print("Firebase setup error: $e");

    }
  }

}