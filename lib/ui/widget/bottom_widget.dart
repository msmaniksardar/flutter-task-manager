import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/screen/add_new_task.dart';
import 'package:task_manager/ui/screen/cancel_screen.dart';
import 'package:task_manager/ui/screen/complete_screen.dart';
import 'package:task_manager/ui/screen/progress_screen.dart';
import 'package:task_manager/ui/screen/task_screen.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({super.key});

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  final RxInt currentIndex = 0.obs;

  final List<Widget> _screen = [
    TaskScreen(),
    CompleteScreen(),
    CancelScreen(),
    ProgressScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _screen[currentIndex.value]),
      bottomNavigationBar: Obx(() => NavigationBar(
            selectedIndex: currentIndex.value,
            animationDuration: Duration(seconds: 1),
            indicatorColor: Colors.green,
            backgroundColor: Colors.white,
            onDestinationSelected: (int index) {
              currentIndex.value = index;
            },
            destinations: [
              NavigationDestination(
                  icon: Icon(
                    Icons.new_label,
                  ),
                  label: "New Task"),
              NavigationDestination(
                  icon: Icon(Icons.check_box), label: "Completed"),
              NavigationDestination(
                  icon: Icon(Icons.cancel), label: "Canceled"),
              NavigationDestination(
                  icon: Icon(Icons.pending), label: "Progress"),
            ],
          )),
    );
  }
}
