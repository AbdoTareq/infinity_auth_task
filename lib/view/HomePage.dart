import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/HomePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Title'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }
}
