import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:task_manager/api/controllers/auth_controller.dart';
import 'package:task_manager/api/models/network_response.dart';
import 'package:http/http.dart';

class ApiClient {
  static Future<NetworkResponse> getRequest(String url,
      {status, id}) async {
    try {
      Uri uri = Uri.parse(url);
      final token = await Authentication.getToken();
      Response response = await get(uri,
          headers: {"Content-Type": "application/json", "token": "${token}"});
      printNetwork(url, response);

      if (response.statusCode == 200) {
        // Parse the response body as JSON
        final data = jsonDecode(response.body);
        return NetworkResponse.success(
          data: data,
          statusCode: response.statusCode,
        );
      } else {
        // Attempt to parse the error response
        final errorData = jsonDecode(response.body);
        return NetworkResponse.error(
          error: errorData['message'] ?? 'Error occurred',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      // Handle no internet connection
      return NetworkResponse.error(
        statusCode: -1,
        error: "No internet connection",
      );
    } catch (e) {
      // Handle any other exceptions
      return NetworkResponse.error(
        statusCode: -1,
        error: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> postRequest(
      String url, Map<String, dynamic> requestBody) async {
    return _makeRequest(() => post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestBody),
        ));
  }

  static Future<NetworkResponse> _makeRequest(
      Future<Response> Function() request) async {
    try {
      final response = await request();
      printNetwork(response.request!.url.toString(), response);
      return _handleResponse(response);
    } on SocketException {
      return _handleError("No internet connection");
    } catch (e) {
      return _handleError(e.toString());
    }
  }

  static Future<NetworkResponse> _handleResponse(Response response) async {
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        Authentication.saveToken(token: data["token"]);

        if (data["status"] == "success") {
          return NetworkResponse.success(
            data: data,
            statusCode: response.statusCode,
          );
        } else if (data["data"] == "Something went wrong") {
          return NetworkResponse.error(
            error: "This email address is already in the database",
            statusCode: response.statusCode,
          );
        } else if (data["data"] == "No user found. Try again!") {
          return NetworkResponse.error(
            error: jsonDecode(response.body)["data"],
            statusCode: response.statusCode,
          );
        } else {
          return NetworkResponse.error(
            error: "Unexpected response format",
            statusCode: response.statusCode,
          );
        }
      } else {
        // Attempt to parse the error response
        final errorData = jsonDecode(response.body);
        return NetworkResponse.error(
          error: errorData['data'],
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return NetworkResponse.error(
        error: response.body,
        statusCode: response.statusCode,
      );
    }
  }

  static Future<NetworkResponse> _handleError(e) async {
    return NetworkResponse.error(
      statusCode: -1,
      error: e.toString(),
    );
  }

  static void printNetwork(String url, Response response) {
    debugPrint(
      "REQUEST_URL: $url\nRESPONSE: ${response.body}\nSTATUS_CODE: ${response.statusCode}",
    );
  }
}
