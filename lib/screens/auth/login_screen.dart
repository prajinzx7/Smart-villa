import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';
import '../../widgets/custom_button.dart';
import '../../core/constants/app_strings.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                AppStrings.login,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextField(
                decoration: const InputDecoration(
                  labelText: AppStrings.username,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: const InputDecoration(
                  labelText: AppStrings.password,
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 25),
              CustomButton(
                text: "Login",
                onPressed: () {
                  final app = context.read<AppProvider>();
                  app.login();
                  Navigator.pushReplacementNamed(context, '/dashboard');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}