import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/api/models/network_response.dart';
import 'package:task_manager/api/services/api_client.dart';
import 'package:task_manager/api/utils/urls.dart';
import 'package:task_manager/ui/routes/route.dart';
import 'package:task_manager/ui/screen/reset_password.dart';
import 'package:task_manager/ui/screen/sign_in_screen.dart';
import 'package:task_manager/ui/screen/sign_up_screen.dart';
import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/widget/background_screen.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key});

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController _otpTextEditingController =
      TextEditingController();

  final email = Get.arguments["email"];

  @override
  Widget build(BuildContext context) {
    print("Email Form Get : $email");
    // print("email ${widget.email}");
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
        PinCodeTextField(
          controller: _otpTextEditingController,
          appContext: context,
          length: 6,
          pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              fieldHeight: 50,
              selectedFillColor: Colors.white,
              selectedColor: Colors.green,
              inactiveColor: Colors.grey.withOpacity(0.7),
              activeColor: Colors.green,
              activeFillColor: Colors.white,
              inactiveFillColor: Colors.white),
          enableActiveFill: true,
          backgroundColor: Colors.transparent,
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: _onTabForgetPasswordButton,
          child: Text(
            "Verify",
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

  void _onTabSignInButton() {
    // Todo : Handle sign-in logic here
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  void _onTabForgetPasswordButton() {
    verifyCode();
  }

  Future<void> verifyCode() async {
    final otp = _otpTextEditingController.text.trim();
    NetworkResponse response = await ApiClient.getRequest(
        NetworkURL.RecoverVerifyOTPUrl + "/${email}/${otp}");
    if (response.isSuccess) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.data["data"])));

      Get.toNamed(resetPassword, arguments: {"otp": otp, "email": email});
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => ResetPasswordScreen(
      //               otp: otp,
      //               email:email,
      //             )));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.isError.toString())));
    }
  }

  @override
  void dispose() {
    _otpTextEditingController.dispose();
    super.dispose();
  }
}
