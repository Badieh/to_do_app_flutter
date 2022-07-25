import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/modules/archive_screen.dart';
import 'package:to_do_app/modules/done_screen.dart';
import 'package:to_do_app/modules/tasks_screen.dart';
import 'package:to_do_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List screens = [
    const tasks_Screen(),
    const done_Screen(),
    const archive_Screen()
  ];
  List titles = ['Tasks', 'Done', 'Archived'];
  int currnet_index = 0;

  void changeIndex(int index) {
    currnet_index = index;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  Future<void> create_Db() async {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT ,date TEXT ,time TEXT,status TEXT)')
          .then((value) => print('table created succesfuly'))
          .catchError((error) => print('error when creating a table : $error'));
    }, onOpen: (database) {
      print('database opened');
      getDataFromDatabase(database);
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  Future insert_to_Db({required title, required date, required time}) async {
    return await database.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES ("$title","$date","$time","new")')
          .then((value) {
        print('$value : Record inserted successfully');
        emit(AppInsertToDatabaseState());

        getDataFromDatabase(database);
      }).catchError((error) {
        print('error on inserting a record : $error');
      });
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDatabaseLoadingState());

    database.rawQuery('SELECT * FROM tasks').then((value) {
      print(value);
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateDatabaseStatus({required String status, required int id}) async {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteDatabaseRecord({required int id}) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseRecordState());
    });
  }

  bool isShowBottomSheet = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheet({required bool isShow, required IconData icon}) {
    isShowBottomSheet = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
