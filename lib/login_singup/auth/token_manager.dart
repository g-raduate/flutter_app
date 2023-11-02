// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduate/login_singup/auth/login.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../main.dart';
class ApiClient {
  // Assume you have methods like these to retrieve tokens from secure storage
  Future<String?> getJwtToken() async {
    // Implement your logic to retrieve the JWT token
    return await secure_storage.read(key: 'token');
  }
  Future<String?> getSessionId() async {
    // Implement your logic to retrieve the JWT token
    return await secure_storage.read(key: 'sessionId');
  }
  Future<bool> isJwtTokenExpired() async {
    try {
      final String? token = await secure_storage.read(key: 'token');
      if (token == null) {
        return true;
      }
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      final int expirationTimestamp = decodedToken['exp'];
      final int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000; // Convert to seconds

      if (currentTimestamp > expirationTimestamp) {
        // Token is expired
        return true;
      } else {
        // Token is not expired
        return false;
      }
    } catch (e) {
      // Invalid token or couldn't decode it
      return true; // Assume it's expired to be safe
    }
  }
  void Jwtkicker(BuildContext context) async {
    try {
      final String? token = await secure_storage.read(key: 'token');
      if (token == null) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login(),), (route) => false);
      }
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      final int expirationTimestamp = decodedToken['exp'];
      final int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000; // Convert to seconds

      if (currentTimestamp > expirationTimestamp) {
        // Token is expired
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login(),), (route) => false);
      } else {
      }
    } catch (e) {
      // Invalid token or couldn't decode it
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login(),), (route) => false);
// Assume it's expired to be safe
    }
  }
  Future<http.Response?> makeAuthenticatedRequest(String path, Map<String, dynamic> body) async {
    final jwtToken = await getJwtToken();
    final headers= {'Authorization': 'Bearer $jwtToken','Content-Type': 'application/json'};
    var url = Uri.https(URL, path);
    bool waitexp=await isJwtTokenExpired();
    if (jwtToken != null && !waitexp) {
      // JWT token is valid, attach it to the request header
      try {
        final response = await http.post(url, headers: headers, body: jsonEncode(body));
        if (response.statusCode == 200) {
          // Handle the successful response
          return response;
        } else if (response.statusCode == 401) {
          // JWT token expired, attempt to refresh
        } else {
          // Handle other status codes
        }
      // ignore: empty_catches
      } catch (e) {
      }
    } else {
    }
  }
  Future<http.Response?> getAuthenticatedRequest(BuildContext context,String path) async {
    final jwtToken = await getJwtToken();
    final headers= {'Authorization': 'Bearer $jwtToken','Content-Type': 'application/json'};
    var url = Uri.https(URL, path);
    bool waitexp=await isJwtTokenExpired();
    final sessionId = await getSessionId();
    if (sessionId != null) {
      headers['Cookie'] = 'SessionId=$sessionId';
    }
    else
    {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login(),),(route) => false,);
    }
    if (jwtToken != null && !waitexp) {
      // JWT token is validH, attach it to the request header
      try {
        // Make the API request
        final response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {
          // Handle the successful response
          return response;
        } else if (response.statusCode == 401) {
          // JWT token expired, attempt to refresh
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login(),),(route) => false,);
        }else if (response.statusCode == 499)
          {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login(),),(route) => false,);
          }
          else {
          // Handle other status codes
        }
        // ignore: empty_catches
      } catch (e) {
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Login(),));
    }
  }

}