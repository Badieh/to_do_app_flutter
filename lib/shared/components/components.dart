import 'package:flutter/material.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

Widget defaultFormField({
  required TextEditingController formController,
  required TextInputType keyboardType,
  required IconData prefixIcon,
  required String label,
  IconData? suffixIcon,
  VoidCallback? suffixPressed,
  bool isPass = false,
  required FormFieldValidator<String> validator,
  ValueChanged<String>? onFieldSubmitted,
  ValueChanged<String>? onChanged,
  GestureTapCallback? onTap,
}) =>
    TextFormField(
      controller: formController,
      keyboardType: keyboardType,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      validator: validator,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Colors.blue,
              )),
          label: Text(label),
          prefixIcon: Icon(prefixIcon),
          suffixIcon: IconButton(
            icon: Icon(suffixIcon),
            onPressed: suffixPressed,
          )),
    );

Widget buildTaskItem(
        {required Map model,
        context,
        bool dismissToDelete = false,
        bool tasksAndDone = true}) =>
    Dismissible(
      onDismissed: (direction) {
        dismissToDelete
            ? AppCubit.get(context).deleteDatabaseRecord(id: model['id'])
            : AppCubit.get(context)
                .updateDatabaseStatus(status: 'archive', id: model['id']);
      },
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              child: Text('${model['time']}'),
              radius: 35,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model['title']}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${model['date']}',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ]),
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
                onPressed: () {
                  print('value of taskand done is $tasksAndDone');
                  tasksAndDone
                      ? AppCubit.get(context)
                          .updateDatabaseStatus(status: 'done', id: model['id'])
                      : AppCubit.get(context)
                          .updateDatabaseStatus(status: 'new', id: model['id']);
                },
                icon: tasksAndDone
                    ? Icon(Icons.check_box, color: Colors.green)
                    : Icon(Icons.task, color: Colors.blue)),
          ],
        ),
      ),
    );

Widget taskBulider(
        {required List<Map> tasks,
        bool dismissToDelete = false,
        bool tasksAndDone = true}) =>
    ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) => ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(
              model: tasks[index],
              context: context,
              dismissToDelete: dismissToDelete,
              tasksAndDone: tasksAndDone),
          separatorBuilder: (context, index) => Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
          itemCount: tasks.length),
      fallback: (context) => Container(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.menu,
                  size: 100,
                  color: Colors.grey,
                ),
                Text('No tasks yet , add some',
                    style: TextStyle(fontSize: 30, color: Colors.grey)),
              ]),
        ),
      ),
    );
