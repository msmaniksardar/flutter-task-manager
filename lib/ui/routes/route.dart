import 'package:get/get.dart';
import 'package:task_manager/ui/screen/add_new_task.dart';
import 'package:task_manager/ui/screen/cancel_screen.dart';
import 'package:task_manager/ui/screen/complete_screen.dart';
import 'package:task_manager/ui/screen/forget_password.dart';
import 'package:task_manager/ui/screen/pin_verification_screen.dart';
import 'package:task_manager/ui/screen/progress_screen.dart';
import 'package:task_manager/ui/screen/reset_password.dart';
import 'package:task_manager/ui/screen/sign_in_screen.dart';
import 'package:task_manager/ui/screen/sign_up_screen.dart';
import 'package:task_manager/ui/screen/splash_screen.dart';
import 'package:task_manager/ui/screen/task_screen.dart';
import 'package:task_manager/ui/widget/bottom_widget.dart';

const String splash = "/";
const String login = "/login";
const String signUp = "/register";
const String pinVerify = "/verify-pin";
const String forgetPassword = "/forget-password";
const String resetPassword = "/reset-password";
const String updateProfile = "/update-profile";
const String tasks = "/task-home";
const String addNewTask = "/add-new-task";
const String cancelTask = "/cancel-task";
const String progressTask = "/progress-task";
const String completeTask = "/completed-task";
const String bottomNavigation = "/bottomNavigation";

List<GetPage> getPage = [
  GetPage(name: splash, page: () => SplashScreen()),
  GetPage(name: login, page: () => SignInScreen()),
  GetPage(name: signUp, page: () => SignUpScreen()),
  GetPage(name: tasks, page: () => TaskScreen()),
  GetPage(name: addNewTask, page: () => AddNewTask()),
  GetPage(name: cancelTask, page: () => CancelScreen()),
  GetPage(name: progressTask, page: () => ProgressScreen()),
  GetPage(name: completeTask, page: () => CompleteScreen()),
  GetPage(name: forgetPassword, page: () => ForgetPasswordScreen()),
  GetPage(name: pinVerify, page: () => PinVerificationScreen()),
  GetPage(name: resetPassword, page: () => ResetPasswordScreen()),
  GetPage(name: bottomNavigation, page: () => BottomNavigationWidget())
];
