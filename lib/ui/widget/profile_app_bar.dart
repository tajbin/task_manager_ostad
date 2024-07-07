import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager_ostad/ui/controllers/auth_controller.dart';
import 'package:task_manager_ostad/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager_ostad/ui/screens/update_profile.dart';
import '../utility/apps_color.dart';

AppBar profileAppBar(context, [bool fromUpdateProfile = false]) {
  return AppBar(
    backgroundColor: AppsColor.themeColor,
    leading: GestureDetector(
      onTap: () {
        if (fromUpdateProfile) {
          return;
        }
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const UpdateProfile()));
      },
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.memory(base64Decode(AuthController.userData?.photo ?? '')),
          ),
        ),
      ),
    ),
    title: GestureDetector(
      onTap: () {
        if (fromUpdateProfile) {
          return;
        }
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const UpdateProfile()));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AuthController.userData?.fullName ?? '',
            style: const TextStyle(
                fontSize: 16,
                color: AppsColor.white,
                fontWeight: FontWeight.w600),
          ),
          Text(
            AuthController.userData?.email ?? '',
            style: const TextStyle(fontSize: 12, color: AppsColor.white),
          )
        ],
      ),
    ),
    actions: [
      IconButton(
          onPressed: () async{
            await AuthController.clearAllData();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignInScreen(),
                ),
                (route) => false);
          },
          icon: const Icon(Icons.logout))
    ],
  );
}

void _onTapProfile() {}
