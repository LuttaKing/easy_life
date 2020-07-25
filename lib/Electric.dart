import 'package:easy_life/commonWidgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:easy_life/services/database.dart';

class ElectricPage extends StatefulWidget {
  @override
  _ElectricPageState createState() => _ElectricPageState();
}

class _ElectricPageState extends State<ElectricPage> {
    var thedocs=[];
     
  var useremail;
  var uid;

  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth authX = FirebaseAuth.instance;

  var mystream;

  @override
  void initState() {
    super.initState();
 getUserInfo();
  
    mystream=_firestore.collection('electric').snapshots();
  }

List imagesSlider=['https://firebasestorage.googleapis.com/v0/b/easylife-43279.appspot.com/o/sliders%2Fpexels-photo-210018.jpeg?alt=media&token=bea2dcbb-edaa-4335-a0f3-335a5fe279ac',
'https://firebasestorage.googleapis.com/v0/b/easylife-43279.appspot.com/o/sliders%2Fpexels-photo-257736.jpeg?alt=media&token=28ea857a-6427-476b-bfe7-953e030bb7b8',
'https://firebasestorage.googleapis.com/v0/b/easylife-43279.appspot.com/o/sliders%2Fpexels-photo-3921702.jpeg?alt=media&token=e5f58e54-b2ef-4bb8-84cd-bbcf7df28892',
'https://firebasestorage.googleapis.com/v0/b/easylife-43279.appspot.com/o/sliders%2F4kagain.jpg?alt=media&token=de9948e2-2d23-4545-b451-11e8e9b034e7',

];

var queryResultSet=[];
var tempSearchStore=[];

  @override
  Widget build(BuildContext context) {
    return _mainW();
  }

  Widget _mainW() {
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
              stream:mystream,
                 
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                List<DocumentSnapshot> docs = snapshot.data.documents;

               if (thedocs.isEmpty) {
                  thedocs=docs;
                         }
                return ListView.builder(
                  
                 itemBuilder: _buildListView,
        itemCount: thedocs.length + 1,
                );
              },
      ));
    
  }

  Widget _buildListView(BuildContext context, int index) {
     if (index == 0) return _buildSlider();
    if (queryResultSet.isEmpty) {
     var item = thedocs[index - 1];
    return shopObject(item, context, useremail,uid);
  
    } else {
    var item = thedocs[index - 1];
  return shopObject(item, context, useremail,uid);
   // return _buildshopItem(item);
  
    }
  }

   
    Widget _buildSlider() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: <Widget>[
          Container(
            height: 150.0,
            child: Stack(
              children: <Widget>[
                ClipPath(
                  clipper: DiagonalPathClipperOne(),
                  child: Container(
                    height: 100,
                    color: Colors.green[700],
                  ),
                ),
                Container(
                 
                  padding: EdgeInsets.symmetric(horizontal: 0.0,),
                  child: Swiper(
                    
                    autoplay: true,
                    itemBuilder: (BuildContext context,int index){
                                return new CachedNetworkImage(fit: BoxFit.fill, imageUrl: imagesSlider[index],);

                    },
                    itemCount: imagesSlider.length,
                    pagination: new SwiperPagination(),
                    viewportFraction: 0.85,
                    scale: 0.9,
                  ),
                ),

                
              ],
            ),
          ),

           _buildSearch(),

           rowAfterSearch('Electric Products and Deals '),
        ],
      ),
    );
  }


  Widget _buildSearch() {
    return Container(
      padding: EdgeInsets.only(left:20,right: 20,top: 15),
      child: TextField(
         onChanged: (val){
          
          initiateSearch(val);
        },
        decoration: InputDecoration(
                border:  OutlineInputBorder(
    borderRadius:  BorderRadius.circular(12),
    ),
          hintStyle:  TextStyle(color: Colors.grey,fontFamily: 'Monts'),
    hintText: " Search",
            suffixIcon: IconButton(
              onPressed: null,
              icon: Icon(Icons.search,color: Colors.lightGreen,),
            )),
      ),
    );
  }


void initiateSearch(value) {
  
  if(value.length==0){
    setState(() {
      queryResultSet=[];
    tempSearchStore=[];
    thedocs=[];
    });}
  
  
  else if(queryResultSet.length==0 && value.length==1){
     
    SearchService().searchByNameElectric(value).then((QuerySnapshot docx){
      for(int i=0;i < docx.documents.length; ++i){
queryResultSet.add(docx.documents[i].data);
setState(() {
  thedocs=queryResultSet;
});
      }
    });
  }else{
    
    var capitalizedValue=value.substring(0,1).toUpperCase() + value.subString(1);
    tempSearchStore=[];
    queryResultSet.forEach((element){
      if (element['itemname'].startsWith(capitalizedValue)) {
        setState(() {
          tempSearchStore.add(element);
        
        });
      }
    });
  }
}


 void getUserInfo() async {
    dynamic res = await authX.currentUser();
    useremail = res.email;
    uid = res.uid;}


}