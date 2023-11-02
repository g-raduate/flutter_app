// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graduate/login_singup/auth/forget_password.dart';
import '../../main.dart';
import '../../screens.dart';
import '../shortcut/Customtextformfieldpassword.dart';
import '../shortcut/custombotton.dart';
import '../shortcut/logo.dart';
import '../shortcut/textformfield.dart';
import 'package:http/http.dart' as http;
bool isadmin=false;
final secure_storage=new FlutterSecureStorage();
class Login extends StatefulWidget
{
  const Login({super.key});
  @override
  _Login createState() =>_Login();
}
class _Login extends State<Login>
{
  final GlobalKey<FormState>_formkey=GlobalKey<FormState>();
  TextEditingController Email =TextEditingController();
  TextEditingController passward =TextEditingController();
  bool isloading =false;
  @override
  void initState() {
    super.initState();
    AutoOrientation.portraitUpMode();
  }
  @override
  Widget build (BuildContext context)
  {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formkey,
          child:
              ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 50,),
                      Logo(),
                      Container(height: 20,),
                      const Text("تسجيل الدخول",style: TextStyle(fontWeight: FontWeight.bold,fontSize:30 ),),
                      Container(height: 20,),
                      const Text("للاستمرار في استخدام التطبيق يجب تسجيل الدخول",style: TextStyle(color:Colors.grey),),
                      Container(height: 20,),
                      const Text("البريد",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                      Container(height: 10,),
                      CustomTextFormField(hinttext: "ادخل البريد هنا",mycontroler:Email ,check: false, number: false,isvalidator: true),
                      Container(height: 10,),
                      const Text("كلمة السر",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                      Container(height: 10,),
                      CustomTextFormFieldPassword(hinttext: "ادخل كلمة السر هنا",mycontroler:passward,check: true, number: false,isvalidator: true),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(top: 10,bottom: 10,left: 20),
                              child: InkWell(
                                  onTap: (){
                                    Navigator.pushNamed(context,"signup");
                                  },
                                  child: Text("انشاء حساب جديد",style: TextStyle(fontSize: 14 ,letterSpacing: 1,wordSpacing: 2,color: Colors.blue[900],fontWeight: FontWeight.bold),textAlign: TextAlign.right))),
                          Container(
                              margin: const EdgeInsets.only(top: 10,bottom: 10,right: 20),
                              child: InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgetPassword(),));
                                  },
                                  child: const Text("نسيت كلمة السر؟",style: TextStyle(fontSize: 14 ,letterSpacing: 1,wordSpacing: 2,),textAlign: TextAlign.right))),
                        ],
                      ),
                      custombutton(onPressed: () async {
                        try {
                          LogIn();
                        }  catch (e) {
                          }
                        }
                      , text: "تسجيل الدخول"),
                    ],
                  ),
                ],
              )
          ),
        ),
      );
  }
  void LogIn() async {

    showDialog(context: context, builder: (context) =>
      Center(child: CircularProgressIndicator())
      );
    var url = Uri.https(URL,"/api/Auth/Login");
    // Create a map with the email and password data
    Map<String, String> data = {
      "email": Email.text,
      "password": passward.text,
    };
    // Encode the data as JSON
    String jsonBody = jsonEncode(data);
    // Set the headers for the request
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    // Make the POST request
    var response = await http.post(
      url,
      headers: headers,
      body: jsonBody,
    );
    // Check the response
    if (response.statusCode == 200) {
      print(response.body);
      final responseJson = json.decode(response.body);
      await secure_storage.write(key: 'token', value: responseJson['token']);
      await secure_storage.write(key: 'refreshToken', value: responseJson['refreshToken']);
      await secure_storage.write(key: 'refreshTokenExpiration', value:responseJson['refreshTokenExpiration'] );
      await secure_storage.write(key: 'sessionId', value:responseJson['sessionId'] );
      List<dynamic> User=responseJson['roles'];
      for (var user in User) {
        if(user=='Admin')
        {
          setState(() {
            isadmin=true;
          });
        }
      }
      String? token = await secure_storage.read(key: 'token');
      print("Token = $token");
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Screens(currentindex: 0)),
            (route) => false,
      );
    } else {
      if (response.headers['content-type'] == 'application/json; charset=utf-8') {
        // Check if the response is in JSON format
      final responseJson = json.decode(response.body);
      List<dynamic>errors=responseJson["errors"];
        if (responseJson.containsKey("errors") && responseJson["errors"] is List) {
      for (var error in errors)
        {
          if (error=='EMAIL_NOT_CONFIRMED')
          showSnackbar(context, 'يرجى تاكيد البريد الكتروني');
         else if (error=='INVALID_EMAIL_OR_PASSWORD')
          showSnackbar(context, 'كلمة السر او البريد خطأ يرجى المحاولة مره اخرى');
        }}
      else
        {
          showSnackbar(context,"خطأ غير معروف");
        }}
      else {
        // Handle non-JSON responses (e.g., server error)
        showSnackbar(context, "Server error occurred");
      }
      Navigator.of(context).pop();
  }}
  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3), // Adjust the duration as needed
      ),
    );
  }

}
