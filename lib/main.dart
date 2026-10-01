import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('taskBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      debugShowCheckedModeBanner: false,
      // Black and white theme
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          onPrimary: Colors.black,
          surface: Colors.black,
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.white),
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF1A1A1A),
        ),
        dialogTheme: const DialogThemeData(
          backgroundColor: Color(0xFF1A1A1A),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white70),
          errorStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
