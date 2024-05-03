import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String? url;
  final String? token;
  Network({this.url, this.token});

  auth(data) async {
    try {
      var fullUrl = Uri.parse(url!);
      http.Response response = await http.post(fullUrl,
          headers: {'Content-type': 'application/json'},
          body: jsonEncode(data));
      if (response.statusCode == 200) {
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

  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _token = prefs.getString('token');
    print(_token);
    final String? _name = prefs.getString('name');
    var data = {"name": _name, "token": _token};
    print(data);
    try {
      var fullUrl = Uri.parse(url!);
      http.Response response = await http.post(fullUrl,
          headers: {'Authorization': 'Bearer ${_token!}'},
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        prefs.remove('token');
        prefs.remove('name');
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
