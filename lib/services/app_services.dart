import 'package:crud_app/services/network.dart';
import 'package:flutter/cupertino.dart';

const enrollmentApiUrl = 'http://10.0.2.2:8000/api/enrollments';
const studentApiUrl = 'http://10.0.2.2:8000/api/students';
const departmentApiUrl = 'http://10.0.2.2:8000/api/departments';
const courseApiUrl = 'http://10.0.2.2:8000/api/courses';

class AppServices extends ChangeNotifier {
  Future registerAccount(data) async {
    Network network = Network(url: 'http://10.0.2.2:8000/api/register');
    var accData = await network.auth(data);

    if (accData != null) {
      return accData;
    } else {
      print('Error adding this account.');
    }
  }

  Future loginAccount(data) async {
    Network network = Network(url: 'http://10.0.2.2:8000/api/login');
    var accData = await network.auth(data);

    if (accData != null) {
      return accData;
    } else {
      print('Error login.');
    }
  }

  Future logout() async {
    Network network = Network(url: 'http://10.0.2.2:8000/api/logout');
    var accData = await network.logout();

    if (accData != null) {
      return accData;
    } else {
      print('Error logout.');
    }
  }

  Future<List<dynamic>> getEnrollmentData() async {
    Network network = Network(url: enrollmentApiUrl);
    var enrollmentData = await network.getData();
    if (enrollmentData != null) {
      return enrollmentData['data'];
    } else {
      return [];
    }
  }

  Future<List<dynamic>> getDepartmentsData() async {
    Network network = Network(url: departmentApiUrl);
    var depData = await network.getData();
    if (depData != null) {
      return depData['data'];
    } else {
      return [];
    }
  }

  Future<List<dynamic>> getStudentsData() async {
    Network network = Network(url: studentApiUrl);
    var studentData = await network.getData();
    if (studentData != null) {
      return studentData['data'];
    } else {
      return [];
    }
  }

  Future<List<dynamic>> getCourseData() async {
    Network network = Network(url: courseApiUrl);
    var courseData = await network.getData();
    if (courseData != null) {
      return courseData['data'];
    } else {
      return [];
    }
  }

  Future addEnrollmentData(data) async {
    Network network = Network(url: enrollmentApiUrl);
    var enrollmentData = await network.addData(data);
    if (enrollmentData != null) {
      notifyListeners();
      return enrollmentData;
    } else {
      print('Error adding data.');
    }
  }

  Future updateEnrollmentData(data, id) async {
    Network network = Network(url: '$enrollmentApiUrl/$id');
    var res = await network.updateData(data);
    if (res != null) {
      notifyListeners();
      return res;
    } else {
      print('Error updating data.');
    }
  }

  Future deleteEnrollmentData(id) async {
    Network network = Network(url: '$enrollmentApiUrl/$id');
    var res = await network.deleteData();
    if (res != null) {
      notifyListeners();
      return res;
    } else {
      print('Error deleting data.');
    }
  }

  Future addStudentData(data) async {
    Network network = Network(url: studentApiUrl);
    var studData = await network.addData(data);
    if (studData != null) {
      notifyListeners();
      return studData;
    } else {
      print('Error adding data.');
    }
  }

  Future updateStudentData(data, id) async {
    if (id == null) {
      print('Error: no data to update.');
      return;
    }
    Network network = Network(url: '$studentApiUrl/$id');

    var courseData = await network.updateData(data);
    if (courseData != null) {
      notifyListeners();
      return courseData;
    } else {
      print('Error updating data.');
    }
  }

  Future deleteStudentData(id) async {
    Network network = Network(url: '$studentApiUrl/$id');
    var res = await network.deleteData();
    if (res != null) {
      notifyListeners();
      return res;
    } else {
      print('Failed to delete data.');
    }
  }

  Future addCourseData(data) async {
    if (data['courseName'] == null) {
      print('Error: courseName is null.');
      return;
    }

    Network network = Network(url: '$courseApiUrl');
    var dataToAdd = {
      'courseName': data['courseName'],
      'departmentId': data['departmentId'],
    };
    var courseData = await network.addData(dataToAdd);
    if (courseData != null) {
      notifyListeners();
      return courseData;
    } else {
      print('Error adding data.');
    }
  }

  Future updateCourseData(data, id) async {
    if (id == null) {
      print('Error: no data to update.');
      return;
    }
    Network network = Network(url: '$courseApiUrl/$id');
    var update_data = {
      'courseName': data['courseName'],
      'departmentId': data['departmentId'],
    };
    var courseData = await network.updateData(update_data);
    if (courseData != null) {
      notifyListeners();
      return courseData;
    } else {
      print('Error updating data.');
    }
  }

  Future deleteCourseData(id) async {
    Network network = Network(url: '$courseApiUrl/$id');
    var res = await network.deleteData();
    if (res != null) {
      notifyListeners();
      return res;
    } else {
      print('Error deleting data.');
    }
  }

  Future addDepartmentData(data) async {
    Network network = Network(url: '$departmentApiUrl');
    var dataToAdd = {'departmentName': data};
    var depData = await network.addData(dataToAdd);
    if (depData != null) {
      notifyListeners();
      return depData;
    } else {
      print('Error adding data.');
    }
  }

  Future updateDepartmentData(data, id) async {
    Network network = Network(url: '$departmentApiUrl/$id');
    var dataToUpdate = {'departmentName': data};
    var depData = await network.updateData(dataToUpdate);
    if (depData != null) {
      notifyListeners();
      return depData;
    } else {
      print('Error updatingData data.');
    }
  }

  Future deleteDepartmentData(id) async {
    Network network = Network(url: '$departmentApiUrl/$id');

    var res = await network.deleteData();
    if (res != null) {
      notifyListeners();
      return res;
    } else {
      print('Error deleting data.');
    }
  }
}
