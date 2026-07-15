import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dashboard),
      ),
      body: Consumer<AppProvider>(
        builder: (context, app, child) {
          if (!app.isLoggedIn) {
            return const Center(
              child: Text("Access Denied"),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome to Smart Villa",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                Card(
                  child: ListTile(
                    leading: const Icon(Icons.auto_mode),
                    title: const Text("Scenes"),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.pushNamed(context, '/scenes');
                    },
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () async {
                    await app.runSavedScene("Good Morning");
                  },
                  onLongPress: () {
                    Navigator.pushNamed(
                      context,
                      '/scene-editor',
                      arguments: "Good Morning",
                    );
                  },
                  child: const Text("☀️ Morning"),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () async {
                    await app.runSavedScene("Good Night");
                  },
                  onLongPress: () {
                    Navigator.pushNamed(
                      context,
                      '/scene-editor',
                      arguments: "Good Night",
                    );
                  },
                  child: const Text("🌙 Night"),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () async {
                    await app.runSavedScene("Away");
                  },
                  onLongPress: () {
                    Navigator.pushNamed(
                      context,
                      '/scene-editor',
                      arguments: "Away",
                    );
                  },
                  child: const Text("🏠 Away"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}