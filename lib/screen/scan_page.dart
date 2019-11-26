import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scan_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScanProvider>(
      builder: (_) => ScanProvider(),
      child: Consumer<ScanProvider>(
        builder: (BuildContext context, ScanProvider provider, Widget child) {
          return Scaffold(
              body: FutureBuilder<bool>(
            future: provider.checkForPermission(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData && snapshot.data) {
//                provider.openQRScanner();
                return FutureBuilder<bool>(
                  future: provider.openQRScanner(),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData && snapshot.data) {
                      return WebView(
                        initialUrl: provider.url,
                        onPageFinished: (String url) {},
                        onWebViewCreated: (WebViewController controller) {},
                      );
                    } else if (snapshot.hasData && !snapshot.data) {
                      return buildAlertDialog('OOPS!!', 'URL is not valid');
                    } else {
                      return Container();
                    }
                  },
                );
              } else if (snapshot.hasData && !snapshot.data) {
                return Center(
                  child: RaisedButton(
                    child: Text('SCAN'),
                    onPressed: () async {
                      bool isPermissionGranted =
                          await provider.requestPermission();
                      if (isPermissionGranted) {
                        provider.scanQRCode();
                      } else {
                        buildAlertDialog(
                            'OOPS!!!', 'Please give the permission to scan');
                      }
                    },
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
//            !provider.isPermissionGranted
//                ?
//                : ,
              );
        },
      ),
    );
  }

  Widget buildAlertDialog(String title, String content) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
