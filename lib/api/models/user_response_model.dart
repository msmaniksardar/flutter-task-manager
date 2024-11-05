import 'package:task_manager/api/models/user_model.dart';
class UserResponseModel {
  String? status;
  UserModel? data;
  String? token;

  UserResponseModel({this.status, this.data, this.token});

  UserResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new UserModel.fromJson(json['data']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}
