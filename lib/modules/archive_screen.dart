import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';

import '../shared/components/components.dart';

class archive_Screen extends StatefulWidget {
  const archive_Screen({Key? key}) : super(key: key);

  @override
  State<archive_Screen> createState() => _archive_ScreenState();
}

class _archive_ScreenState extends State<archive_Screen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List<Map> tasks = AppCubit.get(context).archivedTasks;
        return taskBulider(tasks: tasks, dismissToDelete: true,tasksAndDone: false);
      },
    );
  }
}
