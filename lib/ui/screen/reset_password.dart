import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/api/controllers/task_controller.dart';
import 'package:task_manager/ui/routes/route.dart';
import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/widget/background_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _confirmPasswordTextEditingController =
      TextEditingController();

  final _otp = Get.arguments["otp"];
  final _email = Get.arguments["email"];
  final taskController = Get.find<TaskController>();

  @override
  void dispose() {
    _passwordTextEditingController.dispose();
    _confirmPasswordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    print("Email From PIN: ${_email}");
    print("Email From PIN: ${_otp}");

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
                "Set Password",
                style: textTheme.displaySmall?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "Minimum length password  8 character with latter and number combination",
                style: textTheme.labelLarge
                    ?.copyWith(color: Colors.grey, fontSize: 20),
              ),
              const SizedBox(height: 20),
              _buildForgetInForm(textTheme),
              const SizedBox(height: 50),
              _buildForgetFooter(textTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForgetInForm(TextTheme textTheme) {
    return Column(
      children: [
        TextFormField(
          controller: _passwordTextEditingController,
          decoration: const InputDecoration(
            hintText: "Password",
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _confirmPasswordTextEditingController,
          decoration: const InputDecoration(
            hintText: "Confirm Password",
          ),
        ),
        const SizedBox(height: 20),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: _onTabResetPasswordButton,
          child: Text(
            "Confirm",
            style: textTheme.labelLarge
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
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

  void _onTabResetPasswordButton() {
    if (_passwordTextEditingController.text !=
        _confirmPasswordTextEditingController.text) {
      Get.snackbar("message", "Password Does Not Match");
    } else {
      reset();
    }
  }

  Future<void> reset() async {
    Map<String, dynamic> requestBody = {
      "email": _email,
      "OTP": _otp,
      "password": _passwordTextEditingController.text
    };

    final bool result = await taskController.reset(requestBody);
    if (result) {
      Get.snackbar("message", "Password Reset Successfully");
      Get.toNamed(login);
    } else {
      Get.snackbar("error", taskController.errorMessage.toString());
    }
  }

  void _onTabSignInButton() {
    Get.toNamed(login);
  }
}
