import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider/AppProvider.dart';
import 'Screens/LoginScreen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Cần dòng này khi dùng SQLite
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppProvider(),
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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
    );
  }
}