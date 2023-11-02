import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graduate/course.dart';
import 'package:graduate/course_page/category.dart';
import 'package:graduate/course_page/free_coures.dart';
import 'package:graduate/course_page/meet.dart';
import 'package:graduate/course_page/mlazm.dart';
import 'package:graduate/course_page/projects.dart';
import 'package:graduate/login_singup/auth/token_manager.dart';
import 'package:graduate/login_singup/shortcut/customappbar.dart';
import 'package:graduate/screens.dart';
import 'login_singup/shortcut/projectview.dart';
class HomePage extends StatefulWidget
{
  final List<String> catNames;
  final List<Color> catColors ;
  final List<Icon> catIcons ;
  const HomePage({super.key, required this.catNames, required this.catColors, required this.catIcons});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
                       child: Text("Hi Programmer",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600,letterSpacing: 1,wordSpacing: 2,color: Colors.white),),
                     ),
                Container(
                  margin: const EdgeInsets.only(top: 5,bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: ("Search here...."),
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                    prefixIcon: const Icon(Icons.search,size: 25,)
                    ),

                  ),
                )
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.only(top: 20,left: 15,right: 15),
            child:Column(children: [
               GridView.builder(
                  itemCount:widget.catIcons.length,
                    shrinkWrap: true,
                    gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.1,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(children: [
                              InkWell(
                                child: Container(
                                 height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: widget.catColors[index],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: widget.catIcons[index],
                                  ),
                                ),
                                onTap: (){
                                  if (index==0) {
                                    Navigator.of(context).push(MaterialPageRoute(builder:(context) => Category1()));
                                  }
                                    else if (index==1) {
                                        setState(() {
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Screens(currentindex: 1),), (route) => false);
                                        });
                                      }
                                     else if (index==2) {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>FreeCourse()));
                                      }
                                      else  if (index==3) {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Mlazm()));
                                        }
                                       else  if (index==4) {
                                           Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Meet() ));
                                         }
                                         else   if (index==5) {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Projects()));
                                            }
                                      },
                              ),

                        const SizedBox(height: 10,),
                        Text(widget.catNames[index],style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.7)),)
                      ],
                      );
                    },
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  const Text("الدورات",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 23),),
                  InkWell(
                      onTap: (){
                    setState(() {
                   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Screens(currentindex: 1),), (route) => false);
                         });
                      },
                      child: Text("مشاهدة المزيد",style: TextStyle(color: Colors.indigoAccent[400],fontWeight: FontWeight.w500,fontSize: 18),)),
                ],
              ),
              const SizedBox(height: 10,),
            const Course(),
              const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    const Text("المشاريع",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 23),),
                    InkWell(
                        onTap: (){
                      setState(() {
                     Navigator.of(context).push(MaterialPageRoute(builder: (context) => Projects(),));
                           });
                        },
                        child: Text("مشاهدة المزيد",style: TextStyle(color: Colors.indigoAccent[400],fontWeight: FontWeight.w500,fontSize: 18),)),
                  ],
                ),
            const SizedBox(height: 10,),
             const ProjectView(check:false)
            ],
            ),
          ),
        ],
      );
  }
}