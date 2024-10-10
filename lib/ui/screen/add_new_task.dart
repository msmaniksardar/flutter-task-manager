import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/api/models/network_response.dart';
import 'package:task_manager/api/services/api_client.dart';
import 'package:task_manager/api/utils/urls.dart';
import 'package:task_manager/ui/widget/app_bar.dart';

import '../utility/app_colors.dart';
import '../widget/background_screen.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final TextEditingController _subjectTextEditingController =
      TextEditingController();
  final TextEditingController _descriptionTextEditingController =
      TextEditingController();

  @override
  void dispose() {
    _subjectTextEditingController.dispose();
    _descriptionTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: TMAppBar( isProfileScreenOpen: true,),
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
              _buildSignInForm(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Column(
      children: [
        TextFormField(
          controller: _subjectTextEditingController,
          decoration: const InputDecoration(
            hintText: "Subject",
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          maxLines: 5,
          controller: _descriptionTextEditingController,
          decoration: const InputDecoration(
            hintText: "Description",
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: _onTabAddTask,
          child: const Icon(
            Icons.arrow_circle_right_outlined,
            color: Colors.white,
          ),
        ),
      ],
    );
  }



  void _onTabAddTask() {

  }

  Future<void> addTask()async{

    Map<String ,dynamic> requestBody = {

    };

    NetworkResponse response = await ApiClient.postRequest(NetworkURL.createTaskUrl, requestBody);
  }




}
