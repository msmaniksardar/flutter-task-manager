import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/api/controllers/count_controller.dart';
import 'package:task_manager/api/controllers/task_controller.dart';
import 'package:task_manager/api/models/list_of_status_model.dart';
import 'package:task_manager/api/models/network_response.dart';
import 'package:task_manager/api/models/task_list_model.dart';
import 'package:task_manager/api/models/task_model.dart';
import 'package:task_manager/api/services/api_client.dart';
import 'package:task_manager/api/utils/urls.dart';
import 'package:task_manager/ui/screen/add_new_task.dart';
import 'package:task_manager/ui/widget/app_bar.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  String _status = "New";
  final countController = Get.find<CountController>();

  @override
  void initState() {
    super.initState();
    getNewTask();
    countTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          await getNewTask();
          await countTask();
        },
        child: Obx(()=>Visibility(
          visible: Get.find<TaskController>().inProgress.value == false,
          replacement: Center(child: CircularProgressIndicator(),),

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10), // Spacing before header
               Obx(()=> _buildTaskHeader()), // Header section
                const SizedBox(height: 10), // Spacing after header
                Get.find<TaskController>().inProgress.value
                    ? Center(child: CircularProgressIndicator())
                    : Expanded(
                  child: ListView.builder(
                    itemCount: Get.find<TaskController>().taskList.length,
                    itemBuilder: (context, index) {
                      return _buildTaskInfo(Get.find<TaskController>().taskList[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {
          final bool result = await  Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddNewTask()));
          if(result == true){
            getNewTask();
            countTask();
          }
           print("navigation page route : ${result}");
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Content
  Widget _buildTaskInfo(TaskModel task) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0.5,
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.title ?? ""),
              Text(task.description ?? ""),
              Text("Date: ${task.createdDate ?? ""}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Chip(label: Text(task.status ?? "")),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          final id = task.id;
                          _onTabUpdateButton(id);
                        },
                        icon: const Icon(Icons.update),
                      ),
                      IconButton(
                        onPressed: () {
                          final id = task.id;
                          _onTabDeleteButton(id);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTaskHeader() {

    final taskList = countController.taskStatusList.map((status)=>
      _buildTaskStatusCard(count: status.sum.toString(), label: status.id.toString())
      ).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:taskList,
      ),
    );
  }

  // Widget for each status card
  Widget _buildTaskStatusCard({required String count, required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        width: 100,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0.5,
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                ),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTabUpdateButton(id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ["New", "Completed", "Canceled", "Progress"]
                .map((status) => ListTile(
                      title: Text(status),
                      onTap: () {
                        updateTask(id, status);
                        Navigator.pop(context);
                      },
                    ))
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Chip(label: Text("Cancel")),
            ),
          ],
        );
      },
    );
  }

  void _onTabDeleteButton(id) {
    deleteTask(id);
    getNewTask();
    countTask();
  }

  Future<void> deleteTask(id) async {
    NetworkResponse response =
        await ApiClient.getRequest(NetworkURL.deleteTaskUrl + "/${id}");
    if (response.isSuccess) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Task Delete Successfully")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.isError.toString())));
    }
  }

  Future<void> updateTask(id, status) async {
    NetworkResponse response = await ApiClient.getRequest(
        NetworkURL.updateTaskStatusUrl + "/${id}/${status}");
    if (response.isSuccess) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Status Update Successfully")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.isError.toString())));
    }
  }

  Future<void> getNewTask() async {
      bool result = await Get.find<TaskController>().getTask(status: _status);
    if (result ==  false) {
      Get.snackbar("error",  Get.find<TaskController>().errorMessage.toString());
    }
  }

  Future<void> countTask() async {
      bool result = await countController.countTask();
      if(result == false){
        Get.snackbar("error", countController.errorMessage.toString());
      }
  }
}
