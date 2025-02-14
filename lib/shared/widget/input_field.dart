import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/shared/const/dimensions.dart';
import 'package:todo_app/shared/theme/themes.dart';


class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final Widget? widget;
  final TextEditingController? controller;

  const MyInputField({Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: Dimensions.height16
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              title,
            style: titleStyle,
          ),
          Container(
            margin: EdgeInsets.only(top: Dimensions.height8),
            height: Dimensions.height52,
            padding: EdgeInsets.only(left: Dimensions.width14),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0
              ),
              borderRadius: BorderRadius.circular(Dimensions.radius12)
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: widget==null?false:true,
                    autofocus:  false,
                    cursorColor: Get.isDarkMode?Colors.grey[100]:Colors.grey[700],
                    controller: controller,
                    style: subTitleStyle,
                    decoration: InputDecoration(
                      hintText:hint,
                      hintStyle: subTitleStyle,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.backgroundColor,
                          width: 0
                        )
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: context.theme.backgroundColor,
                              width: 0
                          )
                      ),
                    ),
                  ),
                ),
                widget==null?Container():Container(child: widget,)
              ],
            ),
          )
        ],
      ),
    );
  }
}

