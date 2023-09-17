import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget{
  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  const CustomTextField({super.key, required this.controller, required this.hintText,this.maxLines=1});

  @override
  Widget build(BuildContext context){
    return TextFormField(
      controller:  controller,
      // controller is passed from the auth_screen and should be received on the constructor,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black38,
          ),
        )
      ),
      validator:(value){
        if(value == null || value.isEmpty){
          return 'Enter your $hintText'; // if any error
        }
        return null; // if no error
      },
      maxLines: maxLines,
    );
  }
}