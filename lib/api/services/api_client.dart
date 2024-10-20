import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:task_manager/api/controllers/auth_controller.dart';
import 'package:task_manager/api/models/network_response.dart';
import 'package:http/http.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/ui/screen/sign_in_screen.dart';

class ApiClient {
  static Future<NetworkResponse> getRequest(String url) async {
    final token = await AuthController.getAccessToken();
    try {
      Uri uri = Uri.parse(url);
      Response response = await get(uri, headers: {
        "Content-Type": "application/json",
        "token": "${token}"
      });
      printNetwork(url, response);

      if (response.statusCode == 200) {
        // Parse the response body as JSON
        final data = jsonDecode(response.body);
        return NetworkResponse.success(
          data: data,
          statusCode: response.statusCode,
          isSuccess: true,
        );
      } else if (response.statusCode == 401) {
        _moveToLogin();
        return NetworkResponse.error(
          error: jsonDecode(response.body)["status"],
          statusCode: response.statusCode,
          isSuccess: true,
        );
      } else {
        // Attempt to parse the error response
        final errorData = jsonDecode(response.body);
        return NetworkResponse.error(
          error: errorData['data'] ?? 'Error occurred',
          statusCode: response.statusCode,
          isSuccess: false,
        );
      }
    } on SocketException {
      // Handle no internet connection
      return NetworkResponse.error(
        statusCode: -1,
        error: "No internet connection",
        isSuccess: false,
      );
    } catch (e) {
      // Handle any other exceptions
      return NetworkResponse.error(
        statusCode: -1,
        error: e.toString(),
        isSuccess: false,
      );
    }
  }

  static Future<NetworkResponse> postRequest(
      String url, Map<String, dynamic> requestBody) async {

    try {
    ;
      Uri uri = Uri.parse(url);
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "token": "${AuthController.accessToken}"
      };
      Response response =
          await post(uri, headers: headers, body: jsonEncode(requestBody));
      printNetwork(url, response);
      final data = jsonDecode(response.body);

      print(data);
      // Save new token if available
      if (data.containsKey("token")) {
        await AuthController.saveAccessToken(data["token"].toString());
      }


      print(headers);

      if (response.statusCode == 200) {
        // Parse the response body as JSON
        final data = jsonDecode(response.body);

        return NetworkResponse.success(
          data: data,
          statusCode: response.statusCode,
          isSuccess: true,
        );
      } else if (response.statusCode == 401) {
        _moveToLogin();
        return NetworkResponse.error(
          error: jsonDecode(response.body)["status"],
          statusCode: response.statusCode,
          isSuccess: true,
        );
      } else {
        final errorData = jsonDecode(response.body);
        return NetworkResponse.error(
          error: errorData['data'] ?? 'Error occurred',
          statusCode: response.statusCode,
          isSuccess: false,
        );
      }
    } on SocketException {
      // Handle no internet connection
      return NetworkResponse.error(
        statusCode: -1,
        error: "No internet connection",
        isSuccess: false,
      );
    } catch (e) {
      print(e);
      return NetworkResponse.error(
        statusCode: -1,
        error: e.toString(),
        isSuccess: false,
      );
    }
  }

  static void printNetwork(String url, Response response) {
    debugPrint(
      "REQUEST_URL: $url\nRESPONSE: ${response.body}\nSTATUS_CODE: ${response.statusCode}",
    );
  }

  static void _moveToLogin() {
    AuthController.clearUserData();
    Navigator.pushAndRemoveUntil(
        MyApp.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (p) => false);
  }
}
