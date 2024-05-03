import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/shared/theme/themes.dart';

import '../shared/const/dimensions.dart';
import '../shared/services/theme_services.dart';
class NotifiedScreen extends StatelessWidget {
  final String? label;
  const NotifiedScreen({Key? key,required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        backgroundColor:  context.theme.backgroundColor,
        elevation: 0,
        leading: IconButton(
           icon: Icon(
               Icons.arrow_back,
               color: Get.isDarkMode ? Colors.white : Colors.black,
               size: Dimensions.iconSize20,
           ),
           onPressed: (){
             Get.back();
           },
        ),
      ),
      body: Center(
        child: Padding(
          padding:  EdgeInsets.all(Dimensions.height20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Hello There',style: titleStyle,),
              SizedBox(height: Dimensions.height20,),
              Text(
                'You have a new reminder',
                style: TextStyle(
                    color: Get.isDarkMode?Colors.grey[500]:Colors.grey[300],
                    fontSize: Dimensions.fontSize16

                ),
              ),
              SizedBox(height: Dimensions.height55,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: Dimensions.width14),
                height: MediaQuery.of(context).size.height*0.60,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: primaryClr,
                  borderRadius: BorderRadius.circular(Dimensions.radius50)
                ),
                child: Padding(
                  padding:  EdgeInsets.all(Dimensions.height30),
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildItem('Title', label!.split('|')[0], Icons.text_format),
                    _buildItem('Description', label!.split('|')[1], Icons.description),
                    _buildItem('Time',label!.split('&')[1], Icons.timer)
                  ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
 _buildItem(String title,String desc,IconData iconData){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
           iconData,
            size: Dimensions.iconSize40,
            color: Colors.white,
          ),
          SizedBox(width: Dimensions.width12,),
          Text(
            title,
            style: TextStyle(
                color:Colors.white,
                fontSize: Dimensions.fontSize26
            ),
          ),

        ],
      ),
        SizedBox(height: Dimensions.height10,),
        Text(
          desc,
          style: TextStyle(
            color: Colors.white,
            fontSize: Dimensions.fontSize16,
          ),
        ),
        SizedBox(height: Dimensions.height20,),],
    );
 }
}
