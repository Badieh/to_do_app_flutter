import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/shared/components/components.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';

class done_Screen extends StatefulWidget {
  const done_Screen({Key? key}) : super(key: key);

  @override
  State<done_Screen> createState() => _done_ScreenState();
}

class _done_ScreenState extends State<done_Screen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List<Map> tasks = AppCubit.get(context).doneTasks;
        return taskBulider(tasks: tasks,tasksAndDone: false);
      },
    );
  }
}
