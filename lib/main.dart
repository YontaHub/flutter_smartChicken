import 'package:flutter/material.dart';
import 'package:smart_chick/screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartChicken',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.light(primary: Colors.green)),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}