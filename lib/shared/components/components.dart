import 'package:flutter/material.dart';

Widget defaultFormField({
  @required TextInputType? type,
  @required TextEditingController? controller,
  bool isPassword=false,
  @required String? label,
  @required String? Function(String? x)? validate,
  void Function(String? x)? onSubmit,
  void Function(String? x)? onChanged,
  void Function()? onTap,
  @required IconData? prefix,
  @required IconData? suffix,
}){
  return TextFormField(
    onTap: onTap,
    keyboardType: type,
    controller: controller,
    obscureText: isPassword,
    validator: validate,
    onFieldSubmitted: onSubmit,
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefix),
      suffixIcon: Icon(suffix!=null?suffix:null),
      border: OutlineInputBorder(),
    ),
  );
}

Widget defaultButton({
  @required String? text,
  Color background=Colors.blue,
  double width=double.infinity,
  @required Function? function,
  bool isUpperCase=true,
  double radius=0.0,
}){
  return Container(
    width: width,
    decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius)
    ),
    child: MaterialButton(
      onPressed: ()=>function,
      child: Text(isUpperCase?text!.toUpperCase():text!,style: TextStyle(color: Colors.white),),
    ),
  );
}

Widget buildTaskItem(Map tasks){
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40,
          child: Text(tasks['time']),
        ),
        SizedBox(width: 20,),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tasks['title'],
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
            Text(
              tasks['date'],
              style: TextStyle(
                  color: Colors.grey
              ),
            ),
          ],)
      ],
    ),
  );
}