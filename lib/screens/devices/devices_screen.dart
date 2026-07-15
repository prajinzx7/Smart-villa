import 'package:flutter/material.dart';
import '../../services/device_service.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  final service = DeviceService();


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
  @override
  Widget build(BuildContext context) {
    final roomId = ModalRoute.of(context)?.settings.arguments?.toString();
    final app = Provider.of<AppProvider>(context);

    final devices = service.getDevices()
        .where((d) => d.roomId == roomId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Devices"),
        actions: [
          IconButton(
            icon: const Icon(Icons.power_off),
            onPressed: () {
              app.turnOffRoom(roomId!);
            },
          ),
          IconButton(
            icon: const Icon(Icons.power),
            onPressed: () {
              app.turnOnRoom(roomId!);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          print("UI DEVICE: ${device.name} id=${device.id}");

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.devices),
              title: Text(device.name),
              subtitle: Text(getRoomName(device.roomId)),
              trailing: Switch(
                value: app.getDeviceState(device.id),
                onChanged: (val) {
                  print("SWITCH CHANGED: ${device.name} = $val");
                  app.toggleDevice(device.id, val);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}