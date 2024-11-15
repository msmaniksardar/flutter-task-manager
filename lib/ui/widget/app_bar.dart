import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:task_manager/api/controllers/auth_controller.dart';
import 'package:task_manager/api/models/user_model.dart';
import 'package:task_manager/ui/screen/mobile/sign_in_screen_layout.dart';
import 'package:task_manager/ui/screen/update_profile_screen.dart';
import '../utility/app_colors.dart';
import 'package:task_manager/api/controllers/auth_controller.dart';
class TMAppBar extends StatefulWidget implements PreferredSizeWidget {
  TMAppBar({super.key ,  this.isProfileScreenOpen = false,});
  final bool isProfileScreenOpen;

  @override
  State<TMAppBar> createState() => _TMAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _TMAppBarState extends State<TMAppBar> {

  UserModel? userModel;
  Uint8List decodedBytes = base64Decode(AuthController.userData!.photo.toString());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      loadUserData();
  }


  Future<void> loadUserData() async {
    userModel = await AuthController.getUserData();
    await AuthController.userData;
    setState(() {}); // Trigger a rebuild to show the updated user data
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.themeColor,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: ()async {

              await AuthController.clearAccessToken();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SignInScreenLayout()),
                    (_) => false,
              );
            },
            icon: const Icon(Icons.logout),
            color: Colors.white,
          ),
        ),
      ],
      title: GestureDetector(
        onTap: ()async {
          if (widget.isProfileScreenOpen) {
            return;
          }
        bool result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UpdateProfileScreen()),);
          if( result == false){
           await loadUserData();
          }
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: Image.memory(decodedBytes).image,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Text(
                    AuthController.userData?.fullName ?? "",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    AuthController.userData?.email ?? "",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}
