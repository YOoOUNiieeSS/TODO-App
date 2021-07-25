import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit,AppStates>(
      builder: (context,state)=>Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(cubit.titles[cubit.currentIndex]),
        ),
        body: cubit.tasks.length==0? Center(child: CircularProgressIndicator()):cubit.screens[cubit.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: cubit.currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (i) => cubit.changeIndex(i),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
            BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline), label: 'Done'),
            BottomNavigationBarItem(
                icon: Icon(Icons.archive_outlined), label: 'Archived'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (cubit.isBottomSheetShown) {
              if(formKey.currentState!.validate()){
                cubit.insertToDatabase(
                    title: titleController.text,
                    date: dateController.text,
                    time: timeController.text).then((value) {
                  cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                });
              }
            } else {
              scaffoldKey.currentState!.showBottomSheet((context) => Container(
                color: Colors.white,
                padding: EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      defaultFormField(
                          controller: titleController,
                          type: TextInputType.text,
                          label: 'Task Title',
                          prefix: Icons.title,
                          validate: (String? v) {
                            if (v!.isEmpty)
                              return 'title must not be empty';
                            else
                              return null;
                          }),
                      SizedBox(height: 15,),
                      defaultFormField(
                          onTap: (){
                            showTimePicker(context: context, initialTime: TimeOfDay.now())
                                .then((value){
                              timeController.text=value!.format(context).toString();
                            });
                          },
                          controller: timeController,
                          type: TextInputType.datetime,
                          label: 'Task Time',
                          prefix: Icons.watch_later_outlined,
                          validate: (String? v) {
                            if (v!.isEmpty)
                              return 'time must not be empty';
                            else
                              return null;
                          }),
                      SizedBox(height: 15,),
                      defaultFormField(
                          onTap: (){
                            showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.parse('2021-12-12'))
                                .then((value){
                              dateController.text=DateFormat.yMMMd().format(value!);
                            });
                          },
                          controller: dateController,
                          type: TextInputType.datetime,
                          label: 'Task Date',
                          prefix: Icons.calendar_today_outlined,
                          validate: (String? v) {
                            if (v!.isEmpty)
                              return 'date must not be empty';
                            else
                              return null;
                          }),
                    ],
                  ),
                ),
              ),
                elevation: 20,
              ).closed.then((value) {
                cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
              });
              cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
            }
          },
          child: Icon(cubit.fabIcon),
        ),
      ),
      listener: (context,state){
        if(state is AppInsertDatabaseState)Navigator.pop(context);
      },
    );
  }
}
