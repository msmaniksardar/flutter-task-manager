import 'package:flutter/material.dart';
import 'package:task_manager/ui/widget/app_bar.dart';

class CompleteScreen extends StatefulWidget {
  const CompleteScreen({super.key});

  @override
  State<CompleteScreen> createState() => _CompleteScreenState();
}

class _CompleteScreenState extends State<CompleteScreen> {
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

            const SizedBox(height: 10), // Spacing after header
            Expanded(
              // To avoid overflow errors, wrap ListView in Expanded
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return _buildTaskInfo();
                },
                itemCount: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Content
  Widget _buildTaskInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              // Lighter, softer shadow color
              spreadRadius: 0.5,
              // Minimal spread for more subtle effect
              blurRadius: 8,
              // Larger blur for a soft shadow
              offset: const Offset(2, 4), // Slight offset for depth
            ),
          ],
          // Adding rounded corners for a polished look
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Lorem ipsum is simply dummy"),
              const Text("Hello I am not agree with you for this project"),
              const Text("Date : 10/12/2003"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Chip(label: Text("Complete")),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            _onTabUpdateButton();
                          },
                          icon: const Icon(Icons.update)),
                      IconButton(
                          onPressed: () {
                            _onTabDeleteButton();
                          },
                          icon: const Icon(Icons.delete))
                    ],
                  )
                ],
              )
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
                      ))
                  .toList(),
            ),
            actions: [
              TextButton(onPressed: () {}, child: Chip(label: Text("Okay"))),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Chip(label: Text("Cancel"))),
            ],
          );
        });
  }

  void _onTabDeleteButton() {}
}
