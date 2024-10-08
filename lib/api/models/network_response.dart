class NetworkResponse {
  bool isSuccess;
  dynamic data;
  int statusCode;
  String? isError;

  NetworkResponse(
      {this.isSuccess = false,
      this.data,
      this.statusCode = 200,
      this.isError = "INTERNAL SERVER ERROR"});

  factory NetworkResponse.success(
      {required Map<String, dynamic> data, statusCode}) {
    return NetworkResponse(
      isSuccess: true,
      data: data,
      statusCode: statusCode,
    );
  }

  factory NetworkResponse.error({required String error, statusCode}) {
    return NetworkResponse(
        isSuccess: false, statusCode: statusCode, isError: error);
  }
}
