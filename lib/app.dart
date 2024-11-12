import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/api/controllers/bind_controller.dart';
import 'package:task_manager/ui/routes/route.dart';
import 'package:task_manager/ui/screen/add_new_task.dart';
import 'package:task_manager/ui/screen/forget_password.dart';
import 'package:task_manager/ui/screen/mobile/sign_in_screen_layout.dart';
import 'package:task_manager/ui/screen/pin_verification_screen.dart';
import 'package:task_manager/ui/screen/reset_password.dart';
import 'package:task_manager/ui/screen/splash_screen.dart';
import 'package:task_manager/ui/screen/update_profile_screen.dart';
import 'package:task_manager/ui/theme/theme.dart';
import 'package:task_manager/ui/widget/bottom_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

   static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: MyApp.navigatorKey,
      home: SplashScreen(),
      theme: lightTheme,
      initialRoute: splash,
      getPages: getPage,
      initialBinding: BindController(),
      debugShowCheckedModeBanner: false,
    );
  }
}
