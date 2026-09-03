import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'providers/app_provider.dart';
import 'services/firebase_setup_service.dart';
import 'providers/device_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.signInAnonymously();

  //await FirebaseSetupService().createInitialDevices();


  runApp(
    MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => AppProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => DeviceProvider(),
        ),

      ],

      child: const MyApp(),
    ),
  );

}



class MyApp extends StatelessWidget {

  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      initialRoute: '/',

      onGenerateRoute: AppRoutes.generateRoute,
    );

  }

}