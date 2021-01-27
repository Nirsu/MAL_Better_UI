import 'package:flutter/material.dart';
import 'Screens/Login/LoginPage.dart';
import 'package:myapp/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

Future main() async {
  await DotEnv.load();
  runApp(MyApp());
}
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(backgroundColor: kPrimaryColor,),
        ),
        body: LoginPage(),
      ),
    );
  }
}