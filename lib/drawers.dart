import 'package:easy_life/aboutPage.dart';
import 'package:easy_life/profile.dart';
import 'package:easy_life/services/auth.dart';
import 'package:easy_life/services/mynotifire.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
class MyDrawer extends StatefulWidget {

  final useremail;
  final userid;
  final username;
  final profpicurl;
  final phoneNumber;

  const MyDrawer({Key key, this.useremail, this.userid, this.username, this.profpicurl, this.phoneNumber}) : super(key: key);
 
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> with TickerProviderStateMixin {
  final AuthService _auth = AuthService();


  Animation<double> drawerwidthanimation;
  AnimationController drawerwidthanimcont;

  Animation<double> drawerhtanim;
  AnimationController drawerhtanimcont;

  Animation<Color> colorAnimation;
  AnimationController coloranimcont;

  @override
  void initState() {
    drawerwidthanimcont =AnimationController( duration: Duration(milliseconds: 300), vsync: this);
    drawerwidthanimation =Tween<double>(begin: 0.0, end: 200.0).animate(drawerwidthanimcont);
    drawerwidthanimation.addListener(() {
      setState(() {});
    });


    drawerhtanimcont =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    drawerhtanim =
        Tween<double>(begin: 0.0, end: 400.0).animate(drawerhtanimcont);
    drawerhtanim.addListener(() {
      setState(() {});
    });
    coloranimcont =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    colorAnimation = ColorTween(begin: Colors.white, end: Colors.green[300])
        .animate(coloranimcont);
    colorAnimation.addListener(() {
      setState(() {});
    });
    drawerwidthanimcont.forward();
    drawerhtanimcont.forward();
    coloranimcont.forward();
   

    super.initState();
  }

  @override
  dispose() {
    drawerwidthanimcont.dispose();
    drawerhtanimcont.dispose();
    coloranimcont.dispose();
    super.dispose();
  }

 

  var profpicholder='https://firebasestorage.googleapis.com/v0/b/easylife-43279.appspot.com/o/profpic.png?alt=media&token=1f3ac7a6-f407-49d3-b475-2d5beea4a822';


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0)),
      ),
      width: drawerwidthanimation.value + 100,
      height: drawerhtanim.value + 200,
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(25.0),
              bottomRight: Radius.circular(25),
            ),
          ),
          height: 100,
          child: ListView(children: [
            Stack(
              children: <Widget>[
                Container(
                  height: 160,
                ),
                Positioned(
                  top: 10,
                  right: 12,
                  child: IconButton(icon: Icon(
                    MdiIcons.close,
                    color: Colors.blueGrey[800],
                    size: 29,
                  ), onPressed: () {Navigator.pop(context);},)
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 38,
                      child: GestureDetector(
                                              child: CircleAvatar(
                          radius: 35,
                          backgroundImage: CachedNetworkImageProvider(widget.profpicurl!=null? widget.profpicurl : profpicholder),
                        ),
                        onTap: (){
                           goToProfile();
                        },
                      ),
                    ),
                  ),
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 100.0, bottom: 23),
                  child: Text(
                    widget.username != null ? widget.username : '',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Ptsans',
                    ),
                  ),
                )),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 140.0, bottom: 23),
                  child: Text(
                    widget.useremail != null ? widget.useremail : '',
                    style: TextStyle(
                      fontFamily: 'Ptsans',
                    ),
                  ),
                )),
              ],
            ),
            Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Card(
                      color: colorAnimation.value,
                      child: ListTile(
                        leading: Icon(
                          Icons.home,
                          color: Colors.blueGrey,
                        ),
                        title: Text(
                          'Home',
                          style: TextStyle(
                            fontFamily: 'Monts',
                          ),
                        ),
                        onTap: () async {},
                      ),
                    ),
                    Card(
                      color: colorAnimation.value,
                      child: ListTile(
                        leading: Icon(
                          Icons.person,
                          color: Colors.pink,
                        ),
                        title: Text(
                          'Profile',
                          style: TextStyle(
                            fontFamily: 'Monts',
                          ),
                        ),
                        onTap: () {
                         goToProfile();
                        },
                      ),
                    ),
                    Card(
                      color: colorAnimation.value,
                      child: ListTile(
                        leading: Icon(
                          MdiIcons.accountGroup,
                          color: Colors.green,
                        ),
                        title: Text(
                          'About Us',
                          style: TextStyle(
                            fontFamily: 'Monts',
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                             MaterialPageRoute(
                               builder: (context) => AboutPage(),
                             ));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: Card(
                        color: colorAnimation.value,
                        child: ListTile(
                          leading: Icon(
                            MdiIcons.logout,
                            color: Colors.orange,
                          ),
                          title: Text(
                            'Sign Out',
                            style: TextStyle(
                              fontFamily: 'Monts',
                            ),
                          ),
                          onTap: () async {
                            MyFlush('Logging Out');
                            
                            
                            await _auth.signOut();
                             
                          },
                        ),
                      ),
                    ),
                  ],
                ))
          ]),
        ),
      ),
    );
  }

  void goToProfile(){
     Navigator.pop(context);
                          
                          Navigator.push(
                            context,
                             MaterialPageRoute(
                               builder: (context) => Profile(profpicurl: widget.profpicurl,useremail: widget.useremail,number: widget.phoneNumber,username: widget.username,userid: widget.userid,),
                             ));
  }
}
