import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graduate/add_data/new_video.dart';
import 'package:graduate/login_singup/auth/login.dart';
import 'package:graduate/login_singup/shortcut/custombotton.dart';
import 'package:graduate/login_singup/shortcut/imageview.dart';
import 'package:graduate/video_section.dart';
import 'Description_section.dart';
import 'login_singup/auth/token_manager.dart';
import 'login_singup/shortcut/Count_video_section.dart';
import 'screens/buy_course.dart';
class CourseScreen extends StatefulWidget
{
  final bool lock;
  final String CourseId;
  final String Courseimage;
  final String Coursetitle;
  final String price;
  final String description;
  // ignore: non_constant_identifier_names
  const CourseScreen({super.key, required this.CourseId, required this.Courseimage, required this.Coursetitle, required this.lock, required this.price, required this.description});
  @override
  State<CourseScreen> createState() => _CourseScreenState();
}
class _CourseScreenState extends State<CourseScreen> {
  late List<dynamic> VideosInfo;
  bool isVideosSection =true;
  late Map Userinfo;
  bool isloading =false;
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
        isloading=true;
      });

    }
  }
  @override
  Widget build (BuildContext context)
  {
    return Scaffold(
      floatingActionButton:isVideosSection&&isadmin? FloatingActionButton(onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewVideo(),));
      },
        child:const Icon(Icons.add),
      ):null,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(widget.Coursetitle,style: const TextStyle(fontWeight: FontWeight.bold,letterSpacing: 1),),
        actions: [
          Padding(padding: const EdgeInsets.only(right: 10),
          child: Icon(Icons.notifications,size: 28,color: Colors.indigoAccent[400],),
          ),
        ],
      ),
      body:Padding(padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
        child:isloading? ListView(children: [
          ImageView(isArrow: true,img:widget.Courseimage),
          const SizedBox(height:15,),
          Text("${widget.Coursetitle} Complete Course",style: const TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
          const SizedBox(height:5,),
          Text("منصة خريج التعليمية",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black.withOpacity(0.7)),),
          const SizedBox(height: 20,),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFF5F3FF),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              Material(
                color: isVideosSection ? const Color(0xFF674AEF):const Color(0xFF674AEF).withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: (){
                    setState(() {
                      isVideosSection=true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15,horizontal:35),
                    child: const Text("Videos",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
                Material(
                  color:isVideosSection ?const Color(0xFF674AEF).withOpacity(0.6):const Color(0xFF674AEF),
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        isVideosSection=false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15,horizontal:35),
                      child: const Text("Description",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
            ],),
          ),
          const SizedBox(height: 10,),
          Center(child:widget.lock? Text(widget.price+"  :  السعر ",style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold)):null),
          Center(
            child:widget.lock?custombutton(onPressed:() {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => BuyCourse(price: widget.price,title: widget.Coursetitle),));
            }, text: "شراء"):null,
          ),
          const SizedBox(height: 10,),
          isVideosSection ? widget.lock?CountVideoSection(CourseId: widget.CourseId,lock:widget.lock,phone_number:Userinfo['phoneNumber']) :VideoSection ( CourseId: widget.CourseId,lock:widget.lock,phone_number:Userinfo['phoneNumber']): DescriptionSection(description:widget.description),
        ],):Center(child: Column(
          children: [
            Container(height: MediaQuery.of(context).size.height/2,),
            CircularProgressIndicator(color: Colors.deepPurple),
          ],
        ),),
      ),
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
}