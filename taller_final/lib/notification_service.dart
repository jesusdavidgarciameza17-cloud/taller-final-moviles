import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService{
  static final FlutterLocalNotificationsPlugin _p=FlutterLocalNotificationsPlugin();

  static Future<void> init() async{
    const a=AndroidInitializationSettings('@mipmap/ic_launcher');
    await _p.initialize(const InitializationSettings(android:a));
    await _p.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  static Future<void> show({required String title,required String body}) async{
    const det=NotificationDetails(
      android:AndroidNotificationDetails(
        'covid_channel','Datos COVID',
        channelDescription:'Resumen de datos de COVID-19',
        importance:Importance.high,
        priority:Priority.high,
      ),
    );
    await _p.show(0,title,body,det);
  }
}
