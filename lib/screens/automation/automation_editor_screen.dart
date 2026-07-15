import 'package:flutter/material.dart';
import '../../models/automation_model.dart';
import '../../services/automation_service.dart';


class AutomationEditorScreen extends StatefulWidget {
  const AutomationEditorScreen({super.key});

  @override
  State<AutomationEditorScreen> createState() =>
      _AutomationEditorScreenState();
}


class _AutomationEditorScreenState
    extends State<AutomationEditorScreen> {

  final AutomationService service =
  AutomationService();

  final nameController =
  TextEditingController();


  TimeOfDay startTime =
  const TimeOfDay(hour: 22, minute: 0);

  TimeOfDay endTime =
  const TimeOfDay(hour: 6, minute: 0);


  String selectedScene = "Good Night";


  Future<void> pickStartTime() async {

    final time = await showTimePicker(
      context: context,
      initialTime: startTime,
    );

    if (time != null) {
      setState(() {
        startTime = time;
      });
    }
  }


  Future<void> pickEndTime() async {

    final time = await showTimePicker(
      context: context,
      initialTime: endTime,
    );

    if (time != null) {
      setState(() {
        endTime = time;
      });
    }
  }


  Future<void> save() async {
    try {
      final automation = AutomationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text.trim(),
        startTime: startTime.format(context),
        endTime: endTime.format(context),
        sceneName: selectedScene,
        enabled: true,
      );

      await service.addAutomation(automation);

      print("Automation saved successfully");

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      print("SAVE ERROR: $e");
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Create Automation",
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            TextField(
              controller: nameController,

              decoration: const InputDecoration(
                labelText: "Automation Name",
              ),
            ),


            const SizedBox(height:20),


            ListTile(
              title: const Text(
                "Start Time",
              ),

              subtitle: Text(
                startTime.format(context),
              ),

              trailing: const Icon(
                Icons.access_time,
              ),

              onTap: pickStartTime,
            ),


            ListTile(
              title: const Text(
                "End Time",
              ),

              subtitle: Text(
                endTime.format(context),
              ),

              trailing: const Icon(
                Icons.access_time,
              ),

              onTap: pickEndTime,
            ),


            const SizedBox(height:20),


            DropdownButton<String>(

              value: selectedScene,

              items: const [

                DropdownMenuItem(
                  value:"Good Morning",
                  child:Text("☀️ Good Morning"),
                ),

                DropdownMenuItem(
                  value:"Good Night",
                  child:Text("🌙 Good Night"),
                ),

                DropdownMenuItem(
                  value:"Away",
                  child:Text("🏠 Away"),
                ),

              ],

              onChanged:(value){

                setState(() {
                  selectedScene=value!;
                });

              },
            ),


            const SizedBox(height:30),


            ElevatedButton(

              onPressed: save,

              child: const Text(
                "Save Automation",
              ),
            )

          ],
        ),
      ),
    );
  }
}