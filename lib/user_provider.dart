import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:user_management/user_model.dart';

class UserProvider extends ChangeNotifier {
  List<UserModel> users = [];
  String? _imageUrl;
  String? get imageUrl => _imageUrl;
  int? _totalUsers;

  int? get usersTotal => _totalUsers;

  void setImageUrl(String imageUrl) {
    _imageUrl = imageUrl;
    notifyListeners();
  }

  Future<bool> getUserApi() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://69b6234f583f543fbd9d0929.mockapi.io/api/pract/v1/users",
        ),
      );
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        users.clear();
        for (var i in data) {
          users.add(UserModel.fromJson(i));
        }
        _totalUsers = users.length;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> postUserApi(UserModel userModel) async {
    try {
      final response = await http.post(
        Uri.parse(
          "https://69b6234f583f543fbd9d0929.mockapi.io/api/pract/v1/users",
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userModel),
      );

      if (response.statusCode == 201) {
        _imageUrl = null;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteUserApi(String id) async {
    try {
      final response = await http.delete(
        Uri.parse(
          "https://69b6234f583f543fbd9d0929.mockapi.io/api/pract/v1/users/$id",
        ),
      );

      if (response.statusCode == 200) {
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUserApi(String id, UserModel userModel) async {
    try {
      final response = await http.put(
        Uri.parse(
          "https://69b6234f583f543fbd9d0929.mockapi.io/api/pract/v1/users/$id",
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userModel),
      );
      if (response.statusCode == 200) {
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
