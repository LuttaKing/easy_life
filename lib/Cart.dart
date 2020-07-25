import 'package:easy_life/services/mynotifire.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';


class Cart extends StatefulWidget {
 
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {

  var locationLink;


  Location location = new Location();

bool _serviceEnabled;
PermissionStatus _permissionGranted;
LocationData _locationData;



Future _locate()async{
  _serviceEnabled = await location.serviceEnabled();
if (!_serviceEnabled) {
  _serviceEnabled = await location.requestService();
  if (!_serviceEnabled) {
    return;
  }
}

_permissionGranted = await location.hasPermission();
if (_permissionGranted == PermissionStatus.denied) {
  _permissionGranted = await location.requestPermission();
  if (_permissionGranted != PermissionStatus.granted) {
    return;
  }
}

_locationData = await location.getLocation();
 locationLink='https://www.google.com/maps/@${_locationData.latitude},${_locationData.longitude}';
 print(_locationData);


}
  

    List listItems;
  var useremail;
  var uid;
var thedocs;


  var username;
 
  var phoneNumber;

 final CollectionReference userCollection =Firestore.instance.collection('theusers');
  final FirebaseAuth authX = FirebaseAuth.instance;

  bool isLoading;
  var mystream;
   @override
  void initState() {
    super.initState();
    try {
        getUserInfo().then((val){
getCartItem();
    });
_locate();
    
    } catch (e) {

      MyFlush('An Error Occured in INIT');
    }
  
  }

 

 bool addminus=false;
 

  var listofPrice=[];

  
  @override
  Widget build(BuildContext context) {

      var screenheight = MediaQuery.of(context).size.height;
    return ListView(
       
        children: <Widget>[
         listItems!=null && listItems.length>0 ?   Container(
      height: screenheight*0.71,
       child: ListView.builder
  (
      itemCount: listItems.length,
      itemBuilder: (BuildContext ctxt, int index) {

        var singleList=listItems[index].split('##');
        listofPrice=[];
        
       return _buildCartItem(singleList,listItems[index]);
      }
  ),
         ) 
         : Center(child: Column(children: <Widget>[
           Padding(
             padding: const EdgeInsets.only(top:98.0),
             child: Text('Your Cart Has No Items',style: TextStyle(color: Colors.grey[600],fontSize: 27,fontFamily: 'Fred'),),
           ),
           Padding(
             padding: const EdgeInsets.only(bottom:70,top:38.0),
             child: Icon(MdiIcons.cartRemove,size: 70,color: Colors.grey,),
           )
         ],)),
     _buildTotals(),  
        ],
         
      );
  }

  

  Widget _buildCartItem(var thelist,var rawItem,){

    return  Card(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
  IconButton(icon: Icon(MdiIcons.deleteForever,color: Colors.black45,), onPressed: () {
   
    removeFromCart(rawItem);
  },),

                      Container(
                          height: 90,
                          width: 90,
                         child: CachedNetworkImage(imageUrl: thelist[2],), ),
                      Column(
                        children: <Widget>[
                          Text(thelist[0],
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Ksh ${int.parse(thelist[1])*int.parse(thelist[3])}',
                              style:
                                  TextStyle(color: Colors.amber, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          ClipOval(
                            child: Material(
                              color: Colors.orange, // button color
                              child: InkWell(
                                splashColor: Colors.red, // inkwell color
                                child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: Center(
                                        child: Text('+',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)))),
                                onTap: () {
                                Future.delayed(Duration(milliseconds: 500)).then((val){
 int piecetoint=int.parse(thelist[3]);
                                  var x=piecetoint+1;

                                updateListwithpiece(thelist[0],thelist[1],thelist[2],x.toString(),rawItem).then((val){
                                  getCartItem();
                                });
                                
                                });
                          

                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(thelist[3]),
                          ),
                          ClipOval(
                            child: Material(
                              color: Colors.orange, // button color
                              child: InkWell(
                                splashColor: Colors.red, // inkwell color
                                child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: Center(
                                        child: Text('-',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)))),
                                onTap: () {
                                  Future.delayed(Duration(milliseconds: 500)).then((val){
                                          int piecetoint=int.parse(thelist[3]);
                                  if (piecetoint>1) {
                                    var x=piecetoint-1;
                                updateListwithpiece(thelist[0],thelist[1],thelist[2],x.toString(),rawItem).then((val){
                                  getCartItem();
                                });
                                  }
                               
                                  });
                                 
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ));
  }
  Future getCartItem()async{

    final DocumentReference userCartItem = Firestore.instance.collection('theusers').document(uid);

      if (useremail!=null) {
        var doc = await userCartItem.get();

        List cartItems=doc.data['cartList'];

      setState(() {
        listItems=cartItems;
        addminus=false;
      });

      }

  }

   Future getUserInfo() async {
    dynamic res = await authX.currentUser();
    useremail = res.email;
    uid = res.uid;
    
  }

  Future removeFromCart(var rawItem)async{
setState(() {
  listItems.remove(rawItem);
  
});
 final DocumentReference userCartItem = Firestore.instance.collection('theusers').document(uid);
    
      var doc = await userCartItem.get();
      List tags=doc.data['cartList'];
      if (tags.contains(rawItem)) {
        userCartItem.updateData({
          'cartList':FieldValue.arrayRemove([rawItem])
        });
    }

  }

  

   Future updateListwithpiece(String itemname,String price,String imageUrl,String pieces,String rawItem)async{
  final DocumentReference userCartItem = Firestore.instance.collection('theusers').document(uid);
    if (useremail!=null) {

        userCartItem.updateData({
          'cartList':FieldValue.arrayUnion([itemname+'##'+price+'##'+imageUrl+'##'+pieces])
        }).then((val){
removeFromCart(rawItem);
        });
    }

  }

 
  Widget _buildTotals() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        color: Colors.green,
        onPressed: () {
          int sum=0;
          List finallist=[];
          List toBeposted=[];

            for (var item in listItems) {
            List listItem=item.split('##');
              var totalpriceofSingleItem=int.parse(listItem[1])*int.parse(listItem[3]);
              finallist.add(totalpriceofSingleItem);
              toBeposted.add(listItem[0]+'  >>>>>  '+listItem[3]);
            }
                      
                for (var i = 0; i < finallist.length; i++) {
                    sum += finallist[i];
                  }
  getUserNumber().then((val){
showAlertDialog(context,sum,toBeposted);
  });
          
        },
        child: Text("Confirm Order", style: TextStyle(color: Colors.white)),
      ),
    );
  }


  showAlertDialog(BuildContext context,int total,var listToPost) {

    Widget _column(){
      return Padding(
        padding: const EdgeInsets.only(left:18.0),
        child: Container(
          height: 250,
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text('Items Price(s):   ',style: TextStyle(fontFamily: 'Monts',fontSize: 18)),
                  Text(total.toString(),style: TextStyle(fontFamily: 'Muli',fontSize: 18,fontWeight: FontWeight.bold)),
                ],
              ),
            ),

             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Row(
                children: <Widget>[
                  Text('Delivery:        ',style: TextStyle(fontFamily: 'Monts',fontSize: 20),),
                  Text('50',style: TextStyle(fontFamily: 'Muli',fontSize: 18,fontWeight: FontWeight.bold)),
                ],
            ),
             ),

             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Row(
                children: <Widget>[
                  Text('Total Price:   ',style: TextStyle(fontFamily: 'Monts',fontSize: 20)),
                  Text((total+50).toString(),style: TextStyle(fontFamily: 'Muli',fontSize: 18,fontWeight: FontWeight.bold)),
                ],
            ),
             ),

               Padding(
               padding: const EdgeInsets.all(0.0),
               child: Row(
                children: <Widget>[
                  Text('Mpesa No >>>',style: TextStyle(fontFamily: 'Muli',fontSize: 15,color: Colors.greenAccent)),
                  Text(phoneNumber,style: TextStyle(fontFamily: 'Ptsans',fontSize: 18,)),
                ],
            ),
             ),
          ],),
        ),
      );
    }

  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel",style: TextStyle(color: Colors.red,fontFamily: 'Ptsans')),
    onPressed:  () {Navigator.pop(context);},
  );
  Widget continueButton = FlatButton(color: Colors.green,
    child: Text("Pay with Mpesa",style: TextStyle(color: Colors.white,fontFamily: 'Ptsans'),),
    onPressed:  ()async {
      Navigator.pop(context);
      _openLoadingDialog(context);

         performStkPush(phoneNumber,(total+50).toString(),username,listToPost).then((val){
           Navigator.pop(context);
         }).then((val){
           showFeedBackToUser(context);
         });
    
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
     shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
     
    title: Text("CheckOut",style: TextStyle(fontFamily: 'Ptsans',color: Colors.green),),
    content: _column(),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

  Future getUserNumber() async {
    try {
  
      await userCollection.document(uid).get().then((document) {
  
      setState(() {
          username=document.data['username'];
          phoneNumber=document.data['Number'];
      });
    });
    } catch (e) {
      print('ERROR IN Cart GetNumber');
    }

  }

Future performStkPush(String number,String amount,String username,var listx)async{

  try {
    var url = 'https://easylifempesa.herokuapp.com/api/lipa';
var response = await http.post(url, body: {'amount': amount, 'number': number,'username':username,'itemsDetail':listx.toString(),'location':_locationData.toString()}).then((val){
  
});
print('Response status: ${response.body}'); 
  } catch (e) {
    print(e.toString());
  }

}


showFeedBackToUser(BuildContext context,) {

  Widget _message(){
    return Container(
      height: 300,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text('Enter your MPESA pin when prompted',style: TextStyle(fontFamily: 'Muli',fontSize: 20,color: Colors.green,fontWeight: FontWeight.bold)),
          ),

          Padding(
            padding: const EdgeInsets.only(left:8.0,right: 8,top:9),
            child: Text('note: IF MPESA PROMPT DOES NOT APPEAR AUTOMATICALLY WITHIN 15 SECONDS,TRY REGISTERING WITH A DIFFERENT NUMBER.'
,style: TextStyle(fontFamily: 'Ptsans',fontSize: 15,color: Colors.pink)
            ),
           
          ),
           Center(child: Text('[some few numbers arent supported yet]',style: TextStyle(fontFamily: 'Ptsans',fontSize: 9,color: Colors.pink))),
        ],
      ),
    );
  }

   
 
  Widget cancelButton = FlatButton(
    child: Text("Close",style: TextStyle(color: Colors.red,fontFamily: 'Ptsans')),
    onPressed:  () {Navigator.pop(context);},
  );
 

  AlertDialog alert = AlertDialog(
     shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
     
    title: Text("Processing Payment",style: TextStyle(fontFamily: 'Ptsans',fontWeight: FontWeight.bold),),
    content: _message(),
    actions: [
      cancelButton,
      
    ],
  );

  // show the dialog
  showDialog(
    context: context,
barrierDismissible: false,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

   void _openLoadingDialog(BuildContext context) {
  showDialog(
     barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Container(height: 100,width: 100,child: Center(child: CircularProgressIndicator())),
      );
    },
  );
}


}
