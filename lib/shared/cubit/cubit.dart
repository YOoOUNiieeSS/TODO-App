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
    'Archived Task9s',
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
  List<Map> tasks=[];
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
          getDataFromDatabase(database).then((value) {
            tasks=value;
            print(tasks);
            emit(AppGetDatabaseState());
          });
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
               getDataFromDatabase(database!).then((value) {
                 tasks=value;
                 print(tasks);
                 emit(AppGetDatabaseState());
               });
            })
            .catchError((e) {
          print('error ${e.toString()}');
        }));
  }

  Future<List<Map>> getDataFromDatabase(Database database)async{
    return  await database.rawQuery('SELECT * FROM tasks');
  }

  void changeBottomSheetState({
  required bool isShow,required IconData icon,
}){
    isBottomSheetShown=isShow;
    fabIcon=icon;
    emit(AppChangeBottomSheetState());
  }
}