import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screen/sign_up_screen.dart';
import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/widget/background_screen.dart';

class TabSignInScreen extends StatefulWidget {
  const TabSignInScreen({super.key});

  @override
  State<TabSignInScreen> createState() => _TabSignInScreenState();
}

class _TabSignInScreenState extends State<TabSignInScreen> {
  final TextEditingController _emailTextEditingController =
  TextEditingController();
  final TextEditingController _passwordTextEditingController =
  TextEditingController();

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
                "Get Started With",
                style: textTheme.displaySmall?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              _buildSignInForm(),
              const SizedBox(height: 50),
              _buildSignInFooterSection(textTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Column(
      children: [
        TextFormField(
          controller: _emailTextEditingController,
          decoration: const InputDecoration(
            hintText: "Email",
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _passwordTextEditingController,
          decoration: const InputDecoration(
            hintText: "Password",
          ),
          obscureText: true,
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: _onTabSignInButton,
          child: const Icon(
            Icons.arrow_circle_right_outlined,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSignInFooterSection(TextTheme textTheme) {
    return Column(
      children: [
        Align(
          child: TextButton(
            onPressed: _onTabForgetPasswordButton,
            child: Text(
              "Forgot Password?",
              style: textTheme.labelLarge?.copyWith(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Align(
          child: RichText(
            text: TextSpan(
              style: textTheme.labelLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
              text: "Don't have an account?",
              children: [
                TextSpan(
                    text: " Sign up",
                    style: const TextStyle(color: AppColor.themeColor),
                    recognizer: TapGestureRecognizer()
                      ..onTap = _onTabSignUpButton),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onTabSignInButton() {
    // Todo : Handle sign-in logic here
  }

  void _onTabForgetPasswordButton() {
    // Todo: Handle forget password logic here
  }

  void _onTabSignUpButton() {
    // Todo : Handle sign-up logic here

    Navigator.push(
        context, MaterialPageRoute(builder: (context) =>   SignUpScreen()));
  }


}
