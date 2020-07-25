
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});
 
  final CollectionReference brewCollection=Firestore.instance.collection('theusers');
var profpicurl='https://firebasestorage.googleapis.com/v0/b/easylife-43279.appspot.com/o/profpic.png?alt=media&token=f5978938-0977-4c56-a4df-0f098bc9877b';
  Future updateUserData(String username,String number) async{
    return await brewCollection.document(uid).setData({
            'username':username,
             'Number':number,
             'profpicurl':profpicurl,
             'cartList':[]

         
    });
  }

 

}

class SearchService {
  searchByName(String searchField){
    return Firestore.instance.collection('products').where('sK',isEqualTo: searchField.substring(0,1).toUpperCase()).getDocuments();
  }

   searchByNameElectric(String searchField){
    return Firestore.instance.collection('electric').where('sk',isEqualTo: searchField.substring(0,1).toUpperCase()).getDocuments();
  }
}