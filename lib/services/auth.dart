import 'package:easy_life/services/user.dart';
import 'package:easy_life/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _auth=FirebaseAuth.instance;

  // create user object
  User _fromFirebaseUser(FirebaseUser user){
    
    return user !=null ? User(uid: user.uid): null;

  }

  //outh change stream
 Stream<User> get user{

   return _auth.onAuthStateChanged
   .map(_fromFirebaseUser);
 }

  //REG with email and pass
    Future registerWithEandPassword(String email,String password,String username,String mpesaNo) async{
    try {
     AuthResult result= await _auth.createUserWithEmailAndPassword(email: email, password: password);
     FirebaseUser user = result.user;

 await DatabaseService(uid:user.uid).updateUserData(username,mpesaNo);

     return _fromFirebaseUser(user);

    } catch (e) {
      print(e.toString());
      return null;
    }
  }

   //signIn with email and pass
    Future signInWithEandPassword(String email,String password) async{
    try {
     AuthResult result= await _auth.signInWithEmailAndPassword(email: email, password: password);
     
     FirebaseUser user = result.user;
     return _fromFirebaseUser(user);

    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  //signout
  Future signOut() async{
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;    }
  }
}