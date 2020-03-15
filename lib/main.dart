import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuition_attendance/models/models.dart';
import 'package:tuition_attendance/pages/home_page.dart';
import 'package:tuition_attendance/pages/login_screen.dart';

import 'package:tuition_attendance/services/firebase_service.dart'
    as firebaseService;

void main() {
  Crashlytics.instance.enableInDevMode = false;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runZoned(() {
    runApp(MyApp());
  }, onError: Crashlytics.instance.recordError);
}

FirebaseAnalytics analytics = FirebaseAnalytics();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.onAuthStateChanged,
        ),
      ],
      child: MaterialApp(
        title: 'Tuition Attendance',
        theme: ThemeData(
          primarySwatch: MaterialColor(0xff7160FF, {
            50: Color.fromRGBO(113, 96, 255, .1),
            100: Color.fromRGBO(113, 96, 255, .2),
            200: Color.fromRGBO(113, 96, 255, .3),
            300: Color.fromRGBO(113, 96, 255, .4),
            400: Color.fromRGBO(113, 96, 255, .5),
            500: Color.fromRGBO(113, 96, 255, .6),
            600: Color.fromRGBO(113, 96, 255, .7),
            700: Color.fromRGBO(113, 96, 255, .8),
            800: Color.fromRGBO(113, 96, 255, .9),
            900: Color.fromRGBO(113, 96, 255, 1),
          }),
        ),
        home: MyHomePage(),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    if (user != null) {
      return StreamProvider<User>.value(
        value: firebaseService.streamUser(user.uid),
        initialData: User.fromMap({}),
        child: HomePage(),
      );
    } else
      return LoginPage();
  }
}
