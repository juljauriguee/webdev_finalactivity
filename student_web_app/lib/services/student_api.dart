import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';

class StudentApi {
  static const baseUrl = 'http://127.0.0.1:8000/api/students';
  static const headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<List<Student>> getStudents() async {
    final response = await http.get(Uri.parse(baseUrl), headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to load students (${response.statusCode})');
    }
    final List<dynamic> data = jsonDecode(response.body);
    return data
        .map((item) => Student.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<Student> addStudent(String name, String course) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode({'name': name, 'course': course}),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add student (${response.statusCode})');
    }
    return Student.fromJson(jsonDecode(response.body));
  }

  static Future<Student> updateStudent(
      int id, String name, String course) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: headers,
      body: jsonEncode({'name': name, 'course': course}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update student (${response.statusCode})');
    }
    return Student.fromJson(jsonDecode(response.body));
  }

  static Future<void> deleteStudent(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: headers,
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete student (${response.statusCode})');
    }
  }
}