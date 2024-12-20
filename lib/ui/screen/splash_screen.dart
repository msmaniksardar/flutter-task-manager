import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:task_manager/api/controllers/auth_controller.dart';
import 'package:task_manager/ui/routes/route.dart';
import 'package:task_manager/ui/screen/mobile/sign_in_screen_layout.dart';
import 'package:task_manager/ui/utility/assets_path.dart';
import 'package:task_manager/ui/widget/background_screen.dart';
import 'package:task_manager/ui/widget/bottom_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _moveToNextScreen();
  }

  final authController = Get.find<AuthController>();

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    await authController.getAccessToken();

    if (authController.isLoggedIn()) {
      await authController.getUserData();
      Get.offNamed(bottomNavigation);
    } else {
      Get.off(login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundScreen(
          child: Stack(
        children: [Center(child: SvgPicture.asset(AssetsPath.logoSvgImage))],
      )),
    );
  }
}
