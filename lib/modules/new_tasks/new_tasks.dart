import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';

class NewTaskScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context,index)=>buildTaskItem(tasks[index]),
        separatorBuilder: (context,index)=> Container(
          color: Colors.grey[300],
          width: double.infinity,
          height: 1,
          padding: EdgeInsetsDirectional.only(start: 20),
        ),
        itemCount: tasks.length
    );
  }
}
