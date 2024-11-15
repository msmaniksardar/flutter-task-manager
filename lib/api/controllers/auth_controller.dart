import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/api/models/user_model.dart';



class AuthController  extends GetxController{
  static const String _accessTokenKey = 'access-token';
  static const String _accessUserKey = 'access-user';

  Rxn<String> accessToken = Rxn<String>();
  Rxn<UserModel> userData = Rxn<UserModel>();

   Future<void> saveAccessToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    accessToken.value = token;
  }

   Future<void> saveUserData(UserModel? userModel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
        _accessUserKey, jsonEncode(userModel));
    userData.value = userModel;
  }

   Future<void> updateUserData(UserModel updatedUserData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Save updated user data to SharedPreferences
    await sharedPreferences.setString(_accessUserKey, jsonEncode(updatedUserData));
    // Update the local userData instance
    userData.value = updatedUserData;
  }



   Future<UserModel?> getUserData ()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? user = sharedPreferences.getString(_accessUserKey);
    if(user == null){
      return null;
    }
    UserModel userModel= UserModel.fromJson(jsonDecode(user));
    userData.value = userModel;
    return userModel;
  }

   Future<String?> getAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);
    accessToken.value = token;
    return token;
  }

   bool isLoggedIn() {
    return accessToken.value != null;
  }

   Future<void> clearAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(_accessTokenKey);
    accessToken.value = null;
  }

   Future<void> clearUserData ()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(_accessUserKey);
    userData.value = null;
  }

}