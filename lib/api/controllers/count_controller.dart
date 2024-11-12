import 'package:get/get.dart';
import 'package:task_manager/api/models/list_of_status_model.dart';
import 'package:task_manager/api/models/network_response.dart';
import 'package:task_manager/api/services/api_client.dart';
import 'package:task_manager/api/utils/urls.dart';

class CountController extends GetxController {
  final RxBool _inProgress = false.obs;
  final RxBool _isSuccess = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxList<ListOfStatusModel> taskStatusList = <ListOfStatusModel>[].obs;

  // Public getters for the private Rx variables
  RxString get errorMessage => _errorMessage;

  RxBool get inProgress => _inProgress;

  RxBool get isSuccess => _isSuccess;

  RxList<ListOfStatusModel> get statusList => taskStatusList;

  // Fetch task status counts and update taskStatusList
  Future<bool> countTask() async {
    taskStatusList.clear(); // Clear previous data
    _inProgress.value = true; // Set in progress to true

    NetworkResponse response =
        await ApiClient.getRequest(NetworkURL.taskStatusCountUrl);

    if (response.isSuccess) {
      Map<String, dynamic> statusList = response.data;

      taskStatusList.clear();

      for (var data in statusList["data"]) {
        ListOfStatusModel listOfStatusModel = ListOfStatusModel(
          id: data["_id"],
          sum: data["sum"],
        );
        taskStatusList.add(listOfStatusModel);
      }

      _isSuccess.value = true; // Mark success
      _errorMessage.value = ''; // Clear any previous error messages
    } else {
      _errorMessage.value = response.isError?.toString() ?? 'Unknown error';
    }

    _inProgress.value = false; // Set in progress to false after operation

    return _isSuccess.value; // Return the success status
  }
}
