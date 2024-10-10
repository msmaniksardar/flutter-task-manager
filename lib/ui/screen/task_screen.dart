import 'package:flutter/material.dart';
import 'package:task_manager/api/models/network_response.dart';
import 'package:task_manager/api/models/task_list_model.dart';
import 'package:task_manager/api/services/api_client.dart';
import 'package:task_manager/api/utils/urls.dart';
import 'package:task_manager/ui/widget/app_bar.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  String _status = "New";
  bool isLoading = false;
  List<TaskList> taskList = [];

  @override
  void initState() {
    super.initState();
    getNewTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10), // Spacing before header
            _buildTaskHeader(), // Header section
            const SizedBox(height: 10), // Spacing after header
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: taskList.length,
                      itemBuilder: (context, index) {
                        return _buildTaskInfo(taskList[index]);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  // Content
  Widget _buildTaskInfo(TaskList task) {
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
              Text(task.title),
              Text(task.description),
              Text("Date: ${task.createdAt}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Chip(label: Text(task.status)),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _onTabUpdateButton();
                        },
                        icon: const Icon(Icons.update),
                      ),
                      IconButton(
                        onPressed: () {
                          _onTabDeleteButton();
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

  // Header widget
  Widget _buildTaskHeader() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTaskStatusCard("09", "New Task"),
          _buildTaskStatusCard("09", "Completed"),
          _buildTaskStatusCard("05", "Canceled"),
          _buildTaskStatusCard("09", "Progress"),
        ],
      ),
    );
  }

  // Widget for each status card
  Widget _buildTaskStatusCard(String count, String label) {
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

  void _onTabUpdateButton() {
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
                        // Handle status update logic here
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

  void _onTabDeleteButton() {
    // Add delete logic here
  }

  Future<void> getNewTask() async {
    setState(() {
      isLoading = true;
    });
    NetworkResponse response =
        await ApiClient.getRequest(NetworkURL.listByStatus + "/$_status");
    if (response.isSuccess) {
      List<dynamic> data = response.data["data"];
      final tasks = data
          .map((item) => TaskList(
                id: item["id"] ?? "",
                title: item["title"] ?? "",
                description: item["description"] ?? "",
                status: item["status"] ?? "",
                email: item["email"] ?? "",
                createdAt: item["createdDate"] ?? "",
              ))
          .toList();
      setState(() {
        taskList = tasks;
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.isError.toString())),
      );
      setState(() {
        isLoading = false;
      });
    }
  }
}
