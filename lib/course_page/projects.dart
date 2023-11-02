import 'package:flutter/material.dart';
import 'package:graduate/login_singup/auth/login.dart';
import '../add_data/new_project.dart';
import '../login_singup/shortcut/customappbar.dart';
import '../login_singup/shortcut/projectview.dart';
class Projects extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.indigoAccent[400],
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 3, bottom: 15),
                  child: Center(
                    child: Text(
                      "المشاريع",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        wordSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          ProjectView(check: true),
        ],
      ),
      floatingActionButton:isadmin? FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewProject(),));
        },
        child: Icon(Icons.add,),
      ):null,
    );
  }

}
