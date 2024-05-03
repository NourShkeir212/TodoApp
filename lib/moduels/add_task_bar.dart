import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controllers/task_controller.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/shared/const/dimensions.dart';
import 'package:todo_app/shared/theme/themes.dart';
import 'package:todo_app/shared/widget/button.dart';
import 'package:todo_app/shared/widget/input_field.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  String _selectedRepeat = 'None';
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];
  List<Color> dotsColor = [
    primaryClr,
    pinkClr,
    yellowClr
  ];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _defaultAppBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(left: Dimensions.width20,
              right: Dimensions.width20,
              top: Dimensions.height20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              MyInputField(
                title: 'Title',
                hint: 'Enter your title',
                controller: _titleController,
              ),
              MyInputField(
                title: 'Note',
                hint: 'Enter your note',
                controller: _noteController,
              ),
              MyInputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                    onPressed: () {
                      _getDateFromUser(context);
                    },
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    )
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: MyInputField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime: true);
                          },
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          )
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.width12,),
                  Expanded(
                    child: MyInputField(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime: false);
                          },
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          )
                      ),
                    ),
                  ),
                ],
              ),
              MyInputField(
                title: 'Remind',
                hint: "$_selectedRemind minutes early",
                widget: Container(
                  margin: EdgeInsets.only(right: Dimensions.width12),
                  child: DropdownButton(
                    borderRadius: BorderRadius.circular(Dimensions.radius10),
                    dropdownColor: const Color.fromRGBO(69,92,103,1),
                    underline: Container(height: 0,),
                    items: const [
                      DropdownMenuItem(
                        child: Text('5',style: TextStyle(color: Colors.white),),
                        value: '5',
                      ),
                      DropdownMenuItem(
                        child: Text('10',style: TextStyle(color: Colors.white),),
                        value: '10',
                      ),
                      DropdownMenuItem(
                        child: Text('15',style: TextStyle(color: Colors.white),),
                        value: '15',
                      ),
                      DropdownMenuItem(
                        child: Text('20',style: TextStyle(color: Colors.white),),
                        value: '20',
                      ),
                    ],
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: Dimensions.iconSize32,
                    elevation: 4,
                    style: subTitleStyle,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRemind = int.parse(newValue!);
                      });
                    },
                  ),
                ),
              ),
              MyInputField(
                title: 'Repeat',
                hint: _selectedRepeat,
                widget: Container(
                  margin: EdgeInsets.only(right: Dimensions.width12),
                  child: DropdownButton(
                    borderRadius: BorderRadius.circular(Dimensions.radius10),
                    dropdownColor: const Color.fromRGBO(69,92,103,1),
                    underline: Container(height: 0,),
                    items: const [
                      DropdownMenuItem(
                        child: Text(
                          'None',
                          style: TextStyle(color: Colors.white),
                        ),
                        value: 'None',
                      ),
                      DropdownMenuItem(
                        child: Text(
                          'Daily',
                          style: TextStyle(color: Colors.white),
                        ),
                        value: 'Daily',
                      ),
                      DropdownMenuItem(
                        child: Text(
                          'Weekly',
                          style: TextStyle(color: Colors.white),
                        ),
                        value: 'Weekly',
                      ),
                      DropdownMenuItem(
                        child: Text(
                          'Monthly',
                          style: TextStyle(color: Colors.white),
                        ),
                        value: 'Monthly',
                      ),
                    ],
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: Dimensions.iconSize32,
                    elevation: 4,
                    style: subTitleStyle,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRepeat = newValue!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height18,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _colorPallete(),
                  MyButton(
                      label: 'Create Task', onTap: () {
                    _validateDate();
                  })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _addTaskToDb() async {
    int value = await _taskController.addTask(
        task: Task(
          note: _noteController.text,
          title: _titleController.text,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          remind: _selectedRemind,
          repeat: _selectedRepeat,
          color: _selectedColor,
          isCompleted: 0,
        )
    );
    print('My id is '"$value");
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
          'Required',
          'All fields are required',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: const Icon(
            Icons.warning_amber_outlined,
            color: Colors.amber,
          )
      );
    }
  }

  _defaultAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back,
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

  _getDateFromUser(BuildContext context) async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
    );

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {

    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print('time canceled');
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(':')[0]),
          minute: int.parse(_startTime.split(':')[1].split(' ')[0]),
        )
    );
  }

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        SizedBox(height: Dimensions.height8,),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: EdgeInsets.only(right: Dimensions.width8),
                child: CircleAvatar(
                  radius: Dimensions.radius14,
                  backgroundColor: dotsColor[index],
                  child: _selectedColor == index ? Icon(
                    Icons.done,
                    color: Colors.white,
                    size: Dimensions.iconSize16,
                  ) : Container(),
                ),
              ),
            );
          }),
        )
      ],
    );
  }
}
