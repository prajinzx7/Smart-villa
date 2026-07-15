import 'package:flutter/material.dart';
import '../../services/scene_service.dart';
import '../../models/scene_model.dart';

class ScenesScreen extends StatefulWidget {
  const ScenesScreen({super.key});

  @override
  State<ScenesScreen> createState() => _ScenesScreenState();
}

class _ScenesScreenState extends State<ScenesScreen> {


  final SceneService sceneService = SceneService();

  List<SceneModel> scenes = [];
  final TextEditingController sceneController =
  TextEditingController();

  final TextEditingController renameController =
  TextEditingController();

  Future<void> renameSceneDialog(String oldName) async {
    renameController.text = oldName;

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Rename Scene"),

          content: TextField(
            controller: renameController,
            decoration: const InputDecoration(
              hintText: "Scene Name",
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {

                final newName =
                renameController.text.trim();

                if (newName.isEmpty) return;

                await sceneService.renameScene(
                  oldName,
                  newName,
                );

                await loadScenes();

                if (!mounted) return;

                Navigator.pop(context);

              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void showSceneOptions(String scene) {
    final isDefaultScene =
        scene == "Good Morning" ||
            scene == "Good Night" ||
            scene == "Away";

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("Edit Scene"),
                onTap: () async {
                  Navigator.pop(context);

                  await Navigator.pushNamed(
                    context,
                    '/scene-editor',
                    arguments: scene,
                  );

                  await loadScenes();
                },
              ),

              ListTile(
                leading: const Icon(Icons.drive_file_rename_outline),
                title: const Text("Rename Scene"),
                onTap: () async {
                  Navigator.pop(context);

                  await renameSceneDialog(scene);
                },
              ),

              if (!isDefaultScene)
                ListTile(
                  leading: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  title: const Text(
                    "Delete Scene",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    Navigator.pop(context);

                    await sceneService.deleteScene(scene);

                    await loadScenes();
                  },
                ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text("Cancel"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> createSceneDialog() async {

    sceneController.clear();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Create Scene"),

          content: TextField(
            controller: sceneController,
            decoration: const InputDecoration(
              hintText: "Scene Name",
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {

                final name = sceneController.text.trim();

                if (name.isEmpty) return;

                await sceneService.addScene(name);

                await loadScenes();

                if (!mounted) return;

                Navigator.pop(context);

              },
              child: const Text("Create"),
            ),

          ],
        );
      },
    );

  }

  @override
  void initState() {
    super.initState();
    loadScenes();
  }
  Future<void> loadScenes() async {
    scenes = await sceneService.getScenes();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scenes"),
      ),
      body: ListView.builder(
        itemCount: scenes.length,
        itemBuilder: (context, index) {
          final scene = scenes[index];

          IconData icon;

          switch (scene.icon) {
            case "sun":
              icon = Icons.wb_sunny;
              break;

            case "moon":
              icon = Icons.nightlight_round;
              break;

            case "home":
              icon = Icons.home;
              break;

            default:
              icon = Icons.auto_mode;
          }

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: ListTile(
              leading: Icon(icon),
              title: Text(scene.name),
              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: () async {
                await Navigator.pushNamed(
                  context,
                  '/scene-editor',
                  arguments: scene.name,
                );

                await loadScenes();
              },

              onLongPress: () {
                showSceneOptions(scene.name);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          createSceneDialog();
        },
      ),
    );
  }
}