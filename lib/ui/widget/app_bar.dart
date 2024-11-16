import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/api/controllers/auth_controller.dart';
import 'package:task_manager/api/models/user_model.dart';
import 'package:task_manager/ui/routes/route.dart';
import 'package:task_manager/ui/screen/update_profile_screen.dart';
import '../utility/app_colors.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  TMAppBar({
    super.key,
    this.isProfileScreenOpen = false,
  });

  final bool isProfileScreenOpen;

  final authController = Get.find<AuthController>();

  Rxn<UserModel> userModel = Rxn<UserModel>();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.themeColor,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () async {
              await authController.clearAccessToken();
              Get.offAllNamed(login);
            },
            icon: const Icon(Icons.logout),
            color: Colors.white,
          ),
        ),
      ],
      title: GestureDetector(
        onTap: () async {
          if (isProfileScreenOpen) {
            return;
          }
          bool result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UpdateProfileScreen()),
          );
        },
        child: Obx(() {
          final user = authController.userData.value;

          // Decode the photo if available, otherwise set to null
          Uint8List? decodedBytes =
              user?.photo != null ? base64Decode(user!.photo!) : null;
          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: decodedBytes != null
                      ? Image.memory(decodedBytes).image
                      : AssetImage('assets/images/default.jpg'),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authController.userData.value?.fullName ?? "",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      authController.userData.value?.email ?? "",
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
          );
        }),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
