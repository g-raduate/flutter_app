// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduate/login_singup/auth/login.dart';
import 'package:graduate/login_singup/shortcut/customappbar.dart';
import '../login_singup/auth/token_manager.dart';
import '../login_singup/shortcut/custombotton.dart';
class Profile extends StatefulWidget
{

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
   late Map Userinfo;
   late bool isloaded=false;
   void initState()
   {
     super.initState();
     _loadTeacherInfo();
   }
   Future<void> _loadTeacherInfo() async {
     final teacherInfo = await getUserInfo();
     if (teacherInfo!.isNotEmpty) {
       setState(() {
         Userinfo = teacherInfo!;
       });
       setState(() {
         isloaded=true;
       });
     }
   }
  @override
  Widget build (BuildContext context)
  {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        Column(
          children: [
            Column(
              children: [
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.only(top: 15,left: 15,right: 15,bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.indigoAccent[400],
                    borderRadius: const BorderRadius.only(bottomLeft:Radius.circular(20),bottomRight: Radius.circular(20)),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomAppBar(),
                        const SizedBox(height: 20,),
                        const Padding(padding: EdgeInsets.only(left: 3,bottom: 15),
                          child: Center(child: Text("Profile",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600,letterSpacing: 1,wordSpacing: 2,color: Colors.white),)),
                        ),
                      ]
                  ),
                ),
                const SizedBox(height: 40,),
                isloaded?Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Center(
                      child: Container(
                      padding: const EdgeInsets.only(right: 4),
                      height: 100,
                      decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200]
                      ),
                      child:  ClipOval(
                        child: Image.asset("images/hussein.jpg"),
                      ),
                      ),
                      ),
                      const SizedBox(height: 5,),
                      const Text("Email",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                      Container(height: 5,),
                      Container(
                        decoration:BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey[100],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: ListTile(
                          leading: const Icon(Icons.email,size: 23,),
                          title: Text(Userinfo['email'],style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      const Text("Username",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                      Container(height: 5,),
                      Container(
                        decoration:BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey[100],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: ListTile(
                          leading: const Icon(Icons.person,size: 23,),
                          title: Text(Userinfo['username'],style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      const Text("Phone Number",style: TextStyle(fontWeight: FontWeight.bold,fontSize:18),),
                      Container(height: 5,),
                  Container(
                    decoration:BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey[100],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: ListTile(
                      leading: const Icon(Icons.phone,size: 23,),
                      title: Text(Userinfo['phoneNumber'],style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
                    ),
                  ),
                      const SizedBox(height: 5,),
                      custombutton(onPressed: () async {
                        try {
                          logout();
                        }  catch (e) {
                        }
                      }
                          , text: "تسجيل الخروج"),
              ],
              ),
                ):Center(child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height/6,),
                      const CircularProgressIndicator()])),
              ],
            ),
          ],
        ),
      ],
    );
  }

   Future<Map?> getUserInfo() async {
     try {
       var response = await ApiClient().getAuthenticatedRequest(context,"/api/Auth/UserInfo");
       if (response!.statusCode == 200) {
         final Map UserInfo = json.decode(response.body);
         print(response.body);
         return UserInfo;
       } else {// Handle the case where the request was not successful
         print("Failed to fetch courses. Status code: ${response.statusCode}");
         return null;
       }
     } catch (e) {
       // Handle any exceptions that occur during the request
       print("Error fetching courses: $e");
       return null;
     }
   }
   Future<void> logout() async {
     // Delete the token
     showDialog(context: context, builder: (context) =>
       const Center(child: CircularProgressIndicator(),),);
     await secure_storage.delete(key: 'token');
     await secure_storage.delete(key: 'refreshToken');
     await secure_storage.delete(key: 'refreshTokenExpiration');
     await secure_storage.delete(key: 'sessionId');
     // Navigate the user to the login screen
     Navigator.of(context).pop();
     Navigator.pushReplacement(
       context,
       MaterialPageRoute(builder: (context) => const Login()),
     );
   }
}