import 'dart:async';
import 'package:myapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebWiew extends StatelessWidget {
  String url;
  MyWebWiew(this.url);

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: Builder(builder: (BuildContext context) {
        return Scaffold (
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: AppBar(backgroundColor: kPrimaryColor,),
          ),
          body: WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onPageStarted: (String url) {
                print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
            },
            gestureNavigationEnabled: true,
          )
        );
      })
    );
  }
}