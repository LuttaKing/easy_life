import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';


class Profile extends StatefulWidget {
  final useremail;
  final userid;
  final username;
  var profpicurl;
  final number;

  Profile(
      {this.useremail,
      this.userid,
      this.username,
      this.profpicurl,
      this.number});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin{
  File imageFile;
  bool isLoading=false;

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://easylife-43279.appspot.com');
  StorageUploadTask _uploadTask;
  bool isUploadingImage = false;
  String imageUrl;


  Animation<double> anim;
  AnimationController animcont;

@override
  void initState() {  

     animcont =AnimationController(vsync: this, duration: Duration(milliseconds: 1550));
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
            appBar: AppBar(title: Text('profile',style: TextStyle(fontFamily: 'Ptsans',color: Colors.orange)),
            backgroundColor: Colors.green[500],
            centerTitle: true,),
        body: SafeArea(
      child: SingleChildScrollView(
          child: Container(
         
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(overflow: Overflow.visible, children: [

                 Container(
              padding: EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0, bottom: 10.0),
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
                elevation: 5.0,
                color: Colors.white,
                child: Transform(
                      transform: Matrix4.translationValues(
                                 anim.value * width, 0.0, 0.0),
                                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 50.0,),
                      Text(widget.username, ),
                      SizedBox(height: 5.0,),
                      Text("Location : Kericho(Midwest)"),
                      SizedBox(height: 10.0,),
                      Container(
                        height: 40.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: ListTile(
                                title: Text("12",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),),
                                subtitle: Text("Total Orders".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12.0) ),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text("3",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),),
                                subtitle: Text("Current Orders".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12.0) ),
                              ),
                            ),
                          
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
          ),

           Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
               GestureDetector(

                      child: CircleAvatar(
                        radius: 41.8,
                        backgroundColor: Colors.orange[600],
                        child: isLoading ?  CircularProgressIndicator(backgroundColor: Colors.blue,) : CircleAvatar(
                          radius: 38,
                          backgroundImage: CachedNetworkImageProvider(
                              widget.profpicurl ),
                        ),
                      ),
                      onTap:(){
                        pickImage();
                      }
                    ),
              ],
          ),

              ]),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Text(widget.username,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Ptsans',
                        fontSize: 21,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Customer ID: 3hn3w88s8s884u',
                    style:
                        TextStyle(color: Colors.black, fontFamily: 'Ptsans',fontSize: 18)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'User Information',
                style: TextStyle(
                    fontSize: 21, fontFamily: 'Fred', color: Colors.blueGrey),
              ),
            ),
            Transform( transform: Matrix4.translationValues(
                              anim.value * width, 0.0, 0.0),
                          child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(children: [
                        ListTile(
                          leading: Icon(Icons.call, color: Colors.orange[600]),
                          title: Text(
                            'Phone',
                            style: myTextStyle(),
                          ),
                          subtitle: Text(widget.number),
                          onTap: null,
                        ),
                      _divider(),
                        ListTile(
                          leading: Icon(Icons.email, color: Colors.orange),
                          title: Text(
                            'My Email',
                            style: myTextStyle(),
                          ),
                          subtitle: Text(widget.useremail),
                          onTap: null,
                        ),
                      _divider(),
                        ListTile(
                          leading: Icon(Icons.my_location, color: Colors.orange),
                          title: Text(
                            'My Location',
                            style: myTextStyle(),
                          ),
                          subtitle: Text('Kericho,Kenya'),
                          onTap: null,
                        ),
                       
                      ])),
              ),
            ),
          ],
        ),
      )),
    ));});
  }

  Divider _divider(){
    return  Divider(
                          indent: 20,
                          endIndent: 20,
                          color: Colors.green,
                        );
  }

  TextStyle myTextStyle() {
    return TextStyle(
      fontSize: 13,
      fontFamily: 'Monts',
    );
  }

  Future pickImage() async {
        File selectedimage = await ImagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          isLoading = true;
          imageFile = selectedimage;
        });

        _startUpload().then((picUrl){
        changeProfPicUrl(picUrl);
        });
  }

  Future _startUpload() async {
          isUploadingImage = true;
          String filePath = 'ProfilePics/${widget.useremail}.png';
          //upload image
          setState(() {
            _uploadTask = _storage.ref().child(filePath).putFile(imageFile);
          });
          // get Url
          StorageTaskSnapshot taskSnapshot = await _uploadTask.onComplete;
          String picUrl = await taskSnapshot.ref.getDownloadURL();

          imageUrl=picUrl;
          // private code i wrote to clear uploadtask on complete
          _uploadTask.onComplete.then((val) {
            setState(() {
              _uploadTask = null;
              imageFile = null;
            });
          });
          isUploadingImage = false;
          return picUrl;
  }

  final CollectionReference userCollection = Firestore.instance.collection('theusers');
  dynamic changeProfPicUrl(String pcurl) async {
          await userCollection.document(widget.userid).updateData({'profpicurl': pcurl});
          setState(() {
            widget.profpicurl=pcurl;
            isLoading=false;
          });
  }
}
