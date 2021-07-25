import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget defaultFormField({
  @required TextInputType? type,
  @required TextEditingController? controller,
  bool isPassword = false,
  @required String? label,
  @required String? Function(String? x)? validate,
  void Function(String? x)? onSubmit,
  void Function(String? x)? onChanged,
  void Function()? onTap,
  @required IconData? prefix,
  IconData? suffix,
}) {
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
      suffixIcon: Icon(suffix != null ? suffix : null),
      border: OutlineInputBorder(),
    ),
  );
}

Widget defaultButton({
  @required String? text,
  Color background = Colors.blue,
  double width = double.infinity,
  @required Function? function,
  bool isUpperCase = true,
  double radius = 0.0,
}) {
  return Container(
    width: width,
    decoration: BoxDecoration(
        color: background, borderRadius: BorderRadius.circular(radius)),
    child: MaterialButton(
      onPressed: () => function,
      child: Text(
        isUpperCase ? text!.toUpperCase() : text!,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}

Widget buildTaskItem(Map tasks, BuildContext context) {
  return Dismissible(
    key: Key(tasks['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(tasks['time']),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tasks['title'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  tasks['date'],
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).updateData(status: 'done', id: tasks['id']);
            },
            icon: Icon(Icons.check_box),
            color: Colors.green,
          ),
          SizedBox(
            width: 20,
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).updateData(status: 'archived', id: tasks['id']);
            },
            icon: Icon(Icons.archive),
            color: Colors.black45,
          ),
        ],
      ),
    ),
    onDismissed: (_){
      AppCubit.get(context).deleteData(id: tasks['id']);
    },
  );
}

Widget loadingItem(){
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu,size: 100,color: Colors.grey,),
        Text('No Tasks Yet, Please Add Some Tasks',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.grey),)
      ],
    ),
  );
}
