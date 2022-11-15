import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final IconData icon;
  final String hint;
  final TextInputType type;
  final bool obscureText;
  final TextEditingController controller;

  const CustomTextField({
    super.key, 
    required this.icon, 
    required this.hint, 
    required this.type,
    this.obscureText=false,
    required this.controller,
    
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText : obscureText,
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        prefixIcon: Icon( icon, color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none
        ),
      ),
      validator: (value){
        if (type == TextInputType.emailAddress){

          String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regExp  = RegExp(pattern);

          return regExp.hasMatch(value ?? '')
            ? null
            : 'El correo no es correcto';
        }else if (obscureText){
          if (value!= null && value.length >= 6) return null;
            return 'La contraseña debe ser de al menos 6 caracteres';
        }
        return null;
      }
    );
  }
}