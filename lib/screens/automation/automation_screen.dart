import 'package:flutter/material.dart';
import '../../models/automation_model.dart';
import '../../services/automation_service.dart';


class AutomationScreen extends StatefulWidget {
  const AutomationScreen({super.key});

  @override
  State<AutomationScreen> createState() =>
      _AutomationScreenState();
}


class _AutomationScreenState
    extends State<AutomationScreen> {

  final AutomationService automationService =
  AutomationService();

  List<AutomationModel> automations = [];

  void showAutomationOptions(
      AutomationModel automation,
      ) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("Edit Automation"),
                onTap: () {
                  Navigator.pop(context);

                  // We'll implement next
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title: const Text(
                  "Delete Automation",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onTap: () async {

                  Navigator.pop(context);

                  await automationService.deleteAutomation(
                    automation.id,
                  );

                  await loadAutomations();
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


  @override
  void initState() {
    super.initState();
    loadAutomations();
  }


  Future<void> loadAutomations() async {

    automations =
    await automationService.getAutomations();

    if (mounted) {
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Automation"),
      ),


      body: ListView.builder(

        itemCount: automations.length,

        itemBuilder: (context,index){

          final automation =
          automations[index];


          return Card(

            margin: const EdgeInsets.all(12),

            child: ListTile(

              leading: const Icon(
                Icons.schedule,
              ),

              title: Text(
                automation.name,
              ),

              subtitle: Text(
                "${automation.startTime} - ${automation.endTime}\n"
                    "Runs: ${automation.sceneName}",
              ),

              onLongPress: () {
                showAutomationOptions(
                  automation,
                );
              },


              trailing: Switch(
                value: automation.enabled,

                onChanged: (value) async {

                  final updated = AutomationModel(
                    id: automation.id,
                    name: automation.name,
                    startTime: automation.startTime,
                    endTime: automation.endTime,
                    sceneName: automation.sceneName,
                    enabled: value,
                  );

                  await automationService.updateAutomation(updated);

                  await loadAutomations();
                },
              ),

            ),
          );
        },
      ),


      floatingActionButton:
      FloatingActionButton(
        child: const Icon(Icons.add),

        onPressed: () async {

          await Navigator.pushNamed(
            context,
            '/automation-editor',
          );

          await loadAutomations();

        },
      ),
    );
  }
}