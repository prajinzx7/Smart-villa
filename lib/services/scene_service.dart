import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scene_model.dart';

class SceneService {

  Future<List<SceneModel>> getScenes() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString("scenes");

    if (data == null) {
      final defaultScenes = [
        SceneModel(
          name: "Good Morning",
          icon: "sun",
        ),
        SceneModel(
          name: "Good Night",
          icon: "moon",
        ),
        SceneModel(
          name: "Away",
          icon: "home",
        ),
      ];

      await prefs.setString(
        "scenes",
        jsonEncode(
          defaultScenes.map((e) => e.toJson()).toList(),
        ),
      );

      return defaultScenes;
    }

    final List decoded = jsonDecode(data);

    return decoded
        .map((e) => SceneModel.fromJson(e))
        .toList();
  }


  Future<void> addScene(String sceneName) async {

    final prefs = await SharedPreferences.getInstance();

    final scenes = await getScenes();

    scenes.add(
      SceneModel(
        name: sceneName,
        icon: "home",
      ),
    );

    await prefs.setString(
      "scenes",
      jsonEncode(
        scenes.map((e) => e.toJson()).toList(),
      ),
    );
  }


  Future<void> deleteScene(String sceneName) async {

    final prefs = await SharedPreferences.getInstance();

    final scenes = await getScenes();

    scenes.removeWhere(
          (scene) => scene.name == sceneName,
    );

    await prefs.setString(
      "scenes",
      jsonEncode(
        scenes.map((e) => e.toJson()).toList(),
      ),
    );

    await prefs.remove(
      "scene_$sceneName",
    );
  }


  Future<void> renameScene(
      String oldName,
      String newName,
      ) async {

    final prefs = await SharedPreferences.getInstance();

    final scenes = await getScenes();

    final index = scenes.indexWhere(
          (scene) => scene.name == oldName,
    );

    if (index == -1) return;


    scenes[index] = SceneModel(
      name: newName,
      icon: scenes[index].icon,
    );


    await prefs.setString(
      "scenes",
      jsonEncode(
        scenes.map((e) => e.toJson()).toList(),
      ),
    );


    final data = prefs.getString(
      "scene_$oldName",
    );


    if (data != null) {

      await prefs.setString(
        "scene_$newName",
        data,
      );

      await prefs.remove(
        "scene_$oldName",
      );
    }
  }
  Future<void> saveScene(
      String sceneName,
      List<String> deviceIds,
      ) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      "scene_$sceneName",
      deviceIds,
    );
  }


  Future<List<String>> loadScene(
      String sceneName,
      ) async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(
      "scene_$sceneName",
    ) ??
        [];
  }


  Future<void> runScene(
      String sceneName,
      Map<String, bool> deviceStates,
      ) async {

    final deviceIds = await loadScene(sceneName);

    // First turn EVERY device OFF
    for (final id in deviceStates.keys) {
      deviceStates[id] = false;
    }

    // Then turn ON only the devices in this scene
    for (final id in deviceIds) {
      deviceStates[id] = true;
    }
  } // <-- closes runScene()

} // <-- closes SceneService class