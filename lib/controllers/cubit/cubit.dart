import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/controllers/cubit/states.dart';

import '../../models/task.dart';
import '../../shared/network/local/db_helper.dart';
class TodoCubit extends Cubit<TodoStates>{

  TodoCubit(): super(TodoInitialState());

   static TodoCubit   get(context)=>BlocProvider.of(context);


  var taskList =<Task>[];

  Future<int> addTask({Task? task}) async{
    return await DbHelper.insert(task);
  }

  void getTasks() async {
    List<Map<String,dynamic>> tasks =await DbHelper.query();
    taskList.addAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

}