import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with TickerProviderStateMixin {

  Animation<double> anim;
  AnimationController animcont;

@override
  void initState() {  

     animcont =AnimationController(vsync: this, duration: Duration(milliseconds: 1050));
    anim = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animcont, curve: Curves.fastOutSlowIn));

   anim.addListener(() {
      setState(() {});
    });

    

    animcont.forward();
    super.initState();
  }



   @override
  dispose() {
    animcont.dispose();
  
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final double width = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
          animation: animcont,
        builder: (BuildContext context, Widget child) {
          return Scaffold(

        appBar: AppBar(centerTitle: true,title: Text('EasyLife App',style: TextStyle(fontFamily: 'Ptsans',color: Colors.orange)),backgroundColor: Colors.green[600],actions: <Widget>[
          IconButton(icon: Icon(Icons.developer_board), onPressed: () {animcont.reverse();},)],),
        body: SafeArea(
                child: SingleChildScrollView(
                                child: Container(child: Column(children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Transform(
                            transform: Matrix4.translationValues(
                              anim.value * width, 0.0, 0.0),
                                                      child: Container(
                              height: 120,
                              width:200,
                              decoration: new BoxDecoration(
                                 borderRadius: BorderRadius.all(Radius.circular(30)),
                              image: new DecorationImage(
                        image: new AssetImage("image/deliver.jpeg"),
                        fit: BoxFit.fill,
                              )
                            )),
                          ),
                        ),

                        Column(children: <Widget>[
                          Text('Source',style: TextStyle(color: Colors.orange,fontFamily: 'Fred',fontSize: 28),),

 Text('&',style: TextStyle(color: Colors.green[500],fontFamily: 'Ptsans',fontSize: 20),),

  Text('Delivery',style: TextStyle(color: Colors.orange,fontFamily: 'Fred',fontSize: 28),),


                        ],)
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text('Easy Life App is an idea that was born to help you find products and services you may need and get them delivered right to your doorstep.We keep our services/deliveries timely and secure and also ensure quality products',
                    style: TextStyle(fontSize: 18,color: Colors.black,fontFamily: 'Monts',),),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Contact Us',style:TextStyle(fontSize: 19,fontFamily: 'Monts',color: Colors.orangeAccent)),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom:28.0,left: 28,right: 28),
                    child: Transform(
                      transform: Matrix4.translationValues(
                              anim.value * width, 0.0, 0.0),
                                          child: Card(elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),child: Column(
                        children: <Widget>[

                        Padding(
                          padding: const EdgeInsets.only(left:80.0,top: 20),
                          child: Row(children: <Widget>[Icon(MdiIcons.phone,color: Colors.blue,),SizedBox(width: 16,),Text('0714121205',style: TextStyle(fontSize: 18,fontFamily: 'Ptsans'),)],),
                        ),
 Divider(
                          indent: 40,
                          endIndent: 40,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:80.0,top: 20),
                          child: Row(children: <Widget>[Icon(MdiIcons.whatsapp,color: Colors.green,),SizedBox(width: 16,),Text('0714121205',style: TextStyle(fontSize: 18,fontFamily: 'Ptsans'),)],),
                        ),
                         Divider(
                           indent: 40,
                          endIndent: 40,
                          color: Colors.grey,
                        ),

Padding(
                          padding: const EdgeInsets.only(left:70.0,top: 20,bottom: 20),
                          child: Row(children: <Widget>[Icon(MdiIcons.emailOutline,color: Colors.red,),SizedBox(width: 16,),Text('easylife@gmail.com',style: TextStyle(fontSize: 16,fontFamily: 'Ptsans'),)],),
                        ),



                      ],),),
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Terms and Conditions',style:TextStyle(fontSize: 10,fontFamily: 'Monts',color: Colors.orangeAccent)),
                  ),

              ],),),
                ),
        ),
        
          );
        });
  }

  void slideanimation(var theNumber){

  }
}