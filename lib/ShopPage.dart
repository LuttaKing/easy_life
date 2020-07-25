import 'package:easy_life/commonWidgets.dart';
import 'package:easy_life/services/database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';


class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> with TickerProviderStateMixin {
  var thedocs=[];
  var useremail;
  var uid;
var connectResult;

  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth authX = FirebaseAuth.instance;
  Animation<double> anim;
  AnimationController animcont;


  var shopproductstream;

  @override
  void initState() {
    super.initState();
    getUserInfo();

    shopproductstream = _firestore.collection('products').snapshots();

     animcont =AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    anim = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animcont, curve: Curves.fastOutSlowIn));

   anim.addListener(() {
      setState(() {});
    });

    animcont.forward();
  }

   @override
  dispose() {
    animcont.dispose();
  
   super.dispose();
  }

  void getUserInfo() async {
    dynamic res = await authX.currentUser();
    useremail = res.email;
    uid = res.uid;
  
  }
List imagesSlider=['https://firebasestorage.googleapis.com/v0/b/easylife-43279.appspot.com/o/sliders%2Fpexels-photo-128402.jpeg?alt=media&token=de491da8-e271-4795-b77b-1b850a3d9975',
  'https://firebasestorage.googleapis.com/v0/b/easylife-43279.appspot.com/o/sliders%2Fonions.jpeg?alt=media&token=db277740-cb2c-4417-a734-cb927903f2dd',
'https://firebasestorage.googleapis.com/v0/b/easylife-43279.appspot.com/o/sliders%2Fpexels-photo-106343.jpeg?alt=media&token=bc55f147-4ad5-4641-9f39-25e3b25f6ebc',

'https://firebasestorage.googleapis.com/v0/b/easylife-43279.appspot.com/o/homeAndFoodProducts%2Fchicken.jpeg?alt=media&token=47a8bc23-2340-4a13-8b49-ee1d8ace746a',
];


var queryResultSet=[];
var tempSearchStore=[];

void initiateSearch(value) {
  
  if(value.length==0){
    setState(() {
      queryResultSet=[];
    tempSearchStore=[];
    thedocs=[];
    });
  }
  
  
  else if(queryResultSet.length==0 && value.length==1){
     
    SearchService().searchByName(value).then((QuerySnapshot docx){
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

  @override
  Widget build(BuildContext context) {
   
    return AnimatedBuilder(
          animation: animcont,
        builder: (BuildContext context, Widget child) {
          return _mainW();});
  }

  Widget _mainW() {
    return SafeArea(
        child: StreamBuilder<QuerySnapshot>(
      stream: shopproductstream,
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

           rowAfterSearch('Home Products and Deals '),
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



}
