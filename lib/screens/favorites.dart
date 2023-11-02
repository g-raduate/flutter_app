import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graduate/course_screen.dart';
import 'package:graduate/login_singup/auth/login.dart';
import 'package:graduate/login_singup/shortcut/customappbar.dart';
import 'package:http/http.dart' as http;

import '../login_singup/auth/token_manager.dart';
import '../main.dart';
class Favorites extends StatefulWidget
{

  @override
  State<Favorites> createState() => _Favorites();
}

class _Favorites extends State<Favorites> {
  late List<dynamic> CourseInfo;
  late bool isloaded=false;
  late bool isempty =false;
  void initState()
  {
    super.initState();
    _loadTeacherInfo();
  }
  Future<void> _loadTeacherInfo() async {
    final teacherInfo = await getCourse();
    if (teacherInfo.isNotEmpty) {
      setState(() {
        CourseInfo = teacherInfo;
      });
      setState(() {
        isloaded=true;
      });
    }
    else
      {
        setState(() {
          isloaded=true;
        });
        setState(() {
          isempty=true;
        });
      }
  }
  @override
  Widget build (BuildContext context)
  {
    return ListView(

      children: [
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
                child: Center(child: Text("المشتريات",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600,letterSpacing: 1,wordSpacing: 2,color: Colors.white),)),
              ),
              ]
          ),
        ),
        const SizedBox(height: 20,),
        Center(
          child:isloaded? GridView.builder(
            itemCount:isempty?0:CourseInfo.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: (MediaQuery.of(context).size.height - 75) / 960,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CourseScreen(CourseId:CourseInfo[index]['id'], Courseimage: CourseInfo[index]['image'], Coursetitle: CourseInfo[index]['title'], lock: false,price: CourseInfo[index]['price'].toString(),description: CourseInfo[index]['description'])),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFFF5F3FF),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.network(CourseInfo[index]['image'], width: 100, height: 100),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        CourseInfo[index]['title'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.6)),
                      ),
                      const SizedBox(height: 10),
                Text(
                  "تم الشراء",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.6))),
                    ],
                  ),
                ),
              );
            },
          ):Center(child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height/1.8,),
              CircularProgressIndicator(),
            ],
          )),
        ),
        Container(child: isempty?Center(child: Text("لا توجد كورسات",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),)):null)
      ],
    );
  }
  Future<List<dynamic>> getCourse() async {
    try {
      var response = await ApiClient().getAuthenticatedRequest(context,"/api/UserCourses");
      if (response!.statusCode == 200) {
        final List<dynamic> courseList = json.decode(response.body);
        print(response.body);
        return courseList;
      } else if(response!.statusCode == 404)
      {
        setState(() {
          isempty=true;
        });
        return [response.statusCode];
      }
      else
        {
          return [response.statusCode];
        }
    } catch (e) {
      // Handle any exceptions that occur during the request
      print("Error fetching courses: $e");
      return [];
    }
  }
}
