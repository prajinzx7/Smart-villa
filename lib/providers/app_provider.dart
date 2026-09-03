import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/device_service.dart';
import '../services/scene_service.dart';
import '../services/firebase_service.dart';

class AppProvider extends ChangeNotifier {

  bool _isLoggedIn = false;
  final DeviceService _deviceService = DeviceService();
  final SceneService _sceneService = SceneService();
  final FirebaseService firebaseService = FirebaseService();

  late Map<String, bool> _deviceStates;
  String? _activeScene;

  Map<String, bool> get deviceStates => _deviceStates;

  bool get isLoggedIn => _isLoggedIn;
  Future<void> _loadDeviceStates() async {
    for (var device in _deviceService.getDevices()) {
      final state = await firebaseService.getDeviceState(device.id);

      print("STARTUP STATE: ${device.id} = $state");

      if (state != null) {
        _deviceStates[device.id] = state;
      }
    }

    notifyListeners();
  }

  AppProvider() {
    print("APP PROVIDER CREATED");

    _loadLoginState();

    _deviceStates = {
      for (var device in _deviceService.getDevices())
        device.id: false,
    };

    _loadDeviceStates();

    for (var device in _deviceService.getDevices()) {
      listenDevice(device.id);
    }
  }

  void _loadLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  void login() async {
    _isLoggedIn = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    notifyListeners();
  }

  void logout() async {
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    notifyListeners();
  }
  bool getDeviceState(String deviceId) {
    return _deviceStates[deviceId] ?? false;
  }

  Future<void> toggleDevice(
      String id,
      bool value,
      ) async {

    deviceStates[id] = value;

    notifyListeners();

    await firebaseService.setDeviceState(
      id,
      value,
    );
  }
  Future<void> turnOffRoom(String roomId) async {
    final devices = _deviceService
        .getDevices()
        .where((d) => d.roomId == roomId)
        .toList();

    for (var device in devices) {
      _deviceStates[device.id] = false;

      await firebaseService.setDeviceState(
        device.id,
        false,
      );
    }

    notifyListeners();
  }
  Future<void> turnOnRoom(String roomId) async {
    final devices = _deviceService
        .getDevices()
        .where((d) => d.roomId == roomId)
        .toList();

    for (var device in devices) {
      _deviceStates[device.id] = true;

      await firebaseService.setDeviceState(
        device.id,
        true,
      );
    }

    notifyListeners();
  }

  Future<void> runSavedScene(String sceneName) async {

    await _sceneService.runScene(
      sceneName,
      _deviceStates,
    );

    notifyListeners();
  }
  void listenDevice(String id) {
    print("Listening device: $id");

    firebaseService
        .listenDeviceState(id)
        .listen((event) {

      final value = event.snapshot.value;

      if (value != null) {

        deviceStates[id] = value as bool;

        notifyListeners();

      }

    });

  }
}