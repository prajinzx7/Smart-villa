import 'package:flutter/material.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/homes/homes_screen.dart';
import '../../screens/rooms/rooms_screen.dart';
import '../../screens/devices/devices_screen.dart';
import '../../screens/dashboard/smart_dashboard_screen.dart';
import 'package:smart_villa_prime/screens/scenes/scene_editor_screen.dart';
import 'package:smart_villa_prime/screens/scenes/scenes_screen.dart';
import '../../screens/automation/automation_screen.dart';
import '../../screens/automation/automation_editor_screen.dart';


class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case '/dashboard':
        return MaterialPageRoute(
          builder: (_) => SmartDashboardScreen(),
        );

      case '/homes':
        return MaterialPageRoute(
          builder: (_) => HomesScreen(),
        );
      case '/rooms':
        return MaterialPageRoute(
          builder: (_) => const RoomsScreen(),
        );
      case '/devices':
        return MaterialPageRoute(
          builder: (_) => const DevicesScreen(),
          settings: settings,
        );
      case '/scene-editor':
        final sceneName = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => SceneEditorScreen(
            sceneName: sceneName,
          ),
        );

      case '/scenes':
        return MaterialPageRoute(
          builder: (_) => const ScenesScreen(),
        );

      case '/automation':
        return MaterialPageRoute(
          builder: (_) => const AutomationScreen(),
        );

      case '/automation-editor':
        return MaterialPageRoute(
          builder: (_) => const AutomationEditorScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("No route found")),
          ),
        );
    }
  }
}