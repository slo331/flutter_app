// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';

import './screens/auth_screen.dart';
import './screens/forgotpass_screen.dart';
import './screens/dashboard_screen.dart';

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
          home: SplashScreen(),
          // home: auth.isAuth
          //     ? DashBoardScreen()
          //     : FutureBuilder(
          //         future: auth.tryAutoLogin(),
          //         builder: (ctx, authResultSnapshot) => SplashScreen(),
          //       ),
          routes: {
            AuthScreen.routeName: (ctx) => AuthScreen(),
            ForgotPasswordScreen.routeName: (ctx) => ForgotPasswordScreen(),
            DashBoardScreen.routeName: (ctx) => DashBoardScreen(),
          },
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _jumpToPage();
  }

  Future<void> _jumpToPage() async {
    await Future.delayed(Duration(milliseconds: 3000), () {});
    var isLogin = Provider.of<Auth>(context, listen: false).isAuth;

    if (!isLogin) {
      Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
      print(isLogin);
    } else {
      Navigator.of(context).pushReplacementNamed(DashBoardScreen.routeName);
      print(isLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.all(50.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Shingrix Q&A'.toUpperCase(),
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Splash Screen Placeholder Here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
