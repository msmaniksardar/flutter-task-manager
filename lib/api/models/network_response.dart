class NetworkResponse {
  bool isSuccess;
  dynamic data;
  int statusCode;
  String? isError;

  NetworkResponse({
    required this.isSuccess ,
    this.data,
    required this.statusCode,
    this.isError = "INTERNAL SERVER ERROR",
  });

  factory NetworkResponse.success({
    required dynamic data,
    required int statusCode,
    required bool isSuccess,
  }) {
    return NetworkResponse(
      isSuccess: isSuccess,
      data: data,
      statusCode: statusCode,
    );
  }

  factory NetworkResponse.error({
    required String error,
    required int statusCode,
    required bool isSuccess, // Defaulting to 500 for server errors
  }) {
    return NetworkResponse(
      isSuccess: isSuccess,
      statusCode: statusCode,
      isError: error,
    );
  }
}
