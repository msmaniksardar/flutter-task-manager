import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:task_manager/api/controllers/auth_controller.dart';
import 'package:task_manager/api/models/network_response.dart';
import 'package:task_manager/api/models/task_list_model.dart';
import 'package:task_manager/api/models/task_model.dart';
import 'package:task_manager/api/models/user_model.dart';
import 'package:task_manager/api/services/api_client.dart';
import 'package:task_manager/api/utils/urls.dart';


final authController = Get.find<AuthController>();



class TaskController extends GetxController {
  final RxBool _inProgress = false.obs;
  final RxBool _isSuccess = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxList<TaskModel> taskList = <TaskModel>[].obs;


  RxString get errorMessage => _errorMessage;

  RxBool get inProgress => _inProgress;

  RxBool get isSuccess => _isSuccess;

  Future<bool> getTask({String? status}) async {
    taskList.clear();
    _isSuccess.value = false;
    _inProgress.value = true;

    NetworkResponse response = await ApiClient.getRequest(
      NetworkURL.listByStatus + "/$status",
    );

    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data);
      taskList.assignAll(taskListModel.taskList ?? []);
      _isSuccess.value = true;
    } else {
      _inProgress.value = false;
      _errorMessage.value = response.isError?.toString() ?? 'Unknown error';
    }

    _inProgress.value = false;
    return _isSuccess.value;
  }

  Future<bool> deleteTask(id) async {
    _isSuccess.value = false;
    _inProgress.value = true;
    NetworkResponse response =
        await ApiClient.getRequest(NetworkURL.deleteTaskUrl + "/${id}");
    if (response.isSuccess) {
      _isSuccess.value = true;
    } else {
      _errorMessage.value = response.isError.toString();
    }

    _inProgress.value = false;
    return _isSuccess.value;
  }

  Future<bool> updateTask(id, status) async {
    _isSuccess.value = false;
    _inProgress.value = true;
    NetworkResponse response = await ApiClient.getRequest(
        NetworkURL.updateTaskStatusUrl + "/${id}/${status}");
    if (response.isSuccess) {
      _isSuccess.value = true;
    } else {
      _errorMessage.value = response.isError.toString();
    }
    inProgress.value = false;
    return _isSuccess.value;
  }

  Future<bool> addTask(requestBody) async {
    _isSuccess.value = false;
    _inProgress.value = true;
    NetworkResponse response =
        await ApiClient.postRequest(NetworkURL.createTaskUrl, requestBody);

    if (response.isSuccess) {
      _isSuccess.value = true;
    } else {
      _errorMessage.value = response.isError.toString();
    }
    _inProgress.value = false;
    return _isSuccess.value;
  }

  Future<bool> reset(requestBody) async {
    _isSuccess.value = false;
    _inProgress.value = true;
    NetworkResponse response = await ApiClient.postRequest(
        NetworkURL.RecoverResetPassUrl, requestBody);
    if (response.isSuccess) {
      _isSuccess.value = true;
    } else {
      _errorMessage.value = response.isError.toString();
    }

    _inProgress.value = false;
    return _isSuccess.value;
  }

  Future<bool> forgetPassword(email) async {
    _isSuccess.value = false;
    _inProgress.value = true;
    NetworkResponse response = await ApiClient.getRequest(
        NetworkURL.tRecoverVerifyEmailUrl + "/${email}");
    if (response.isSuccess) {
      _isSuccess.value = true;
    } else {
      _errorMessage.value = response.isError.toString();
    }
    _inProgress.value = false;
    return _isSuccess.value;
  }

  Future<bool> verifyCode(otp, email) async {
    _isSuccess.value = false;
    _inProgress.value = true;
    NetworkResponse response = await ApiClient.getRequest(
        NetworkURL.RecoverVerifyOTPUrl + "/${email}/${otp}");
    if (response.isSuccess) {
      _isSuccess.value = true;
    } else {
      _errorMessage.value = response.isError.toString();
    }

    _inProgress.value = false;
    return _isSuccess.value;
  }

  Future<bool> updateProfile(requestBody) async {
    _isSuccess.value = false;
    _inProgress.value = true;

    NetworkResponse response = await ApiClient.postRequest(
        NetworkURL.profileUpdatePassUrl, requestBody);
    if (response.isSuccess) {
      UserModel userModel = UserModel.fromJson(requestBody);
      print(requestBody);
      await authController.saveUserData(userModel);
      _isSuccess.value = true;
    } else {
      _errorMessage.value = response.isError.toString();
    }
    _inProgress.value = false;
    return _isSuccess.value;
  }
}
