import 'package:flutter/material.dart';
import '../../services/device_service.dart';
import '../../services/scene_service.dart';

class SceneEditorScreen extends StatefulWidget {
  final String sceneName;

  const SceneEditorScreen({
    super.key,
    required this.sceneName,
  });

  @override
  State<SceneEditorScreen> createState() => _SceneEditorScreenState();
}

class _SceneEditorScreenState extends State<SceneEditorScreen> {

  final DeviceService deviceService = DeviceService();
  final SceneService sceneService = SceneService();

  final Map<String, bool> selectedDevices = {};
  Future<void> loadScene() async {

    final devices = deviceService.getDevices();

    // Clear all selections first
    for (var device in devices) {
      selectedDevices[device.id] = false;
    }

    final savedIds = await sceneService.loadScene(widget.sceneName);

    for (var id in savedIds) {
      selectedDevices[id] = true;
    }

    setState(() {});
  }

  String getRoomName(String roomId) {
    switch (roomId) {
      case '1':
        return 'Living Room';
      case '2':
        return 'Bedroom';
      case '3':
        return 'Kitchen';
      default:
        return 'Unknown';
    }
  }
  @override
  void initState() {
    super.initState();

    loadScene();
  }

  @override
  Widget build(BuildContext context) {
    final devices = deviceService.getDevices();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sceneName),
      ),
      body: ListView(
        children: [
          ...devices.map((device) {
            selectedDevices.putIfAbsent(device.id, () => false);

            return CheckboxListTile(
              title: Text(device.name),
              subtitle: Text(getRoomName(device.roomId)),
              value: selectedDevices[device.id],
              onChanged: (value) {
                setState(() {
                  selectedDevices[device.id] = value ?? false;
                });
              },
            );
          }),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
            onPressed: () async {

    final selectedIds = selectedDevices.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    await sceneService.saveScene(
    widget.sceneName,
    selectedIds,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
    content: Text("Scene saved successfully!"),
    ),
    );
    },
              child: const Text("SAVE"),
            ),
          ),
        ],
      ),
    );
  }
}