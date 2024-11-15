import 'package:get/get.dart';
import 'package:task_manager/api/controllers/auth_controller.dart';
import 'package:task_manager/api/controllers/count_controller.dart';
import 'package:task_manager/api/controllers/sign_in_controller.dart';
import 'package:task_manager/api/controllers/task_controller.dart';

class BindController extends Bindings{
  @override
  void dependencies() {
    Get.put(SignInController());
    Get.put(TaskController());
    Get.put(CountController());
    Get.put(AuthController());
  }

}