import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyFlush extends StatefulWidget {

 final message;

   MyFlush(this.message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.orange[500],
        textColor: Colors.black);
  }
  @override
  _MyFlushState createState() => _MyFlushState();
}

class _MyFlushState extends State<MyFlush> {
  @override
  Widget build(BuildContext context) {return Container();}
}

class BuyFlush extends StatefulWidget {
  final message;
   BuyFlush(this.message) {
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.green[500],
        textColor: Colors.white);
  }

  @override
  _BuyFlushState createState() => _BuyFlushState();
}

class _BuyFlushState extends State<BuyFlush> {

  @override
  Widget build(BuildContext context) {return Container();}
}