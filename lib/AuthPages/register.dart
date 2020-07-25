import 'package:easy_life/AuthPages/login.dart';
import 'package:easy_life/Home.dart';
import 'package:easy_life/services/auth.dart';
import 'package:easy_life/services/mynotifire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:connectivity/connectivity.dart';


class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  

  String email = '';
  String password = '';
  String username = '';
  String mpesaNo='';

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
      appBar: AppBar(title: Text('Register Account',style: TextStyle(color: Colors.white,fontFamily: 'Ptsans',fontSize: 18),)),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
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
                padding: const EdgeInsets.only(bottom: 32.0),
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
                    validator: (val) =>
                        val.length < 3 ? 'Enter Valid Name' : null,
                    decoration: InputDecoration(
                      labelText: 'USERNAME',
                      labelStyle: TextStyle(fontSize: 14),
                    ),
                    onChanged: (val) {
                      setState(() => username = val);
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    validator: (val) =>
                        val.length != 10 || val[0]!='0' || val[1]!='7'? 'Enter Valid Number' : null,
                    decoration: InputDecoration(
                      labelText: 'MPesa No.',
                      labelStyle: TextStyle(fontSize: 14),
                    ),
                    onChanged: (val) {
                      setState(() => mpesaNo = val);
                    },
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    validator: (val) => val.length < 7 || !val.contains('@') || !val.contains('.')
                        ? 'Enter Valid Email'
                        : null,
                    decoration: InputDecoration(
                      labelText: 'EMAIL',
                      labelStyle: TextStyle(fontSize: 14),
                    ),
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                 SizedBox(height: 8),
                  TextFormField(
                    validator: (val) =>
                        val.length < 6 ? 'Enter longer Password' : null,
                    decoration: InputDecoration(
                        labelText: 'PASSWORD',
                        labelStyle: TextStyle(fontSize: 14)),
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    validator: (val) =>
                        val != password ? 'Passwords Dont Match' : null,
                    decoration: InputDecoration(
                        labelText: 'REPEAT PASSWORD',
                        labelStyle: TextStyle(fontSize: 14)),
                    
                  )
                ]),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only( top: 16),
                  child: SizedBox(
                    width: 280,
                    height: 45,
                    child: RaisedButton(
                        color: Colors.orange[400],
                        child: Text('Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Spect',
                            )),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(35.0),
                        ),
                        onPressed: () async {
                          
                            if (_formKey.currentState.validate()) {

                              if (connectResult == ConnectivityResult.mobile || connectResult == ConnectivityResult.wifi) {
                                   _openLoadingDialog(context);
                            setState(() => isLoading=true);
                            dynamic result = await _auth.registerWithEandPassword(
                                email, password, username,mpesaNo);

                            if (result == null) {
                              MyFlush('$email is already registered with an account');
                              Navigator.pop(context);
                            } else {
                               Navigator.pop(context);
                              
                              MyFlush('Registration Succesfull');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ));
                            }
                            setState(() => isLoading=false);
                              } else {
                                MyFlush('No Internet Connection');
                              }
                         
                          }
                          
                          
                        }),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: SizedBox(
                  width: 280,
                  height: 45,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only( top: 10),
                  child: RichText(
                    text: TextSpan(
                        text: 'Already have an Account ',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Muli',
                          fontSize: 14,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Login',
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Login(),
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

void checkConnection()async{
connectResult = await (Connectivity().checkConnectivity());
}
}
