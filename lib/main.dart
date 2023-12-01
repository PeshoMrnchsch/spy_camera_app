import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_from/camera_screen.dart';
import 'select_options.dart';

// late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  // await initializeService();

  runApp(MyApp(
    cameras: cameras,
  ));
}

// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//
//   await service.configure(
//       iosConfiguration: IosConfiguration(),
//       androidConfiguration:
//       AndroidConfiguration(onStart: onStart, isForegroundMode: true));
// }

// pragma('vm:entry-point')
// Future<void> onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();
//
//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });
//
//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//
//     service.on('stopService').listen((event) {
//       service.stopSelf();
//     });
//   }
//   Timer.periodic(const Duration(seconds: 2), (timer) async {
//     if (service is AndroidServiceInstance) {
//       if (await service.isForegroundService()) {
//         service.setForegroundNotificationInfo(title: 'The Service has started',
//             content: 'Updated at ${DateTime.now()}');
//       }
//     }
//   });
// }

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({Key? key, required this.cameras}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SelectOptions(
          cameras: cameras,
        )
      //CameraScreen(cameras: cameras)
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
