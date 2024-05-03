import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_app/moduels/home_page.dart';
import 'package:todo_app/shared/network/local/db_helper.dart';
import 'package:todo_app/shared/services/theme_services.dart';
import 'package:todo_app/shared/theme/themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'controllers/cubit/cubit.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.initDb();
  await GetStorage.init();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (context)=>TodoCubit()..getTasks(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Themes.light,
        themeMode: ThemeService().theme,
        darkTheme: Themes.dark,
        home: const HomePage(),
      ),
    );
  }
}
