// ignore: file_names
import 'dart:convert';

import 'package:dio/dio.dart';

enum Method { POST, GET, DELETE, PATCH }

class HttpService {
  Dio? _dio;

  Future<HttpService> init(BaseOptions options) async {
    _dio = Dio(options);
    return this;
  }

  request(
      {required String endpoint,
      required Method method,
      Map<String, dynamic>? params,
      Map<String, dynamic>? queryParams}) async {
    Response response;

    try {
      switch (method) {
        case Method.GET:
          response = await _dio!.get(endpoint,
              queryParameters: queryParams, data: json.encode(params));
          break;
        case Method.POST:
          response = await _dio!.post(endpoint, data: json.encode(params));
          break;
        case Method.DELETE:
          response = await _dio!.delete(endpoint);
          break;
        case Method.PATCH:
          response = await _dio!.patch(endpoint, data: json.encode(params));
          break;
      }
      return response;
    } on DioException catch (e) {
      return Response(
        requestOptions: RequestOptions(path: endpoint),
        statusCode: e.response?.statusCode ?? 500,
        statusMessage: e.message,
        data: e.response?.data ?? {'message': 'An error occurred'},
      );
    }
  }
}
