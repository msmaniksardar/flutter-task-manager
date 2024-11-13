import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/api/controllers/task_controller.dart';
import 'package:task_manager/api/models/network_response.dart';
import 'package:task_manager/api/services/api_client.dart';
import 'package:task_manager/api/utils/urls.dart';
import 'package:task_manager/ui/routes/route.dart';
import 'package:task_manager/ui/screen/pin_verification_screen.dart';
import 'package:task_manager/ui/screen/sign_in_screen.dart';
import 'package:task_manager/ui/screen/sign_up_screen.dart';
import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/widget/background_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailTextEditingController =
  TextEditingController();
  final taskController = Get.find<TaskController>();

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundScreen(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              Text(
                "Your Email Address",
                style: textTheme.displaySmall?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "A 6 digit verification code will send your email Address",
                style: textTheme.labelLarge
                    ?.copyWith(color: Colors.grey, fontSize: 20),
              ),
              const SizedBox(height: 20),
              _buildForgetInForm(),
              const SizedBox(height: 50),
              _buildForgetFooter(textTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForgetInForm() {
    return Column(
      children: [
        TextFormField(
          controller: _emailTextEditingController,
          decoration: const InputDecoration(
            hintText: "Email",
          ),
        ),
        const SizedBox(height: 20),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: _onTabForgetPasswordButton,
          child: const Icon(
            Icons.arrow_circle_right_outlined,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildForgetFooter(TextTheme textTheme) {
    return Column(
      children: [
        Align(
          child: RichText(
            text: TextSpan(
              text: "Have an account?",
              style: textTheme.labelLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
              children: [
                TextSpan(
                    text: " Sign In",
                    style: const TextStyle(color: AppColor.themeColor),
                    recognizer: TapGestureRecognizer()
                      ..onTap = _onTabSignInButton),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onTabSignInButton() {
    // Todo : Handle sign-in logic here
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  void _onTabForgetPasswordButton() {

    forgetPassword();
  }

  Future<void> forgetPassword() async {
    final String email = _emailTextEditingController.text.trim();
    final bool result = await taskController.forgetPassword(email);
    if(result){
      Get.snackbar("message", "Check Your Email Address");
      Get.toNamed(pinVerify , arguments: {"email":email});
    }else{
      Get.snackbar("error", taskController.errorMessage.toString());
    }
  }
}
