import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/api/controllers/auth_controller.dart';
import 'package:task_manager/api/controllers/task_controller.dart';
import 'package:task_manager/api/models/user_model.dart';
import 'package:task_manager/ui/widget/app_bar.dart';
import 'package:task_manager/ui/widget/background_screen.dart';



class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  // Create TextEditingControllers for each form field

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Rx<XFile?> _selectedImage = Rx<XFile?>(null);
  final taskController = Get.find<TaskController>();
  final authController = Get.find<AuthController>();

  Rxn<UserModel> userModel = Rxn<UserModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prefillUserData();
  }

  bool _shouldRefreshPreviousPage = false;





  void prefillUserData() {
    _emailController.text = authController.userData.value!.email ?? "";
    _firstNameController.text = authController.userData.value!.firstName ?? "";
    _lastNameController.text = authController.userData.value!.lastName ?? "";
    _mobileController.text = authController.userData.value!.mobile ?? "";
  }


  @override
  void dispose() {
    // Always dispose of controllers to prevent memory leaks
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult:(didPop ,dynamic result){
        if(didPop == true){
          return;
        }
        Navigator.pop(context , _shouldRefreshPreviousPage);

      },
      child: Scaffold(
        appBar: TMAppBar(isProfileScreenOpen: true,),
        body: SingleChildScrollView(
          child: BackgroundScreen(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Text(
                    "Update Profile",
                    style: textTheme.displaySmall?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _getImage,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(color: Colors.white),
                      child: Row(
                        children: [
                          Container(
                            height: 60,
                            width: 100,
                            decoration: BoxDecoration(color: Colors.grey),
                            child: Align(
                                child: Text(
                                  "Photos",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                )),
                          ),
                          SizedBox(width: 20,),
                          Text(_selectedImage.value?.name ?? "Choose Image")
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // First Name Input
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      hintText: "First Name",
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Last Name Input
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      hintText: "Last Name",
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Email Input
                  TextFormField(
                    enabled: false,
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: "Email",
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // Mobile Input
                  TextFormField(
                    controller: _mobileController,
                    decoration: const InputDecoration(
                      hintText: "Mobile",
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),

                  // Password Input
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: "Password",
                    ),
                    obscureText: true, // Hide password input
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _onTabSignInButton,
                    child: const Icon(
                      Icons.arrow_circle_right_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<void> _onTabSignInButton() async {
    Map<String, dynamic> requestBody = {
      "email": _emailController.text,
      "firstName": _firstNameController.text,
      "lastName": _lastNameController.text,
      "mobile": _mobileController.text,
    };
    if(_passwordController.text.isNotEmpty){
      requestBody["password"] = _passwordController.text;
    }

    if( _selectedImage.value != null){
      List<int> convertBytes = await _selectedImage.value!.readAsBytes();
      String convertImage = base64Encode(convertBytes);
      requestBody["photo"] = convertImage;
    }


    final bool result = await taskController.updateProfile(requestBody);
    if(result){

      Get.snackbar("message", "Update Successfully");
    }else{
      Get.snackbar("error", taskController.errorMessage.toString());
    }
  }

  Future<void> _getImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Update the reactive variable
      _selectedImage.value = image;
    }
  }


}