import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/shared/components/components.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';

class tasks_Screen extends StatefulWidget {
  const tasks_Screen({Key? key}) : super(key: key);

  @override
  State<tasks_Screen> createState() => _tasks_ScreenState();
}

class _tasks_ScreenState extends State<tasks_Screen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List<Map> tasks = AppCubit.get(context).newTasks;
        return taskBuilder(tasks: tasks );
      },
    );
  }
}
