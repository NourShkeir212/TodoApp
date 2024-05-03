import 'package:flutter/material.dart';
import 'package:todo_app/shared/const/dimensions.dart';

  defaultAppBar({required Function function})
{
  return AppBar(
    leading: GestureDetector(
      onTap: () =>function,
      child:  Icon(
        Icons.nightlight_rounded,
        size: Dimensions.iconSize20,
      ),
    ),
    actions: [
     Icon(
       Icons.person,
       size: Dimensions.iconSize20,
     ),
      SizedBox(width: Dimensions.width20,)
    ],
  );
}