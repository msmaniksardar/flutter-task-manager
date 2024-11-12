import 'package:get/get.dart';
import 'package:task_manager/api/controllers/auth_controller.dart';
import 'package:task_manager/api/models/network_response.dart';
import 'package:task_manager/api/models/user_response_model.dart';
import 'package:task_manager/api/services/api_client.dart';
import 'package:task_manager/api/utils/urls.dart';

class SignInController extends GetxController {
  RxBool _inProgress = false.obs;
  RxBool _isSuccess = false.obs;
  RxString _errorMessage = ''.obs;

  RxString get errorMessage => _errorMessage;
  RxBool get inProgress => _inProgress;
  RxBool get isSuccess => _isSuccess;

  Future<bool> signIn({String? email, String? password}) async {
    _isSuccess.value = false;
    _inProgress.value = true;

    Map<String, dynamic> requestBody = {"email": email, "password": password};

    NetworkResponse response =
    await ApiClient.postRequest(NetworkURL.loginUrl, requestBody);

    if (response.isSuccess) {
      UserResponseModel userResponseModel =
      UserResponseModel.fromJson(response.data);

      await AuthController.saveUserData(userResponseModel.data);
      await AuthController.saveAccessToken(userResponseModel.token!);
      _isSuccess.value = true;
    } else {
      _errorMessage.value = response.isError?.toString() ?? 'Unknown error';
    }

    _inProgress.value = false;
    return _isSuccess.value;
  }
}
