import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  Database? database;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool isBottomSheetShown = false;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  IconData fabIcon = Icons.edit;

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocProvider(
      create: (context)=>AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
        builder: (context,state)=>Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
          ),
          body: tasks.length==0? Center(child: CircularProgressIndicator()):cubit.screens[cubit.currentIndex],
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
              if (isBottomSheetShown) {
                if(formKey.currentState!.validate()){
                  insertToDatabase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text).then((value) {
                    Navigator.pop(context);
                    titleController.clear();
                    timeController.clear();
                    dateController.clear();
                    fabIcon = Icons.edit;
                    tasks=value;
                    isBottomSheetShown = false;
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
                  isBottomSheetShown=false;
                  fabIcon = Icons.edit;
                });
                isBottomSheetShown = true;
                fabIcon = Icons.add;
              }
            },
            child: Icon(fabIcon),
          ),
        ),
        listener: (context,state){},
      ),
    );
  }

  void createDatabase() async {
    database = await openDatabase('todo.db', version: 1,
        onCreate: (database, version) {
      print('database created');
      database
          .execute(
              'CREATE TABLE Tasks (id INTEGER PRIMARY KEY , title TEXT , date TEXT , time TEXT , status TEXT)')
          .then((value) => print('table created'))
          .catchError((e) {
        print('error when creating table ${e.toString()}');
      });
    }, onOpen: (database) async {
      getDataFromDatabase(database).then((value) {
        tasks=value;
      });
      print('database opened');
    });
  }

  Future insertToDatabase({@required String? title,@required String? date,@required String? time,}) async{
    await database!.transaction((txn) =>
        txn.rawInsert(
            'INSERT INTO tasks (title, date, time, status) VALUES ("$title", "$date","$time","New")')
        .then((value) => {print('$value inserted successfully')})
        .catchError((e) {
      print('error ${e.toString()}');
    }));
  }

  Future<List<Map>> getDataFromDatabase(Database database)async{
    return  await database.rawQuery('SELECT * FROM tasks');
  }
}
