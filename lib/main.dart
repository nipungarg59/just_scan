import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        body: new Builder(builder: (BuildContext context) {
          _launchURL(context);
          return new Center(
          child: new RaisedButton(
            child: new Text('Go To Bansal Publisher'),
            onPressed: () => _launchURL(context),
          ),
        );
        }),
      ),
    );
  }

  void _launchURL(BuildContext context) async {
    try {
      await launch(
        'https://www.bansalpublishers.com/login.php',
        option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          // or user defined animation.
          animation: new CustomTabsAnimation(
          startEnter: 'slide_up',
          startExit: 'android:anim/fade_out',
          endEnter: 'android:anim/fade_in',
          endExit: 'slide_down',
        ),
        extraCustomTabs: <String>[
          // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
          'org.mozilla.firefox',
          // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
          'com.microsoft.emmx',
        ],
      ),
    );
    } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
    }
  }
}


