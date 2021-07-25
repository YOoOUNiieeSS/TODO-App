import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
}