import 'package:easy_life/AuthPages/register.dart';
import 'package:easy_life/services/mynotifire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:easy_life/services/auth.dart';
import 'package:connectivity/connectivity.dart';

class Login extends StatefulWidget {

  
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final AuthService _auth =AuthService();
  final _formKey = GlobalKey<FormState>();

  String email='';
  String password='';

  var mytext='';
  var isLoading=false;
var connectResult;

  @override
  void initState() {
    checkConnection();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Text(
                  'Easy',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 49,
                      fontFamily: 'Viva',
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 63.0),
                child: RichText(
                  text: TextSpan(
                      text: 'Life',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Viva',
                          fontSize: 90,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: '.',
                          style: TextStyle(
                              color: Colors.orange[400],
                              fontSize: 100,
                              fontWeight: FontWeight.bold),
                        )
                      ]),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                     validator: (val)=> val.length<7 || !val.contains('@') ? 'Enter Valid Email' : null,
                      decoration: InputDecoration(
                    labelText: 'EMAIL',
                    labelStyle: TextStyle(fontSize: 14),
                  ),
                  onChanged: (val){
                    setState(()=> email=val);
                  },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (val)=> val.length<6 ? 'Password Should Be Longer' : null,
                    decoration: InputDecoration(
                        labelText: 'PASSWORD',
                        labelStyle: TextStyle(fontSize: 14)),
                        onChanged: (val){
                    setState(()=> password=val);
                  },
                  )
                ]),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 160.0, top: 30, bottom: 21),
                child: Text('Forgot Password?',
                    style: TextStyle(
                      fontFamily: 'Muli',
                      decoration: TextDecoration.underline,
                      color: Colors.blue[400],
                      fontSize: 13,
                    )),
              ),
              isLoading ?
             
               Center(
                child: SizedBox(
                  width: 280,
                  height: 45,
                  child: RaisedButton(
                      color: Colors.white10,
                      child: CircularProgressIndicator(backgroundColor: Colors.white,),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(35.0),
                      ),
                      onPressed: null,
                      ),
                ),
              )
              :
               Center(
                child: SizedBox(
                  width: 280,
                  height: 45,
                  child: RaisedButton(
                      color: Colors.orange[400],
                      child: Text('LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Spect',
                          )),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(35.0),
                      ),
                      onPressed: () async{
     if(_formKey.currentState.validate()){
       if (connectResult == ConnectivityResult.mobile || connectResult == ConnectivityResult.wifi) {
         
       setState(() => isLoading=true);
                                     dynamic result = await _auth.signInWithEandPassword(email,password);
                                     if (result==null) {
                                       MyFlush('INCORRECT CREDENTIALS');
                                     } 
                                  

                    
                       setState(() => isLoading=false);
                       
       } else {
 MyFlush('No Internet Connection');
       }
        }                  
                      }
                      ),
                ),
              )
              ,
              SizedBox(height: 15),
             
              Center(
                child: Padding(
                  padding: const EdgeInsets.only( top: 26),
                  child: RichText(
                    text: TextSpan(
                        text: 'Dont Have an Account? ',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Muli',
                          fontSize: 14,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Register',
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {

                                  Navigator.push(
                              context,
                               MaterialPageRoute(
                                 builder: (context) => Register(),
                               ));
                               
                              },
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontFamily: 'Muli',
                              color: Colors.orange[400],
                              fontSize: 14,
                            ),
                          )
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }



void checkConnection()async{
connectResult = await (Connectivity().checkConnectivity());
}
}
