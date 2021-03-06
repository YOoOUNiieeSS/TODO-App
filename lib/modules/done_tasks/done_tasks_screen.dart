import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class DoneTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        var tasks = AppCubit.get(context).doneTasks;
        return tasks.length==0?loadingItem():ListView.separated(
            itemBuilder: (context, index) =>
                buildTaskItem(tasks[index], context),
            separatorBuilder: (context, index) => Container(
                  color: Colors.grey[300],
                  width: double.infinity,
                  height: 1,
                  padding: EdgeInsetsDirectional.only(start: 20),
                ),
            itemCount: tasks.length);
      },
      listener: (context, state) {},
    );
  }
}
