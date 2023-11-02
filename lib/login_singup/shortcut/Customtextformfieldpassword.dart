import 'package:flutter/material.dart';


class CustomTextFormFieldPassword extends StatelessWidget {
  final bool number;
  final bool check;
  final bool isvalidator;
  final String hinttext;
  final TextEditingController mycontroler;
  const CustomTextFormFieldPassword({
    super.key,
    required this.hinttext,
    required this.mycontroler,
    required this.check,
    required this.number,
    required this.isvalidator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: isvalidator ? AutovalidateMode.onUserInteraction : null,
      validator: isvalidator
          ? (value) {
        if (value == null || value.isEmpty) {
          return 'يرجى ادخال كلمة السر';
        } else if (value.length < 6 || value.length > 50) {
          return 'يجب أن تحتوي كلمة السر على 6 إلى 50 حرفًا';
        } else if (!containsNonAlphanumeric(value)) {
          return 'يجب أن تحتوي كلمة السر على رموز أو علامات مثل ! @ # % *';
        }else if (!containsUppercase(value)){
        return 'كلمة السر يجب ان تحتوي على حرف كبير';
        }
        else if ( !containsLowercase(value)) {
          return 'كلمة السر يجب ان تحتوي على حرف صغير';
        }
        else if (!containsDigit(value)){
          return 'كلمة السر يجب ان تحتوي على رقم';
        }
        else {
          return null;
        }
      }
          : null,
      obscureText: check,
      controller: mycontroler,
      keyboardType: number == true ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hinttext,
        hintStyle: TextStyle(fontSize: 16, color: Colors.grey[500]),
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
        filled: true,
        fillColor: Colors.grey[80],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  bool containsUppercase(String value) {
    return value.contains(RegExp(r'[A-Z]'));
  }

  bool containsLowercase(String value) {
    return value.contains(RegExp(r'[a-z]'));
  }

  bool containsDigit(String value) {
    return value.contains(RegExp(r'[0-9]'));
  }

  bool containsNonAlphanumeric(String value) {
    return value.contains(RegExp(r'[!@#\$%^&*()_+{}:;<>,.?~]'));
  }
}