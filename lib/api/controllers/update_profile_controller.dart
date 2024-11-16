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


class UpdateProfileController extends GetxController {

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadUserData();
  }


  final RxBool _inProgress = false.obs;
  final RxBool _isSuccess = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxList<TaskModel> taskList = <TaskModel>[].obs;


  RxString get errorMessage => _errorMessage;
  RxBool get inProgress => _inProgress;
  RxBool get isSuccess => _isSuccess;

  Rxn<UserModel> userModel = Rxn<UserModel>();

  Future<void> loadUserData() async {
    userModel.value =await authController.getUserData();
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
