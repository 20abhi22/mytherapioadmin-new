// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:flutter/material.dart';

class API {
  // static String baseurl = "https://jobnews.me/mytherapyio";
  static const String baseurl = "http://10.253.67.63:3000/mytherapyio";
  // static String baseasseturl =
  //     "https://www.aspiringcinematictalents.com/storage/";

  static const String baseAssetUrl =
      "http://10.253.67.63:3000/mytherapyio/uploads/admin_docs/";

  static const String staticAssetUrl =
      "http://10.253.67.63:3000/mytherapyio/uploads/static/";

  static final Dio dio = initializeDio("");

  static Map<String, dynamic> _responseMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);

    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {
        // Fall through to a readable API error below.
      }

      return {
        'status': 'error',
        'message': data.isEmpty ? 'Empty response from server' : data,
      };
    }

    return {
      'status': 'error',
      'message': 'Unexpected response from server',
    };
  }

  static Map<String, dynamic> _responseMapFromResponse(Response response) {
    final data = _responseMap(response.data);
    final statusCode = response.statusCode ?? 0;

    if (statusCode >= 200 && statusCode < 300) return data;

    return {
      ...data,
      'status':
          data['status'] == 'success' ? 'error' : data['status'] ?? 'error',
      'message': data['message'] ?? 'Request failed. Please try again.',
      'status_code': statusCode,
    };
  }

  static String _fileName(File file) {
    return file.path.split(Platform.pathSeparator).last;
  }

  static Future<void> _saveAuthTokenIfPresent(Map<String, dynamic> data) async {
    final token = data['token'];
    if (token is String && token.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
    }
  }

  static Dio initializeDio(String model) {
    Dio dio = Dio(
      BaseOptions(
        baseUrl: baseurl,
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        validateStatus: (status) => true,
        connectTimeout: const Duration(minutes: 2),
        receiveTimeout: const Duration(minutes: 2),
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            print(token);
          }

          print("Request URL: ${options.baseUrl}${options.path}");
          print(options.headers);
          return handler.next(options);
        },
        onResponse: (response, handler) async {
          log(response.data.toString());
          return handler.next(response);
        },
        onError: (error, handler) async {
          if (error.error is SocketException) {
            API.showSnackBar("error", "Please check your internet connection");
          }
          return handler.next(error);
        },
      ),
    );
    return dio;
  }

  static String formatDate(String dateString) {
    DateTime date = DateFormat('yyyy-M-d').parse(dateString);

    String formattedDate = DateFormat('dd / MM / yyyy').format(date);

    return formattedDate;
  }

  static Future<bool> checkInternetAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }

  static void showSnackBar(String title, String message) {
    try {
      Get.snackbar(title, message,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12));
    } catch (e) {
      // Fallback to logging if Get isn't available at runtime
      log('showSnackBar error: $e');
    }
  }

  //t=ith ore samokle ne tannatha , ith pole vilicha mathi api
  static Future<dynamic> registerUserAPI(
    String name,
    String email,
    String password,
    String confirmpassword,
    String phoneCode,
    String phoneNumber,
  ) async {
    try {
      final response = await dio.post(
        'registration',
        data: {
          "name": name,
          "email": email,
          "password": password,
          "c_password": confirmpassword,
          "phone_code": phoneCode,
          "phone": phoneNumber,
        },
      );
      print(response.data);
      //shared pref store akan marakale
      return response.data;
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  // static Future<dynamic> registerAdminAPI({
  //   required String firstName,
  //   required String lastName,
  //   required String countryCode,
  //   required String phone,
  //   required String fcmToken,
  //   String? gmail,
  //   String? latitude,
  //   String? longitude,
  // }) async {
  //   try {
  //     final response = await dio.post(
  //       '/auth/admin/register',
  //       data: {
  //         "first_name": firstName,
  //         "last_name": lastName,
  //         "country_code": countryCode,
  //         "phone": phone,
  //         "fcm_token": fcmToken,
  //         if (gmail != null && gmail.isNotEmpty) "gmail": gmail,
  //         if (latitude != null) "latitude": latitude,
  //         if (longitude != null) "longitude": longitude,
  //       },
  //     );
  //     final data = _responseMap(response.data);
  //     await _saveAuthTokenIfPresent(data);
  //     return data;
  //   } catch (e) {
  //     return {'status': 'error', 'message': e.toString()};
  //   }
  // }

  static Future<dynamic> registerAdminAPI({
  required String firstName,
  required String lastName,
  required String countryCode,
  required String phoneCode,
  required String phone,
  required String fcmToken,
  String? gmail,
  String? latitude,
  String? longitude,
}) async {
  try {
    final response = await dio.post(
      '/auth/admin/register',
      data: {
        "first_name": firstName,
        "last_name": lastName,
        "country_code": countryCode,
        "phone_code": phoneCode,
        "phone": phone,
        "fcm_token": fcmToken,
        "gmail": gmail ?? "",
        "latitude": latitude ?? "",
        "longitude": longitude ?? "",
      },
    );

    final data = _responseMapFromResponse(response);

    await _saveAuthTokenIfPresent(data);

    return data;
  } on DioException catch (e) {
    return {
      'status': 'error',
      'message': e.response?.data is Map
          ? (_responseMap(e.response?.data)['message'] ??
              'Registration failed. Please try again.')
          : (e.message ?? 'Registration failed. Please try again.'),
    };
  } catch (e) {
    return {
      'status': 'error',
      'message': e.toString(),
    };
  }
}

  static Future<dynamic> verifyOtpAPI({
    required String otp,
  }) async {
    try {
      final response = await dio.post(
        '/auth/verify-otp',
        data: {
          "otp": otp,
        },
      );
      final data = _responseMap(response.data);
      await _saveAuthTokenIfPresent(data);
      return data;
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  static Future<dynamic> verifyLoginOtpAPI({
    required String otp,
  }) async {
    try {
      final response = await dio.post(
        '/auth/login/verify-otp',
        data: {
          "otp": otp,
        },
      );

      final data = _responseMap(response.data);
      await _saveAuthTokenIfPresent(data);

      return data;
    } catch (e) {
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }

  static Future<dynamic> resendOtpAPI() async {
    try {
      final response = await dio.post('/auth/admin/resend-otp');
      return _responseMap(response.data);
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  static Future<dynamic> loginSendOtpAPI({
    required String countryCode,
    required String phoneCode,
    required String phone,
  }) async {
    try {
      final response = await dio.post(
        '/auth/admin/login',
        data: {
          "country_code": countryCode,
          "phone_code": phoneCode,
          "phone": phone,
        },
      );
      final data = _responseMap(response.data);
      await _saveAuthTokenIfPresent(data);
      return data;
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  static Future<dynamic> getAdminProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        return {
          'status': 'error',
          'message': 'Please login again to view your profile.',
        };
      }

      final response = await dio.get('/users/admin/profile');
      return _responseMapFromResponse(response);
    } on DioException catch (e) {
      return {
        'status': 'error',
        'message': e.response?.data is Map
            ? (_responseMap(e.response?.data)['message'] ??
                'Profile fetch failed. Please try again.')
            : (e.message ?? 'Profile fetch failed. Please try again.'),
      };
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  // static Future<dynamic> uploadAdminDocuments({
  //   required File profilePhoto,
  //   required File aadharCard,
  //   required File certificate,
  // }) async {
  //   try {
  //     final formData = FormData.fromMap({
  //       "profile_photo": await MultipartFile.fromFile(
  //         profilePhoto.path,
  //         filename: profilePhoto.path.split('/').last,
  //       ),
  //       "aadhar_card": await MultipartFile.fromFile(
  //         aadharCard.path,
  //         filename: aadharCard.path.split('/').last,
  //       ),
  //       "certificate": await MultipartFile.fromFile(
  //         certificate.path,
  //         filename: certificate.path.split('/').last,
  //       ),
  //     });

  //     final response = await dio.post(
  //       '/admin/upload-documents',
  //       data: formData,
  //     );

  //     return response.data;
  //   } catch (e) {
  //     return {'status': 'error', 'message': e.toString()};
  //   }
  // }

  static Future<dynamic> uploadAdminDocuments({
    required File profilePhoto,
    required File aadharCard,
    required File certificate,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        return {
          'status': 'error',
          'message': 'Please login again before uploading documents.',
        };
      }

      final formData = FormData.fromMap({
        'profile_photo': await MultipartFile.fromFile(
          profilePhoto.path,
          filename: _fileName(profilePhoto),
        ),
        'aadhar_card': await MultipartFile.fromFile(
          aadharCard.path,
          filename: _fileName(aadharCard),
        ),
        'certificate': await MultipartFile.fromFile(
          certificate.path,
          filename: _fileName(certificate),
        ),
      });

      final response = await dio.post(
        '/admin/upload-documents',
        data: formData,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );

      return _responseMapFromResponse(response);
    } on DioException catch (e) {
      return {
        'status': 'error',
        'message': e.response?.data is Map
            ? (_responseMap(e.response?.data)['message'] ??
                'Upload failed. Please try again.')
            : (e.message ?? 'Upload failed. Please try again.'),
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }

  static Future<dynamic> updateAdminProfile({
  String? firstName,
  String? lastName,
  String? countryCode,
  String? phoneCode,
  String? phone,
  String? gmail,
  String? latitude,
  String? longitude,
  String? bio,
  String? roleTitle,
  String? specialization,
  String? locationName,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      return {
        'status': 'error',
        'message': 'Please login again before updating profile.',
      };
    }

    final Map<String, dynamic> body = {};

    if (firstName != null) body['first_name'] = firstName;
    if (lastName != null) body['last_name'] = lastName;
    if (countryCode != null) body['country_code'] = countryCode;
    if (phoneCode != null) body['phone_code'] = phoneCode;
    if (phone != null) body['phone'] = phone;
    if (gmail != null) body['gmail'] = gmail;
    if (latitude != null) body['latitude'] = latitude;
    if (longitude != null) body['longitude'] = longitude;
    if (bio != null) body['bio'] = bio;
    if (roleTitle != null) body['role_title'] = roleTitle;
    if (specialization != null) body['specialization'] = specialization;
    if (locationName != null) body['location_name'] = locationName;

    if (body.isEmpty) {
      return {
        'status': 'error',
        'message': 'No profile details provided to update.',
      };
    }

    final response = await dio.put(
      '/users/admin/profile/update',
      data: body,
    );

    return _responseMapFromResponse(response);
  } on DioException catch (e) {
    return {
      'status': 'error',
      'message': e.response?.data is Map
          ? (_responseMap(e.response?.data)['message'] ??
              'Profile update failed. Please try again.')
          : (e.message ?? 'Profile update failed. Please try again.'),
    };
  } catch (e) {
    return {
      'status': 'error',
      'message': e.toString(),
    };
  }
}

  static Future<dynamic> updateAdminDocument({
    required File documentFile,
    required String docType,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        return {
          'status': 'error',
          'message': 'Please login again before updating documents.',
        };
      }

      const allowedDocTypes = [
        'profile_photo',
        'aadhar_card',
        'certificate',
        'profile',
      ];

      if (!allowedDocTypes.contains(docType)) {
        return {
          'status': 'error',
          'message':
              'Invalid document type. Use profile_photo, aadhar_card, certificate, or profile.',
        };
      }

      final formData = FormData.fromMap({
        docType: await MultipartFile.fromFile(
          documentFile.path,
          filename: _fileName(documentFile),
        ),
      });

      final response = await dio.put(
        '/admin/update-document',
        data: formData,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );

      return _responseMapFromResponse(response);
    } on DioException catch (e) {
      return {
        'status': 'error',
        'message': e.response?.data is Map
            ? (_responseMap(e.response?.data)['message'] ??
                'Document update failed. Please try again.')
            : (e.message ?? 'Document update failed. Please try again.'),
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }
}
