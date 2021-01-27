import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:random_string/random_string.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:myapp/constants.dart';
import '../../Components/rounded_button.dart';
import './WebWiew.dart';

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  openMALAuth() {
    var code = randomString(128);
    var hash = sha256.convert(ascii.encode(code));
    String codeChallenge = base64Url.encode(hash.bytes).replaceAll("=", "").replaceAll("+", "-").replaceAll("/", "_");
    String urlMAL = "https://myanimelist.net/v1/oauth2/authorize?response_type=code&client_id=" + env['MAL_CLIENT_ID'] + "&code_challenge=" + codeChallenge + "&state=RequestID42";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MALLoginWebView(
          url: urlMAL,
          codeChallenge : codeChallenge,
        )
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