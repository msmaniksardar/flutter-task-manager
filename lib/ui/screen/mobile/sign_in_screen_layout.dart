import 'package:flutter/material.dart';
import 'package:task_manager/ui/responsive/responsive.dart';
import 'package:task_manager/ui/screen/desktop/desk_sign_in_screen.dart';
import 'package:task_manager/ui/screen/sign_in_screen.dart';
import 'package:task_manager/ui/screen/tablet/tab_sign_in_screen.dart';

class SignInScreenLayout extends StatefulWidget {
  const SignInScreenLayout({super.key});

  @override
  State<SignInScreenLayout> createState() => _SignInScreenLayoutState();
}

class _SignInScreenLayoutState extends State<SignInScreenLayout> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: ResponsiveLayout(
          Mobile: SignInScreen(),
          Tablet: TabSignInScreen(),
          Desktop: DesktopSignInScreen()),
    ));
  }
}
