import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/api/models/network_response.dart';
import 'package:task_manager/api/services/api_client.dart';
import 'package:task_manager/api/utils/urls.dart';
import 'package:task_manager/ui/screen/sign_up_screen.dart';
import 'package:task_manager/ui/screen/task_screen.dart';
import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/widget/app_bar.dart';
import 'package:task_manager/ui/widget/background_screen.dart';
import 'package:task_manager/ui/widget/bottom_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: BackgroundScreen(
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
      ),
    );
  }

  Widget _buildSignInForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextFormField(
              _emailTextEditingController, "Email", "Email is required"),
          const SizedBox(height: 20),
          _buildTextFormField(
              _passwordTextEditingController, "Password", "Password is required" , obscureText: true),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _onTabSignInButton,
            child: _inProgress ? CircularProgressIndicator() : const Icon(
              Icons.arrow_circle_right_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  TextFormField _buildTextFormField(
      TextEditingController controller, String hintText, errorMessage,
      {TextInputType? textInputType, bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: textInputType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return errorMessage;
        }
        return null;
      },
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

    if(_formKey.currentState!.validate()){
      signIn();

    }


  }


  void signIn()async{
     setState(() {
       _inProgress = true;
     });
    Map<String , dynamic> _requestBody = {
      "email":_emailTextEditingController.text.trim(),
      "password":_passwordTextEditingController.text
    };

    NetworkResponse response = await ApiClient.postRequest(NetworkURL.loginUrl,_requestBody);
  print(NetworkURL.loginUrl );
    setState(() {
      _inProgress = false;
    });
    if(response.isSuccess){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login SuccessFull")));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigationWidget()),
              (context) => false);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.isError.toString())));
    }



  }

  void _onTabForgetPasswordButton() {
    // Todo: Handle forget password logic here
    // Todo : Handle sign-in logic here

  }

  void _onTabSignUpButton() {
    // Todo : Handle sign-up logic here

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpScreen()));
  }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }
}
