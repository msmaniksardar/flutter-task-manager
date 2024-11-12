import 'package:get/get.dart';
import 'package:task_manager/api/models/network_response.dart';
import 'package:task_manager/api/models/task_list_model.dart';
import 'package:task_manager/api/models/task_model.dart';
import 'package:task_manager/api/services/api_client.dart';
import 'package:task_manager/api/utils/urls.dart';

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





}
