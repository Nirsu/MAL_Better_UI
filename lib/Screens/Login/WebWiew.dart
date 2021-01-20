import 'dart:async';
import 'dart:convert';
import 'dart:js';

import 'package:random_string/random_string.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


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

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.onUrlChanged.listen((String url) {
      debugPrint(url);
      if (url.contains('?code=')) {
        String token = url.substring(url.indexOf('code=') + 5, url.indexOf('&state='));
        flutterWebViewPlugin.close();
        debugPrint(token);
        debugPrint(codeChallenge);
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

class MyWebWiew extends StatelessWidget {
  final String url;
  MyWebWiew(this.url);

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: Builder(builder: (BuildContext context) {
        return WebviewScaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: AppBar(backgroundColor: kPrimaryColor,),
          ),
          url: url,
          withZoom: false,
          hidden: true,
          initialChild: Container(
            color: kPrimaryColor,
            child: const Center(
              child: Text(
                'Loading...',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
        // return Scaffold (
        //   appBar: PreferredSize(
        //     preferredSize: Size.fromHeight(0),
        //     child: AppBar(backgroundColor: kPrimaryColor,),
        //   ),
        //   body: WebView(
        //     initialUrl: url,
        //     javascriptMode: JavascriptMode.unrestricted,
        //     onWebViewCreated: (WebViewController webViewController) {
        //       _controller.complete(webViewController);
        //     },
        //     onPageStarted: (String url) {
        //       debugPrint('Page started loading: $url');
        //       print('Page started loading: $url');
        //     },
        //     onPageFinished: (String url) {
        //       print('Page finished loading: $url');
        //     },
        //     gestureNavigationEnabled: true,
        //   )
        // );
      })
    );
  }
}