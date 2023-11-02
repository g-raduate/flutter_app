import 'package:flutter/material.dart';


class CustomTextFormField extends StatelessWidget
{
  final bool number;
  final bool check;
  final bool isvalidator;
  final String hinttext;
  final TextEditingController mycontroler;
  const CustomTextFormField({super.key, required this.hinttext ,required this.mycontroler, required this.check, required this.number, required this.isvalidator});
  @override
  Widget build (BuildContext context)
  {
    return TextFormField(
      autovalidateMode: isvalidator?AutovalidateMode.onUserInteraction:null,
      validator: isvalidator?
      (value){
        if(value==null ||value.isEmpty)
          return 'يرجى ادخل النص هنا';
        else if (!isValidEmail(value)) {
          return 'يجب ادخال بريد صالح';
        }
        else
          return null;
      }:null,
      obscureText: check,
      controller: mycontroler,
        keyboardType:number==true?  TextInputType.number:null,
      decoration: InputDecoration(
          hintText: hinttext,
          hintStyle: TextStyle(fontSize: 16,color: Colors.grey[500]),
          contentPadding: const EdgeInsets.symmetric(vertical: 2,horizontal: 20),
          filled: true,
          fillColor: Colors.grey[80],
          border: OutlineInputBorder(
            borderRadius:BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.grey),
          )
      ),
    );
  }
  bool isValidEmail(String email) {
    // Regular expression to match email addresses
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
    );
    return emailRegex.hasMatch(email);
  }
}