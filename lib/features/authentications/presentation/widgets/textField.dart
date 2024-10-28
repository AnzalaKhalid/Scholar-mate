import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final IconData icon;
  
  const CustomTextField({super.key, 
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.icon = Icons.text_fields,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 300,
      child: TextField(
        // controller: controller,
        // obscureText: isPassword, 
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon,color: Colors.purple,),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
