import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BlotMap extends StatefulWidget {
  static const routeName = '/blotMap';
  const BlotMap({
    Key? key,
  }) : super(key: key);

  @override
  State<BlotMap> createState() => _BlotMapState();
}

class _BlotMapState extends State<BlotMap> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  void dispose() {
    super.dispose();
    WebView.platform;
    _BlotMapState();
  }


  @override
  Widget build(BuildContext context) {
    var isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    const String latestUrl = 'https://blot-echo-qy4nptoeha-uc.a.run.app/latest';
    const String mapUrl =
        'https://blot-echo-qy4nptoeha-uc.a.run.app/maponly.html';
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Blot Echo Wind Map'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.orange,
      ),
      body: RotatedBox(
        quarterTurns: isLandscape ? 0 : 1,
        child: WebView(
            initialUrl: latestUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
              webViewController.loadUrl(
                  'https://blot-echo-qy4nptoeha-uc.a.run.app/maponly.html');
            },
            navigationDelegate: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
            gestureNavigationEnabled: true,
            backgroundColor: const Color(0x00000000),
      ),
    ));
  }
}
