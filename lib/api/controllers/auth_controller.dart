import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/api/models/user_model.dart';



class AuthController {
  static const String _accessTokenKey = 'access-token';
  static const String _accessUserKey = 'access-user';

  static String? accessToken;
  static UserModel? userData;

  static Future<void> saveAccessToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    accessToken = token;
  }

  static Future<void> saveUserData(UserModel? userModel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
        _accessUserKey, jsonEncode(userModel));
    userData = userModel;
  }

  static Future<void> updateUserData(UserModel updatedUserData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Save updated user data to SharedPreferences
    await sharedPreferences.setString(_accessUserKey, jsonEncode(updatedUserData));
    // Update the local userData instance
    userData = updatedUserData;
  }



  static Future<UserModel?> getUserData ()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? user = sharedPreferences.getString(_accessUserKey);
    if(user == null){
      return null;
    }
    UserModel userModel= UserModel.fromJson(jsonDecode(user));
    userData = userModel;
    return userModel;
  }

  static Future<String?> getAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);
    accessToken = token;
    return token;
  }

  static bool isLoggedIn() {
    return accessToken != null;
  }

  static Future<void> clearAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(_accessTokenKey);
    accessToken = null;
  }

  static Future<void> clearUserData ()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(_accessUserKey);
    userData = null;
  }

}