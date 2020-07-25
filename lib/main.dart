

import 'package:easy_life/AuthPages/authenticate.dart';
import 'package:easy_life/services/auth.dart';
import 'package:easy_life/services/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
     return StreamProvider<User>.value(
      value: AuthService().user,
    child:MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy Life',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Authenticate(),
    ),
    );
  }
}

