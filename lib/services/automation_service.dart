import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/automation_model.dart';

class AutomationService {

  Future<List<AutomationModel>> getAutomations() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString("automations");

    if (data == null) {
      return [];
    }

    final List decoded = jsonDecode(data);

    return decoded
        .map((e) => AutomationModel.fromJson(e))
        .toList();
  }


  Future<void> addAutomation(
      AutomationModel automation,
      ) async {

    final prefs = await SharedPreferences.getInstance();

    final automations = await getAutomations();

    automations.add(automation);

    await prefs.setString(
      "automations",
      jsonEncode(
        automations.map((e) => e.toJson()).toList(),
      ),
    );
  }


  Future<void> deleteAutomation(
      String id,
      ) async {

    final prefs = await SharedPreferences.getInstance();

    final automations = await getAutomations();

    automations.removeWhere(
          (automation) => automation.id == id,
    );

    await prefs.setString(
      "automations",
      jsonEncode(
        automations.map((e) => e.toJson()).toList(),
      ),
    );
  }

  Future<void> updateAutomation(
      AutomationModel updatedAutomation,
      ) async {

    final prefs = await SharedPreferences.getInstance();

    final automations = await getAutomations();

    final index = automations.indexWhere(
          (a) => a.id == updatedAutomation.id,
    );

    if (index == -1) return;

    automations[index] = updatedAutomation;

    await prefs.setString(
      "automations",
      jsonEncode(
        automations.map((e) => e.toJson()).toList(),
      ),
    );
  }
}