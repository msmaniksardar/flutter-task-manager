import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/api/models/network_response.dart';
import 'package:task_manager/api/services/api_client.dart';
import 'package:task_manager/api/utils/urls.dart';
import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/widget/background_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false; // Loading state

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
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
                _buildSignUpForm(),
                const SizedBox(height: 50),
                _buildSignUpFooter(textTheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // First Name Input
          _buildTextField(_firstNameController, "First Name", "First Name is Required"),
          const SizedBox(height: 20),

          // Last Name Input
          _buildTextField(_lastNameController, "Last Name", "Last Name is Required"),
          const SizedBox(height: 20),

          // Email Input
          _buildTextField(
            _emailController,
            "Email",
            "Email is Required",
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),

          // Mobile Input
          _buildTextField(
            _mobileController,
            "Mobile",
            "Mobile Number is Required",
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),

          // Password Input
          _buildTextField(
            _passwordController,
            "Password",
            "Password is Required",
            obscureText: true,
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: _isLoading ? null : _onTabSignInButton, // Disable button during loading
            child: _isLoading
                ? const CircularProgressIndicator() // Show loader
                : const Icon(
              Icons.arrow_circle_right_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  TextFormField _buildTextField(TextEditingController controller, String hint, String errorMessage, {TextInputType? keyboardType, bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(hintText: hint),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return errorMessage;
        }
        return null;
      },
    );
  }

  Widget _buildSignUpFooter(TextTheme textTheme) {
    return Column(
      children: [
        Align(
          child: RichText(
            text: TextSpan(
              style: textTheme.labelLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
              text: "Have an account?",
              children: [
                TextSpan(
                  text: " Sign In",
                  style: const TextStyle(color: AppColor.themeColor),
                  recognizer: TapGestureRecognizer()..onTap = _onTabSignInButton,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onTabSignInButton() {
    if (_formKey.currentState!.validate()) {
      signUp();
    }
  }

  void signUp() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    final requestBody = {
      "email": _emailController.text,
      "firstName": _firstNameController.text,
      "lastName": _lastNameController.text,
      "mobile": _mobileController.text,
      "password": _passwordController.text,
      "photo": ""
    };

    NetworkResponse networkResponse = await ApiClient.postRequest(NetworkURL.registrationUrl, requestBody);

    if (networkResponse.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User Created Successfully")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(networkResponse.isError.toString())));
      print(networkResponse.isError);
    }

    setState(() {
      _isLoading = false; // Stop loading
    });
  }

  @override
  void dispose() {
    // Dispose of controllers to prevent memory leaks
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
