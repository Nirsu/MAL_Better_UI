import 'package:flutter/material.dart';
import 'Screens/Login/LoginPage.dart';
import 'package:myapp/constants.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MALBetterUI authPage',
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: kPrimaryColor,
      ),
      home: Scaffold(
        body: LoginPage(),
      ),
    );
  }
}