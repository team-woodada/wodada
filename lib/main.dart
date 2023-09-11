import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:wodada/screens/home_screen.dart';
import 'package:wodada/screens/login_screen.dart';
import 'package:wodada/screens/signup_screen.dart';
import 'package:wodada/screens/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontFamily: 'Ubuntu',
        ),
      )),
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => const HomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        SignUpScreen.id: (context) => const SignUpScreen(),
        WelcomeScreen.id: (context) => const WelcomeScreen(),
      },
    );
  }
}
