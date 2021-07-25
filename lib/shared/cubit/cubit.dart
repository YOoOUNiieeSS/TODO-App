import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit():super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  List<Widget> screens = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen()
  ];
  int currentIndex = 0;

  void changeIndex(int i){
    currentIndex=i;
    emit(AppChangeBottomNavBarState());
  }

  Database? database;
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];
  IconData fabIcon = Icons.edit;
  bool isBottomSheetShown = false;

  void createDatabase(){
    openDatabase('todo.db', version: 1,
        onCreate: (database, version) {
          print('database created');
          database.execute(
              'CREATE TABLE Tasks (id INTEGER PRIMARY KEY , title TEXT , date TEXT , time TEXT , status TEXT)')
              .then((value) => print('table created'))
              .catchError((e) {
            print('error when creating table ${e.toString()}');
          });
        }, onOpen: (database) async {
          getDataFromDatabase(database);
          print('database opened');
        }).then((value){
          database=value;
          emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({@required String? title,@required String? date,@required String? time,}) async{
    await database!.transaction((txn) =>
        txn.rawInsert(
            'INSERT INTO tasks (title, date, time, status) VALUES ("$title", "$date","$time","New")')
            .then((value) {
               print('$value inserted successfully');
               emit(AppInsertDatabaseState());
               getDataFromDatabase(database!);
            })
            .catchError((e) {
          print('error ${e.toString()}');
        }));
  }

  void getDataFromDatabase(Database database){
    database.rawQuery('SELECT * FROM tasks').then((value) {
      newTasks=[];
      archivedTasks=[];
      doneTasks=[];
      value.forEach((element) {
        if(element['status']=='New')newTasks.add(element);
        else if(element['status']=='done')doneTasks.add(element);
        else archivedTasks.add(element);
      });
      print(newTasks);
      emit(AppGetDatabaseState());
    });
  }

  void updateData({
  required String status,required int id
}){
    database!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
          emit(AppUpdateDatabaseState());
          getDataFromDatabase(database!);
    });
}

  void deleteData({
    required int id
  }){
    database!.rawDelete(
        'DELETE FROM tasks WHERE id = ?',
        [id]).then((value) {
      emit(AppDeleteDatabaseState());
      getDataFromDatabase(database!);
    });
  }
  void changeBottomSheetState({
  required bool isShow,required IconData icon,
}){
    isBottomSheetShown=isShow;
    fabIcon=icon;
    emit(AppChangeBottomSheetState());
  }
}