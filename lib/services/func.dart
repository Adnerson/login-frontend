import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login/services/constant.dart';
import 'package:login/services/httpService.dart';

mixin Func {
  HttpService httpService = HttpService();

  Future<Response<dynamic>> sendRequest(
      {required String endpoint,
      required Method method,
      Map<String, dynamic>? params,
      String? authorizationHeader}) async {
    httpService.init(BaseOptions(
        baseUrl: baseUrl,
        contentType: "application/json",
        headers: {"Authorization": authorizationHeader}));

    final response = await httpService.request(
        endpoint: endpoint, method: method, params: params);

    return response;
  }

  // Unecessary and insecure function
  // Future<List<dynamic>> getUsers(BuildContext context) async {
  //   List<dynamic> userList = [];

  //   try {
  //     final response = await sendRequest(endpoint: users, method: Method.GET);

  //     userList = response.data as List<dynamic>;
  //   } catch (e) {
  //     // ignore: use_build_context_synchronously
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text("Failed to fetch lists: $e")));
  //   }

  //   return userList;
  // }

// two arguments are in the list:
// isVerified (boolean) and user-id (string)

  signUp(BuildContext context, String username, String email,
      String password) async {
    try {
      await sendRequest(endpoint: users, method: Method.POST, params: {
        "username": username,
        "email": email,
        "password": password,
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Username / Email Taken")));
    }
  }

  Future<Map<String, dynamic>> verifyUser(
      BuildContext context, String username, String password) async {
    Map<String, dynamic> userArgs = {};

    try {
      final response =
          await sendRequest(endpoint: login, method: Method.POST, params: {
        "username": username,
        "password": password,
      });

      userArgs = response.data as Map<String, dynamic>;
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid Credentials")));
    }

    return userArgs;
  }

// 1 == logged in, 0 = logged out.
  rememberUser(String userId, rememberMeValue) async {
    if (rememberMeValue) {
      await sendRequest(
        endpoint: redis,
        method: Method.POST,
        params: {"user-id": userId, "loggedin": 1},
      );
    }
  }

  forgetUser(String userId) async {
    await sendRequest(
      endpoint: redis,
      method: Method.POST,
      params: {"user-id": userId, "loggedin": 0},
    );
  }

  //   Refactored to make it extremely clear on what is happening

  //   setLoginStatus(String userId, bool rememberMeValue) async {
  //   // 1 = logged in, 0 = logged out.
  //   int status = rememberMeValue ? 1 : 0;

  //   await sendRequest(
  //     endpoint: redis,
  //     method: Method.POST,
  //     params: {"user-id": userId, "loggedin": status},
  //   );
  // }

  // getLoginStatus(String userId, BuildContext context) async {
  //   final response = await sendRequest(
  //       endpoint: redis,
  //       method: Method.GET,
  //       params: {"user-id": userId}).then((value) => value);
  //   // is .then necessary?
  //   if (context.mounted) {
  //     if (response.data['success']) {
  //       switch (response.data['message']) {
  //         case 1:
  //           print('logged in ');
  //           break;
  //         default:
  //           print(' go to signin');
  //           // Navigate to signin
  //           break;
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text(response.data['message'])));
  //     }
  //   }
  // }

  Future<int> getLoginStatus(String userId, BuildContext context) async {
    final response = await sendRequest(
        endpoint: redis,
        method: Method.GET,
        params: {"user-id": userId}).then((value) => value);
    // is .then necessary?
    if (context.mounted && response.data['success']) {
      return response.data['message'];
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.data['message'])));
      return 0;
    }
  }

  storeUserIdLocally(String userId, bool rememberMeValue) async {
    const storage = FlutterSecureStorage();

    if (rememberMeValue) {
      await storage.write(
        key: 'user_id',
        value: userId,
      );
    }
  }

  Future<String?> getUserIdLocally() async {
    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: 'user_id');

    return userId;
  }

  deleteUserId() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'user_id');
  }
}
