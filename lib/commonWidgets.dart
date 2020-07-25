import 'package:easy_life/services/mynotifire.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

Future addItemtoDatabase(String itemname, String price, String imageUrl,
    BuildContext context, var useremail, var uid) async {
  if (useremail != null && !price.contains('emand')) {
    final DocumentReference userCartItem =
        Firestore.instance.collection('theusers').document(uid);
    var doc = await userCartItem.get();

    List tags = doc.data['cartList'];
    if (!tags.contains(itemname + imageUrl)) {
      userCartItem.updateData({
        'cartList': FieldValue.arrayUnion(
            [itemname + '##' + price + '##' + imageUrl + '##' + '1'])
      });
      BuyFlush('$itemname Added to your order');
    }
  } else {
    showWiringDialog(context);
  }
}

showWiringDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Close",
        style: TextStyle(color: Colors.red, fontFamily: 'Ptsans')),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
    title: Text(
      "Need Electrical and Wiring Services?",
      style: TextStyle(fontSize: 18, fontFamily: 'Ptsans', color: Colors.green),
    ),
    content: Text('Call or Text Us : 0714121205',
        style:
            TextStyle(fontSize: 20, fontFamily: 'Ptsans', color: Colors.black)),
    actions: [
      cancelButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Widget rowAfterSearch(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 18.0, left: 20, right: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
              fontFamily: 'Muli', color: Colors.blueGrey, fontSize: 16),
        ),
        Text(
          'See more >>',
          style: TextStyle(
              fontFamily: 'Monts', color: Colors.orange, fontSize: 12),
        ),
      ],
    ),
  );
}

 Widget shopObject(var item,var context,var useremail,var uid) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      margin: EdgeInsets.only(bottom: 20),
      height: 200,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 180,
               decoration: BoxDecoration( boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1, 1),
                        blurRadius: 5)
                  ],),
               child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: GestureDetector(
                            child: CachedNetworkImage(
                                  
                                  imageUrl:item['imageUrl'],
                                  progressIndicatorBuilder: (context, url,
                                          downloadProgress) =>
                                      Container(
                                          height: 170,
                                          width: 70,
                                          child: CircularProgressIndicator(
                                              value:
                                                  downloadProgress.progress)),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: (){
                                  print(item['itemname']);
                                },
                       
                            ),
                          ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                 Text(
                  item['itemname'],
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Ptsans'),
                ),
                SizedBox(
                  height: 7,
                ),
                Text(
                  'ksh ${item['price']}',
                  style: TextStyle(
                      fontSize: 15, color: Colors.orange[700], fontFamily: 'Muli'),
                ),
                SizedBox(
                  height: 30,
                ),
                addToCartButton(
                    item['itemname'], item['price'], item['imageUrl'],context,useremail,uid),
                ],
              ),
              margin: EdgeInsets.only(bottom: 20, top: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(5, 5),
                        blurRadius: 10)
                  ]),
            ),
          )
        ],
      ),
    );
  }

  Widget addToCartButton(String itemname, String price, String url,BuildContext context,var useremail,var uid){
    return  SizedBox(
      height: 30,
      width: 120,
          child: RaisedButton(
                    color: Colors.green[600],
                    onPressed: (){
                      
                      addItemtoDatabase(itemname,price,url,context,useremail,uid);
          
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text("Buy", style: TextStyle(fontFamily: 'Muli',color: Colors.white)),
                        Icon(MdiIcons.cartPlus,color: Colors.white,),
                      ],
                    ),
                  ),
    );
  }