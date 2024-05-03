import 'package:flutter/material.dart';

class AppValidators {
  static String? validateFirstname(BuildContext context, String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return 'Please enter a valid first name';
    }
    return null;
  }

  static String? validateLastname(BuildContext context, String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return 'Please enter a valid last name';
    }
    return null;
  }

  static String? validateAddress(BuildContext context, String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return 'Please enter a valid address';
    }
    return null;
  }

  static String? validateCourseName(BuildContext context, String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return 'Please enter a valid course name';
    }
    return null;
  }

  static String? validateDepartmentName(BuildContext context, String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return 'Please enter a valid department name';
    }
    return null;
  }

  static String? validateBirthdate(BuildContext context, String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return 'Please select a birth date';
    } else {
      var selDate = DateTime.parse(value);
      if (selDate.isAfter(DateTime.now())) {
        return 'Birthdate cannot be greater than today!';
      }
    }

    return null;
  }

  static String? validateEnrollmentDate(BuildContext context, String value) {
    if (value.isEmpty || value.trim().isEmpty || value == '') {
      return 'Please select enrollment date';
    } else {
      print(value);
      var selDate = DateTime.parse(value);
      if (selDate.isBefore(DateTime.now())) {
        return 'Enrollment cannot be less than today!';
      }
    }

    return null;
  }

  static String? validateStudents(BuildContext context, String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return 'Please select a students';
    }
    return null;
  }

  static String? validateCourse(BuildContext context, String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return 'Please select a course';
    }

    return null;
  }

  static String? validatePassword(BuildContext context, String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return 'Please enter your password';
    }

    return null;
  }

  static String? validateEmail(BuildContext context, String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter valid email';
    }
  }
}
