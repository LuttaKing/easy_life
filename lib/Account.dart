import 'package:flutter/material.dart';


class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}


class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          Container(
            height: 700.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber[200], Colors.orange[200]]
              ),
            ),
            child: Center(child: Text('Status of Transaction will Go Here'),),
          ),


      
        ],
      );
  }

  


 

   
}