import 'package:flutter/material.dart';


class CustomAppBar extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
         Icon(Icons.dashboard,size: 30,color: Colors.white,),
         Icon(Icons.notifications,size: 30,color: Colors.white,),
       ],
     );
  }

}