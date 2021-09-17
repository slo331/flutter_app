// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';

import './screens/auth_screen.dart';
import './screens/forgotpass_screen.dart';

import './helpers/custom_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Shingrix',
          theme: ThemeData(
            primarySwatch: Colors.red,
            accentColor: Colors.red[400],
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              },
            ),
          ),
          home: AuthScreen(),
          routes: {
            ForgotPasswordScreen.routeName: (ctx) => ForgotPasswordScreen(),
          },
        ),
      ),
    );
  }
}
