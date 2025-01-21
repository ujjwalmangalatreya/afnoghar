

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hamroghar/appwrite.dart';
import 'package:hamroghar/view/spash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppWrite.inti();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hamro Ghar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
