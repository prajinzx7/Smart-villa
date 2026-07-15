import 'package:flutter/material.dart';
import '../../services/room_service.dart';
import '../../services/device_service.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../services/scene_service.dart';
import '../../models/scene_model.dart';

class SmartDashboardScreen extends StatefulWidget {
  const SmartDashboardScreen({super.key});

  @override
  State<SmartDashboardScreen> createState() =>
      _SmartDashboardScreenState();
}

class _SmartDashboardScreenState
    extends State<SmartDashboardScreen> {
  final SceneService sceneService = SceneService();

  List<SceneModel> scenes = [];

  final roomService = RoomService();
  final deviceService = DeviceService();

  int getDeviceCount(String roomId) {
    return deviceService
        .getDevices()
        .where((d) => d.roomId == roomId)
        .length;
  }

  int getOnCount(String roomId, AppProvider app) {
    return deviceService
        .getDevices()
        .where((d) => d.roomId == roomId && app.getDeviceState(d.id))
        .length;
  }

  int getOffCount(String roomId, AppProvider app) {
    return getDeviceCount(roomId) - getOnCount(roomId, app);
  }
  Future<void> loadScenes() async {
    scenes = await sceneService.getScenes();

    if (mounted) {
      setState(() {});
    }
  }
  @override
  void initState() {
    super.initState();
    loadScenes();
  }

  @override
  Widget build(BuildContext context) {
    final rooms = roomService.getRooms();
    final app = Provider.of<AppProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Dashboard"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: scenes.length,
                itemBuilder: (context, index) {
                  final scene = scenes[index];

                  IconData icon;

                  switch (scene.name) {
                    case "Good Morning":
                      icon = Icons.wb_sunny;
                      break;

                    case "Good Night":
                      icon = Icons.nightlight_round;
                      break;

                    case "Away":
                      icon = Icons.home;
                      break;

                    case "Movie Night":
                      icon = Icons.movie;
                      break;

                    default:
                      icon = Icons.auto_mode;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ElevatedButton(
                      child: Text("${scene.emoji} ${scene.name}"),
                      onPressed: () async {
                        await app.runSavedScene(scene.name);
                      },
                      onLongPress: () {
                        Navigator.pushNamed(
                          context,
                          '/scene-editor',
                          arguments: scene,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.auto_mode),
                label: const Text("Manage Scenes"),
                onPressed: () async {
                  await Navigator.pushNamed(
                    context,
                    '/scenes',
                  );

                  await loadScenes();
                },
              ),
            ),
          ),
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),

              leading: const CircleAvatar(
                radius: 28,
                child: Icon(Icons.schedule),
              ),

              title: const Text(
                "Automation",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: const Text(
                "Create automatic scenes",
              ),

              trailing: const Icon(
                Icons.arrow_forward_ios,
              ),

              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/automation',
                );
              },
            ),
          ),

          Expanded(
            child: Consumer<AppProvider>(
              builder: (context, app, child) {
                return ListView.builder(
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          radius: 28,
                          child: Icon(
                            room.name == "Living Room"
                                ? Icons.weekend
                                : room.name == "Bedroom"
                                ? Icons.bed
                                : Icons.kitchen,
                          ),
                        ),
                        title: Text(
                          room.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            "${getDeviceCount(room.id)} devices\n"
                                "🟢 ON: ${getOnCount(room.id, app)}   ⚪ OFF: ${getOffCount(room.id, app)}",
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/devices',
                            arguments: room.id,
                          );
                        },
                      ),
                    );

                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}