import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget
{
  final TextEditingController controller;
  final IconData data;
  final String hintText;
  bool isObsecure = true;



  CustomTextField(
      {Key key, this.controller, this.data, this.hintText,this.isObsecure}
      ) : super(key: key);



  @override
  Widget build(BuildContext context)
  {
    return Container
    (

      decoration:BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),

      ),

    padding: EdgeInsets.all(8.0),
    margin: EdgeInsets.all(10.0),
    child: TextFormField(
      controller: controller,
      obscureText: isObsecure,
      cursorColor: Theme.of(context).primaryColor,
      decoration:InputDecoration(
        border: InputBorder.none,
        prefixIcon:Icon(
          data,
          color: Colors.black,
      ),
      focusColor: Colors.black,
      hintText:hintText,
    ),
    )
    );
  }
}
