import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleView extends StatefulWidget {
  String articleUrl;
  ArticleView({this.articleUrl});
  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  Completer<WebViewController> _completer = Completer<WebViewController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: NavigationToolbar.kMiddleSpacing.sign,
        title: Text(
          'Pin on',
          style: TextStyle(
            color: Colors.lightBlueAccent[400],
            //fontWeight: FontWeight.w700,
            fontSize: 30,
            fontFamily: 'Pacifico',
          ),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.lightBlueAccent[400],
            ),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        child: WebView(
          initialUrl: widget.articleUrl,
          onWebViewCreated: ((WebViewController webViewController) {
            _completer.complete(webViewController);
          }),
        ),
      ),
    );
  }
}
