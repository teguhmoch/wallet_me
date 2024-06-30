import 'app.dart';
import 'package:flutter/material.dart';

import 'pages/auth/login.dart';
import 'pages/auth/registration.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Realm Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        '/home': (context) => App(),
        '/register': (context) => RegistrationPage(),
      },
    );
  }
}
