import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'login_singup/auth/login.dart';
import 'login_singup/auth/singup.dart';
import 'login_singup/shortcut/auto_login_screen.dart';
String URL="graduate-a29962909a04.herokuapp.com";
void main() async{

  runApp(MyApp());
}
class MyApp extends StatelessWidget
{
  @override
  Widget build (BuildContext context)
  {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white
      ),
      home:  LoginOrScreens(),
      routes: {
        "signup":(context) => Signup(),
        "login":(context) => Login(),
      },
    );
  }
}
