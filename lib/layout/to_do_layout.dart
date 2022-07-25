import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/modules/archive_screen.dart';
import 'package:to_do_app/modules/done_screen.dart';
import 'package:to_do_app/modules/tasks_screen.dart';
import 'package:to_do_app/shared/components/components.dart';
import 'package:to_do_app/shared/components/constants.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';

class homeScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..create_Db(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertToDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currnet_index],
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            body: ConditionalBuilder(
                condition: state is! AppGetDatabaseLoadingState,
                builder: (context) => cubit.screens[cubit.currnet_index],
                fallback: (context) =>
                    const Center(child: CircularProgressIndicator())),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Task'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.done_outline_sharp), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: 'Archive'),
              ],
              onTap: (index) {
                cubit.changeIndex(index);
              },
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currnet_index,
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.fabIcon),
              onPressed: () {
                if (cubit.isShowBottomSheet) {
                  if (formKey.currentState!.validate()) {
                    cubit.insert_to_Db(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text);
                    //cubit.changeBottomSheet(isShow: false, icon: Icons.edit);
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          //color: Colors.grey[100],
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                  label: 'Title',
                                  formController: titleController,
                                  keyboardType: TextInputType.text,
                                  prefixIcon: Icons.description_outlined,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Title can\'t be empty';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                defaultFormField(
                                    label: 'Date',
                                    formController: dateController,
                                    keyboardType: TextInputType.none,
                                    prefixIcon: Icons.date_range,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Date can\'t be empty';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime(2023))
                                          .then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    }),
                                const SizedBox(
                                  height: 10,
                                ),
                                defaultFormField(
                                    label: 'Time',
                                    formController: timeController,
                                    keyboardType: TextInputType.none,
                                    prefixIcon: Icons.watch_later_outlined,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Time can\'t be empty';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value!.format(context);
                                      });
                                    }),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20,
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheet(isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheet(isShow: true, icon: Icons.add);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
