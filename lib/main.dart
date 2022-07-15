import 'dart:developer';

import 'package:driver_app/components/splash_screen.dart';
import 'package:driver_app/constants/constants.dart';
import 'package:driver_app/pages/layout.dart';
import 'package:flutter/material.dart';
import 'package:driver_app/pages/dashboard.dart';
import 'package:driver_app/pages/login.dart';
import 'package:driver_app/providers/auth.dart';
import 'package:driver_app/providers/user_provider.dart';
import 'package:driver_app/util/storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'domain/user.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: FutureBuilder<User>(
        future: getUserData().then(
          (value) =>
              Provider.of<UserProvider>(context, listen: false).user = value,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const SplashScreen();
            default:
              if (snapshot.hasError) {
                return Text('Erreur: ${snapshot.error}');
              } else if (snapshot.data.token == null) {
                return Login();
              } else {
                return Layout();
              }
          }
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Application client',
  //     theme: ThemeData(
  //       primarySwatch: Colors.blue,
  //       visualDensity: VisualDensity.adaptivePlatformDensity,
  //     ),
  //     home: Home(),
  //     routes: {
  //       '/dashboard': (context) => DashBoard(),
  //       '/home': (context) => Layout(),
  //       '/login': (context) => Login(),
  //     },
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
          title: 'Application conducteur',
          localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
          supportedLocales: const [Locale('fr', 'FR')],
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: primaryColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: FutureBuilder(
              future: getUserData(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const SplashScreen();
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.data.token == null) {
                      return Login();
                    } else {
                      return Layout();
                    }
                }
              }),
          routes: {
            '/dashboard': (context) => DashBoard(),
            '/home': (context) => Layout(),
            '/login': (context) => Login(),
          }),
    );
  }
}
