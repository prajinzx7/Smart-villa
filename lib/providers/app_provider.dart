import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/device_service.dart';
import '../services/scene_service.dart';

class AppProvider extends ChangeNotifier {

  bool _isLoggedIn = false;
  final DeviceService _deviceService = DeviceService();
  final SceneService _sceneService = SceneService();

  late Map<String, bool> _deviceStates;
  String? _activeScene;

  Map<String, bool> get deviceStates => _deviceStates;

  bool get isLoggedIn => _isLoggedIn;

  AppProvider() {
    print("APP PROVIDER CREATED");
    _loadLoginState();

    _deviceStates = {
      for (var device in _deviceService.getDevices())
        device.id: false,
    };
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

  void toggleDevice(String deviceId, bool value) {
    _deviceStates[deviceId] = value;
    notifyListeners();
  }
  void turnOffRoom(String roomId) {
    final devices = _deviceService.getDevices()
        .where((d) => d.roomId == roomId);

    for (var device in devices) {
      _deviceStates[device.id] = false;
    }

    notifyListeners();
  }
  void turnOnRoom(String roomId) {
    final devices = _deviceService.getDevices()
        .where((d) => d.roomId == roomId);

    for (var device in devices) {
      _deviceStates[device.id] = true;
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
}