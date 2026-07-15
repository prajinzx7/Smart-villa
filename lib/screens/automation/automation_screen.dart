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


  @override
  void initState() {
    super.initState();

    automationService.clearAutomations().then((_) {
      loadAutomations();
    });
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


              trailing: Switch(
                value: automation.enabled,

                onChanged: (value){

                  // enable/disable later

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