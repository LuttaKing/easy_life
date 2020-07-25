import 'package:easy_life/drawers.dart';
import 'package:flutter/material.dart';
import 'package:easy_life/Account.dart';
import 'package:easy_life/Cart.dart';
import 'package:easy_life/Electric.dart';
import 'package:easy_life/ShopPage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  

  final FirebaseAuth authX = FirebaseAuth.instance;
  final CollectionReference userCollection =
      Firestore.instance.collection('theusers');

  var useremail;
  var userid;
  var username;
  var profpicurl;
  var phoneNumber;
  int _cIndex = 0;

  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
    });
  }

  List _pages = [
    ShopPage(),
    ElectricPage(),
    Cart(),
    AccountPage(),
  ];

    GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();

     @override
  void initState() {
     
    super.initState();
  }

   var profpicholder='https://firebasestorage.googleapis.com/v0/b/easylife-43279.appspot.com/o/profpic.png?alt=media&token=1f3ac7a6-f407-49d3-b475-2d5beea4a822';


  @override
  Widget build(BuildContext context) {
 getUserInfo();
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.transparent, 
            ),
            child: MyDrawer(phoneNumber: phoneNumber,useremail: useremail,profpicurl: profpicurl,userid: userid,username: username,)),
      appBar: AppBar(
        elevation: 0,
       
        title: Text('Easy Life',style: TextStyle(fontFamily: 'Ptsans', color: Colors.white),),
       
        centerTitle: true,
        backgroundColor: Colors.green[700],
        leading: IconButton(
          color: Colors.white,
          icon: Icon(Icons.menu),
          onPressed: ()  {
             _scaffoldKey.currentState.openDrawer();
         // Scaffold.of(context).openDrawer();
          },
        ),
        actions: <Widget>[
          CircleAvatar(
                      backgroundColor: Colors.orange,
                      radius: 19.9,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundImage: CachedNetworkImageProvider(profpicurl!=null? profpicurl : profpicholder),
                      ),
                    ),
        ],
      ),
      body: Center(child: _pages[_cIndex]),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        bottomBarItem(Icon(MdiIcons.shopping),'Shop'),
        bottomBarItem(Icon(MdiIcons.electricSwitchClosed),'Electricals'),
        bottomBarItem(Icon(MdiIcons.basketOutline),'My Order'),
       bottomBarItem(Icon(MdiIcons.truckDelivery),'Status'),

      ],
      onTap: (index) {
        _incrementTab(index);
      },
      currentIndex: _cIndex,
      type: BottomNavigationBarType.fixed,
      fixedColor: Colors.orange[800],
    );
  }

  BottomNavigationBarItem bottomBarItem(Icon icon,String text){
    return BottomNavigationBarItem(
            icon: icon, title: Text(text));
  }

  void getUserInfo() async {
    try {
      dynamic res = await authX.currentUser();
      useremail = res.email;
      userid = res.uid;

      await userCollection.document(userid).get().then((document) {
      setState(() {
          username=document.data['username'];
        profpicurl=document.data['profpicurl'];
          phoneNumber=document.data['Number'];
      });
      });
    } catch (e) {
      print('ERROR IN HOME $e');
    }

  }
}
