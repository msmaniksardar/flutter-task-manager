import 'package:flutter/material.dart';
import 'package:task_manager/ui/screen/mobile/sign_in_screen_layout.dart';
import 'package:task_manager/ui/screen/update_profile_screen.dart';
import '../utility/app_colors.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  TMAppBar({super.key});



  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.themeColor,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () {
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
      title: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UpdateProfileScreen()),);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Manik Sardar",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "anonymousmanik@gmail.com",
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
