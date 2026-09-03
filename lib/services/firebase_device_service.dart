import 'package:firebase_database/firebase_database.dart';
import '../models/firebase_device_model.dart';


class FirebaseDeviceService {


  final DatabaseReference _devicesRef = FirebaseDatabase.instanceFor(
    app: FirebaseDatabase.instance.app,
    databaseURL:
    "https://smart-villa-prime-default-rtdb.asia-southeast1.firebasedatabase.app",
  ).ref().child("devices");


  Future<List<FirebaseDeviceModel>> getDevices() async {
    print("Reading devices from Firebase...");

    final snapshot = await _devicesRef.get();

    print("Exists: ${snapshot.exists}");
    print("Value: ${snapshot.value}");

    if (!snapshot.exists) {
      return [];
    }

    final List data = snapshot.value as List;

    List<FirebaseDeviceModel> devices = [];

    for (int i = 1; i < data.length; i++) {
      if (data[i] != null) {
        devices.add(
          FirebaseDeviceModel.fromJson(
            i.toString(),
            Map<String, dynamic>.from(data[i]),
          ),
        );
      }
    }

    return devices;
  }


}