import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  static const String accessTokenKey = "_accessTokenKey";
  static String? accessToken;

  // Save the access token
  static Future<void> saveToken({required String token}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(accessTokenKey, token);
    accessToken = token;
  }

  // Retrieve the access token
  static Future<String?> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    accessToken = sharedPreferences.getString(accessTokenKey);
    return accessToken;
  }

  // Check if the user is logged in
  static bool isLoggedIn() {
    return accessToken != null;
  }

  // Clear user data
  static Future<void> clearUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(accessTokenKey); // Clear specific key
    accessToken = null;
  }
}
