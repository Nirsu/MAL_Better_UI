import 'package:flutter/material.dart';
import 'package:myapp/constants.dart';
import '../../Components/rounded_button.dart';
import './WebWiew.dart';

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  openMALAuth() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyWebWiew('https://flutter.dev')
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(backgroundColor: kPrimaryColor,),
      ),
      body: Container(
        width: double.infinity,
        height: size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome on MAL Better UI\n Login with a MAL account',
                  style: TextStyle(color: Colors.white),
                ),
                RoundedButton(
                  text: 'LOGIN',
                  press: () {
                    openMALAuth();
                  },
                )
              ],
            )
          ]
        ),
      ),
    );
  }
}