import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:pogo/firstLoadingPage.dart';
import 'amplifyFunctions.dart';
import 'package:pogo/LandingPage.dart';
import 'LoginPage.dart';
import 'RegisterPage.dart';
import 'LandingPage.dart';
import 'googleFunctions/CivicFunctions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: firstLoadingPage(),
    );
  }
}
