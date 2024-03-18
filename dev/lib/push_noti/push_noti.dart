import 'package:dev/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNoti {
  final _firebaseMessage = FirebaseMessaging.instance;

  //hàm tạo thông báo
  Future<void> initNotification() async {
    //yêu cầu quyền truy cập từ người dùng
    await _firebaseMessage.requestPermission();

    //fetch token cho thiết bị hiện tại
    final token = await _firebaseMessage.getToken();

    initPushNoti();
  }

  //xử lý nhận thông báo
  void handleMessage(RemoteMessage? message){

    if (message == null) return;

    navigatorKey.currentState?.pushNamed('tab_chat', arguments: message);
  }

  Future initPushNoti() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}