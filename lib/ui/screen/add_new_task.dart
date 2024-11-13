import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/api/controllers/task_controller.dart';
import 'package:task_manager/api/models/network_response.dart';
import 'package:task_manager/api/services/api_client.dart';
import 'package:task_manager/api/utils/urls.dart';
import 'package:task_manager/ui/widget/app_bar.dart';
import 'package:task_manager/ui/widget/bottom_widget.dart';
import '../utility/app_colors.dart';
import '../widget/background_screen.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _shouldRefreshPreviousPage = false;
  final taskController = Get.find<TaskController>();

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, dynamic result) {
        if (didPop) {
          return;
        }
        Get.back(result: _shouldRefreshPreviousPage);
      },
      child: Scaffold(
        appBar: TMAppBar(
          isProfileScreenOpen: true,
        ),
        body: BackgroundScreen(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Text(
                  "Add New Task",
                  style: textTheme.displaySmall?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTaskForm(),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _subjectController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              hintText: "Subject",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a subject';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            maxLines: 5,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: "Description",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          Obx(() => Visibility(
                visible: taskController.inProgress.value == false,
                replacement: Center(
                  child: CircularProgressIndicator(),
                ),
                child: ElevatedButton(
                  onPressed: _onAddTaskPressed,
                  child: const Icon(
                    Icons.arrow_circle_right_outlined,
                    color: Colors.white,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  void _onAddTaskPressed() {
    if (_formKey.currentState!.validate()) {
      addTask();
    }
  }

  Future<void> addTask() async {
    final Map<String, dynamic> requestBody = {
      "title": _subjectController.text,
      "description": _descriptionController.text,
      "status": "New",
    };

    bool result = await taskController.addTask(requestBody);
    if (result) {
      _shouldRefreshPreviousPage = true;
      Get.snackbar("Task", "Task Add Successfully");
    } else {
      Get.snackbar("error", taskController.errorMessage.toString());
    }
  }
}
