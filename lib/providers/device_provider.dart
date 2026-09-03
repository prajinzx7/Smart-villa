import 'package:flutter/material.dart';

import '../models/firebase_device_model.dart';
import '../services/firebase_device_service.dart';

class DeviceProvider extends ChangeNotifier {

  final FirebaseDeviceService _service = FirebaseDeviceService();

  List<FirebaseDeviceModel> _devices = [];

  List<FirebaseDeviceModel> get devices => _devices;

  bool _loading = false;

  bool get loading => _loading;

  Future<void> loadDevices() async {

    _loading = true;
    notifyListeners();

    _devices = await _service.getDevices();

    print("========== FIREBASE DEVICES ==========");

    for (final d in _devices) {
      print(
          "${d.id} | ${d.name} | ${d.type} | Room ${d.roomId} | ${d.state}"
      );
    }

    print("Total Devices: ${_devices.length}");

    _loading = false;
    notifyListeners();
  }

}