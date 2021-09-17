import 'package:flutter/material.dart';

class DashBoardScreen extends StatelessWidget {
  static const routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0.0,
        bottomOpacity: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Text('Dashboard Screen Here!'),
      ),
    );
  }
}
