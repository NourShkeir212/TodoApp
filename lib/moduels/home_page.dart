import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controllers/cubit/cubit.dart';
import 'package:todo_app/controllers/task_controller.dart';
import 'package:todo_app/moduels/add_task_bar.dart';
import 'package:todo_app/shared/services/notifcation_services.dart';
import 'package:todo_app/shared/services/theme_services.dart';
import 'package:todo_app/shared/theme/themes.dart';
import 'package:todo_app/shared/widget/button.dart';
import '../models/task.dart';
import '../shared/const/dimensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../shared/widget/task_tile.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  var notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.theme.backgroundColor,
        appBar: _defaultAppBar(),
        body: Column(
          children: [
            _addTaskBar(),
            _addDateBar(),
            SizedBox(height: Dimensions.height10,),
            _showTasks(),
            //  _showTasks(),
          ],
        )
    );
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose=false,
    required BuildContext context,
}){
   return GestureDetector(
     onTap: onTap,
     child: Container(
       margin: EdgeInsets.symmetric(vertical: Dimensions.height4),
       height: Dimensions.height55,
       width: MediaQuery.of(context).size.width*0.9,
       decoration: BoxDecoration(
           color: isClose==true?Colors.transparent:clr,
           border: Border.all(
             width:1,
             color: isClose==true?Get.isDarkMode?Colors.grey[600]!:Colors.grey[300]!:clr,
           ),
           borderRadius: BorderRadius.circular(Dimensions.radius20)
       ),
       child: Center(
         child: Text(
           label,style: isClose==true?
         titleStyle:titleStyle.copyWith(
             color: Colors.white
         ),
         ),
       ),
     ),
   );
  }
  _showBottomSheet(BuildContext context,Task task){
     Get.bottomSheet(
         Container(
           padding: EdgeInsets.only(top: Dimensions.height6),
           height:task.isCompleted==1?
           MediaQuery.of(context).size.height*0.24:
           MediaQuery.of(context).size.height*0.32,
           width: double.infinity,
           color:Get.isDarkMode? darkGreyClr:Colors.white,
           child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
              Container(
                height: Dimensions.height6,
                width: Dimensions.width120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius10),
                  color: Get.isDarkMode?Colors.grey[600]:Colors.grey[300]
                ),
              ),
              const Spacer(),
              task.isCompleted==1?Container():
              _bottomSheetButton(
                  label: 'Task Completed',
                  onTap: (){
                    _taskController.markTaskCompleted(task.id!);
                      Get.back();
                  },
                  clr: primaryClr,
                  context:context
              ),
              // SizedBox(height: Dimensions.height6,),
               _bottomSheetButton(
                   label: 'Delete Task',
                   onTap: (){
                     _taskController.delete(task);
                     Get.back();
                   },
                   clr: Colors.red[300]!,
                   context:context
               ),
               SizedBox(height: Dimensions.height20,),
               _bottomSheetButton(
                   label: 'Close',
                   onTap: (){
                     Get.back();
                   },
                   clr: Colors.black,
                   isClose: true,
                   context:context
               ),
               SizedBox(height: Dimensions.height10,)
             ],
           ),
         ),
     );
  }

  _addDateBar() {
    return Container(
      margin: EdgeInsets.only(
          top: Dimensions.width20, left: Dimensions.width20),
      child: DatePicker(
        DateTime.now(),
        height: Dimensions.height100,
        width: Dimensions.width80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: Dimensions.fontSize20,
              fontWeight: FontWeight.w600,
              color: Colors.grey
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: Dimensions.fontSize16,
              fontWeight: FontWeight.w600,
              color: Colors.grey
          ),
         ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: Dimensions.fontSize14,
              fontWeight: FontWeight.w600,
              color: Colors.grey
          ),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _defaultAppBar() {
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
        },
        child: Icon(
          Get.isDarkMode ? Icons.nightlight_rounded : Icons.wb_sunny_outlined,
          color: Get.isDarkMode ? Colors.white : Colors.black,
          size: Dimensions.iconSize20,
        ),
      ),
      actions: [
        Icon(
          Icons.person,
          color: Get.isDarkMode ? Colors.white : Colors.black,
          size: Dimensions.iconSize20,
        ),
        SizedBox(width: Dimensions.width20,)
      ],
    );
  }

  _addTaskBar() {
    return Container(
      margin: EdgeInsets.only(
        left: Dimensions.width20,
        right: Dimensions.width20,
        top: Dimensions.height10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                'Today',
                style: headingStyle,
              ),
            ],
          ),
          MyButton(
              label: '+ Add Task',
              onTap: () async {
                await Get.to(const AddTaskScreen());
                _taskController.getTasks();
              }
          ),
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.separated(
          physics:const BouncingScrollPhysics(),
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index) {
            if (kDebugMode) {
              print(_taskController.taskList.length);
            }
            Task task =_taskController.taskList[index];
            DateTime date= DateFormat.jm().parse(task.startTime.toString());
            var myTime =DateFormat('HH:mm').format(date);
            notifyHelper.scheduledNotification(
                int.parse(myTime.toString().split(':')[0]),
                int.parse(myTime.toString().split(':')[1]),
                task
            );
            if(task.repeat=='Daily') {
              DateTime date= DateFormat.jm().parse(task.startTime.toString());
              var myTime =DateFormat('HH:mm').format(date);
              notifyHelper.scheduledNotification(
                int.parse(myTime.toString().split(':')[0]),
                int.parse(myTime.toString().split(':')[1]),
                task
              );
              if (kDebugMode) {
                print(myTime);
              }
              return AnimationConfiguration.staggeredList(

                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(
                                task
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              );
            }
            if(task.date==DateFormat.yMd().format(_selectedDate)){

              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(
                                task
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              );
            }else{
              return Container();
            }
          },
          separatorBuilder: (_, index) {
            return SizedBox(height: Dimensions.height4,);
          },
        );
      }),
    );
  }
}


