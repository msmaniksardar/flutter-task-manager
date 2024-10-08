import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInScreenLayout(),
      theme: lightTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
