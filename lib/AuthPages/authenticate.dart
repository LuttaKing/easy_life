import 'package:easy_life/AuthPages/login.dart';
import 'package:easy_life/Home.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:easy_life/services/user.dart';

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    if (user==null) {
      return Login();
    } else {
      return HomePage();
    }
    
  }
}