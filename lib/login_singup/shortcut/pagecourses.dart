import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graduate/login_singup/auth/login.dart';
import '../../Edit/edit_course.dart';
import '../../course_screen.dart';
import '../../main.dart';
import '../auth/token_manager.dart';
import 'customappbar.dart';
import 'package:http/http.dart' as http;
class PageCourses extends StatefulWidget
{
  final String TeacherId;
  const PageCourses({super.key, required this.TeacherId});
  @override
  State<PageCourses> createState() => _PageCoursesState();
}
class _PageCoursesState extends State<PageCourses> {
  late List<dynamic> CourseInfo;
  late bool isloaded=false;
  late bool isempty =false;
  void initState()
  {
    super.initState();
    _loadTeacherInfo();
  }
  Future<void> _loadTeacherInfo() async {
    final teacherInfo = await getCourse(widget.TeacherId);
    if (teacherInfo.isNotEmpty) {
      setState(() {
        CourseInfo = teacherInfo;
      });
      setState(() {
        isloaded=true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return   ListView(
      children: [
        Container(
            padding: const EdgeInsets.only(top: 15,left: 15,right: 15),
            decoration: BoxDecoration(
              color: Colors.indigoAccent[400],
              borderRadius: const BorderRadius.only(bottomLeft:Radius.circular(20),bottomRight: Radius.circular(20)),
            ),
            child: Column(
              children: [
                CustomAppBar(),
                const SizedBox(height: 10,),
                const Padding(padding: EdgeInsets.only(left: 3,bottom: 15),
                  child: Text("Courses",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600,letterSpacing: 1,wordSpacing: 2,color: Colors.white),),
                ),
              ],
            )),
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
                    MaterialPageRoute(builder: (context) => CourseScreen(CourseId:CourseInfo[index]['id'], Courseimage: CourseInfo[index]['image'], Coursetitle: CourseInfo[index]['title'], lock: true,price: CourseInfo[index]['price'].toString(), description: CourseInfo[index]['description'],)),
                  );
                },
                onLongPress: (){
                  if(isadmin)
                  {
                    showDialog(context: context, builder: (context) =>
                        AlertDialog(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(onPressed:(){
                                showDialog(context: context, builder: (context) =>
                                    AlertDialog(content: MaterialButton(onPressed: (){},child: Text("تاكيد الحذف",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,letterSpacing: 1),),))
                                );
                              }, icon: Icon(Icons.delete,color: Colors.red,)),
                              IconButton(onPressed: (){
                                Navigator.of(context).push(MaterialPageRoute(builder:(context) => EditCourse(),));
                              }, icon: Icon(Icons.edit,color: Colors.indigoAccent[400],)),
                            ],
                          ),
                        ),);
                  }
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
                        CourseInfo[index]['price'].toString(),
                        style: TextStyle(fontSize: 15, fontWeight:  FontWeight.bold),
                      )
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
        Container(child: isempty?const Center(child: Text("لا توجد كورسات",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),)):null)
      ],
    );
  }
  Future<List<dynamic>> getCourse(String instructorId) async {
    try {
      var response = await ApiClient().getAuthenticatedRequest(
          context, "/api/Course/instructor/$instructorId");
      if (response?.statusCode == 200) {
        final List<dynamic> courseList = json.decode(response!.body);
        print(response.body);
        return courseList;
      } else {
        setState(() {
          isempty = true;
        });

        return [response!.statusCode];
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      return [];
    }
  }

}