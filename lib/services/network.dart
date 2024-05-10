import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String? url;
  final String? token;
  Network({this.url, this.token});
  final String appKey = 'base64:Nm/dNVkgdp/UxOB1rLG4GGYcqiUDrtQ4C/nvw/bFxH4=';

  auth(data) async {
    try {
      var fullUrl = Uri.parse(url!);
      http.Response response = await http.post(fullUrl,
          headers: {'Content-type': 'application/json'},
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Authentication Failed. ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error making the request: $e');
      return null;
    }
  }

  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _token = prefs.getString('token');
    final String? _fName = prefs.getString('firstName');
    final String? _lName = prefs.getString('lastName');
    var data = {"firstName": _fName, "lastName": _lName, "token": _token};
    try {
      var fullUrl = Uri.parse(url!);
      http.Response response = await http.post(fullUrl,
          headers: {'Authorization': 'Bearer ${_token!}'},
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        prefs.remove('token');
        prefs.remove('_fName');
        prefs.remove('_lName');
        return jsonDecode(response.body);
      } else {
        print('Error adding data. ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error making the request: $e');
      return null;
    }
  }

  getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _token = prefs.getString('token');
    print(_token);
    var fullUrl = Uri.parse(url!);
    http.Response response = await http
        .get(fullUrl, headers: {'Authorization': 'Bearer ${_token!}'});
    try {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        print('Error : ${response.statusCode}');
        var errorResponse = {
          "success": false,
          "message": 'Unauthorized User',
        };
        return errorResponse;
      }
    } catch (e) {
      print(e);
    }
  }

  updateData(data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _token = prefs.getString('token');
    try {
      var fullUrl = Uri.parse(url!);
      http.Response response = await http.put(
        fullUrl,
        headers: {
          'X-API-KEY': appKey,
          'Authorization': 'Bearer ${_token!}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print('Error adding data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error making the request: $e');
      return null;
    }
  }

  addData(data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _token = prefs.getString('token');
    print('token : $_token');
    try {
      var fullUrl = Uri.parse(url!);
      http.Response response = await http.post(
        fullUrl,
        headers: {
          'Authorization': 'Bearer ${_token!}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print('Error adding data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error making the request: $e');
      return null;
    }
  }

  deleteData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _token = prefs.getString('token');
    try {
      var fullUrl = Uri.parse(url!);
      http.Response response = await http.delete(
        fullUrl,
        headers: {
          'Authorization': 'Bearer ${_token!}',
          'Content-Type': 'application/json'
        },
      );
      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        print('Error adding data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error making the request: $e');
      return null;
    }
  }
}
