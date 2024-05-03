import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_app/models/task.dart';

import 'package:todo_app/moduels/notify_screen.dart';
class NotifyHelper{
  FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin(); //

  initializeNotification() async {
    _configureLocalTimeZone();


    final AndroidInitializationSettings initializationSettingsAndroid =
     AndroidInitializationSettings("appicon");

      final InitializationSettings initializationSettings =
      InitializationSettings(

      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,

    );

  }
  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {

      Get.dialog(Text('Welcome to Flutter'));
  }

  displayNotification({required String title, required String body}) async {
    print("doing test");
    var androidPlatformChannelSpecifics =
    const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high
    );



    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: title,
    );
  }

  scheduledNotification(int hour,int minutes,Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
         task.id!,
         task.title,
         task.note,
        _convertTime(hour,minutes),
    //    tz.TZDateTime.now(tz.local).add(Duration(hours: hour,minutes: minutes)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
              'your channel id',
                'your channel name',
            ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "${task.title}|"+"${task.note}|"
    );

  }

  tz.TZDateTime _convertTime(int hour ,int minutes){
    final tz.TZDateTime now =tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =tz.TZDateTime(tz.local,now.year,now.month,now.day,hour,minutes);
    if(scheduleDate.isBefore(now)){

      scheduleDate =scheduleDate.add(const Duration(days:1));
    }
    return scheduleDate;
  }

 Future<void> _configureLocalTimeZone() async{
    tz.initializeTimeZones();
    final String timeZone =await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }


  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future selectNotification(String? payload) async {

    Get.to(()=>NotifiedScreen(label:payload));
  }
}