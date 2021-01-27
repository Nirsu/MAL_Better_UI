import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:myapp/home.dart';

class MALLoginWebView extends StatefulWidget {

  final String url;
  final String codeChallenge;
  const MALLoginWebView({
    Key key,
    this.url,
    this.codeChallenge,
  }) : super(key: key);
  @override
  MALLoginWebViewState createState() => MALLoginWebViewState(url, codeChallenge);
}

class MALLoginWebViewState extends State<MALLoginWebView> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  final String malLoginUrl;
  final String codeChallenge;
  MALLoginWebViewState(this.malLoginUrl, this.codeChallenge);

  void getUserAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    var response = await http.post('https://myanimelist.net/v1/oauth2/token', body: {
      'client_id' : env['MAL_CLIENT_ID'],
      'code': token,
      'code_verifier': this.codeChallenge,
      'grant_type': 'authorization_code',
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      prefs.setString('access_token', map['access_token']);
    }
  }

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (url.contains('?code=')) {
        String token = url.substring(url.indexOf('code=') + 5, url.indexOf('&state='));
        getUserAccessToken(token);
        flutterWebViewPlugin.close();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage()
          )
        );
      }
    });
  }

  @override
  void dispose() {
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 8.0),
      child: WebviewScaffold(
        url: malLoginUrl,
        withZoom: true,
        withLocalStorage: true,
        hidden: true,
      ),
    );
  }
}
