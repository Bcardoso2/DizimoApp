import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(DizimoApp());
}

class DizimoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dízimo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blueGrey[100], // Fundo escuro
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[100], // Cor do AppBar
        ),
        cardColor: Colors.grey[800], // Cor dos Cards
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          titleLarge: TextStyle(color: Colors.black), // Para os títulos
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.blueGrey[900], // Cor do BottomNavigationBar
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.white,
        ),
      ),
      home: HomeScreen(), // Tela inicial
    );
  }
}
