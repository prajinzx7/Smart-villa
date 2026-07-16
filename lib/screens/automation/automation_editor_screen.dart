import 'package:flutter/material.dart';
import '../../models/automation_model.dart';
import '../../services/automation_service.dart';


class AutomationEditorScreen extends StatefulWidget {
  final AutomationModel? automation;

  const AutomationEditorScreen({
    super.key,
    this.automation,
  });

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

  @override
  void initState() {
    super.initState();

    if (widget.automation != null) {

      nameController.text = widget.automation!.name;

      selectedScene = widget.automation!.sceneName;

      startTime = parseTime(widget.automation!.startTime);

      endTime = parseTime(widget.automation!.endTime);
    }
  }

  TimeOfDay parseTime(String time) {

    final now = DateTime.now();

    final date = TimeOfDay.fromDateTime(
      DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(
          time.split(":")[0],
        ),
        int.parse(
          time.split(":")[1].split(" ")[0],
        ),
      ),
    );

    return date;
  }


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

    final automation = AutomationModel(

      id: widget.automation?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),

      name: nameController.text.trim(),

      startTime: startTime.format(context),

      endTime: endTime.format(context),

      sceneName: selectedScene,

      enabled: widget.automation?.enabled ?? true,
    );

    if (widget.automation == null) {
      await service.addAutomation(automation);
    } else {
      await service.updateAutomation(automation);
    }

    if (!mounted) return;

    Navigator.pop(context);
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