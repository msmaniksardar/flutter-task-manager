import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/api/controllers/auth_controller.dart';
import 'package:task_manager/api/models/network_response.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager/ui/routes/route.dart';


final authController = Get.find<AuthController>();

class ApiClient {
  static Future<NetworkResponse> getRequest(String url) async {
    final token = await authController.getAccessToken();
    try {
      Uri uri = Uri.parse(url);
      http.Response response = await http.get(uri,
          headers: {"Content-Type": "application/json", "token": "${token}"});
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
        return NetworkResponse.error(
          error: jsonDecode(response.body)["data"],
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
    Uri uri = Uri.parse(url);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "token": authController.accessToken.toString()
    };
    http.Response response =
        await http.post(uri, headers: headers, body: jsonEncode(requestBody));
    printNetwork(url, response);
    print(headers);
    if (response.statusCode == 200) {
      return NetworkResponse.success(
        data: jsonDecode(response.body),
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
      return NetworkResponse.error(
        error: jsonDecode(response.body)["data"],
        statusCode: response.statusCode,
        isSuccess: false,
      );
    }
  }

  static void printNetwork(String url, http.Response response) {
    debugPrint(
      "REQUEST_URL: $url\nRESPONSE: ${response.body}\nSTATUS_CODE: ${response.statusCode}",
    );
  }

  static void _moveToLogin() {
    authController.clearAccessToken();
    Get.offAllNamed(login);
  }
}
