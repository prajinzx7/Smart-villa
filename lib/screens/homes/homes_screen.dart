import 'package:flutter/material.dart';
import 'home_controller.dart';

class HomesScreen extends StatelessWidget {
  HomesScreen({super.key});

  final HomeController controller = HomeController();

  @override
  Widget build(BuildContext context) {
    final homes = controller.getHomes();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Homes"),
      ),
      body: ListView.builder(
        itemCount: homes.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.home),
            title: Text(homes[index].name),
            onTap: () {
              Navigator.pushNamed(context, '/rooms');
            },
          );
        },
      ),
    );
  }
}