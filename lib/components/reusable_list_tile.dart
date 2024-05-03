import 'package:crud_app/components/reusable_content_title.dart';
import 'package:crud_app/screens/course_screen/edit_course_screen.dart';
import 'package:crud_app/screens/enrollment_screen/edit_enrollment_screen.dart';
import 'package:crud_app/screens/student_screen/edit_student_screen.dart';
import 'package:crud_app/services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';
import '../screens/department_screen/edit_department_screen.dart';
import 'package:quickalert/quickalert.dart';

class ReusableCards extends StatefulWidget {
  const ReusableCards(
      {Key? key,
      required this.selectedList,
      required this.title,
      required this.sub_title,
      required this.actionFrom,
      this.sourceList})
      : super(key: key);

  final dynamic selectedList;
  final String actionFrom;
  final String title;
  final String sub_title;
  final dynamic sourceList;

  @override
  State<ReusableCards> createState() => _ReusableCardsState();
}

class _ReusableCardsState extends State<ReusableCards> {
  bool _showContent = false;
  String getTitle() {
    var textData;
    if (widget.title == 'name') {
      textData = widget.selectedList['firstName'] +
          ' ' +
          widget.selectedList['lastName'];
    } else {
      textData = widget.selectedList[widget.title];
    }
    return textData;
  }

  Widget? content;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.actionFrom == 'Enrollment') {
      String studentId = '${widget.selectedList['studentId']}';
      String fullName =
          '${widget.selectedList['firstName'] + ' ' + widget.selectedList['lastName']}';
      String address = '${widget.selectedList['address']}';
      String enrollment_date = '${widget.selectedList['enrollment_date']}';
      String DOB = '${widget.selectedList['DOB']}';
      String courseName = '${widget.selectedList['courseName']}';
      var transformData = DateTime.parse(widget.selectedList['created_at']);
      var formattedData = DateFormat('yyyy-MM-dd').format(transformData);
      content = Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(
              height: 15.0,
            ),
            ReusableContentTitle(
              title: 'Student Id',
              content: studentId,
            ),
            const SizedBox(
              height: 15.0,
            ),
            ReusableContentTitle(
              title: 'Enrollment date',
              content: enrollment_date,
            ),
            const SizedBox(
              height: 15.0,
            ),
            ReusableContentTitle(
              title: 'Student',
              content: fullName,
            ),
            const SizedBox(
              height: 15.0,
            ),
            ReusableContentTitle(
              title: 'Course',
              content: courseName,
            ),
            const SizedBox(
              height: 15.0,
            ),
            ReusableContentTitle(
              title: 'Address',
              content: address,
            ),
            const SizedBox(
              height: 15.0,
            ),
            ReusableContentTitle(
              title: 'Birthdate',
              content: DOB,
            ),
            SizedBox(
              height: 15.0,
            ),
            ReusableContentTitle(
                title: 'Created At', content: formattedData.toString()),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      );
    } else if (widget.actionFrom == 'Student') {
      String fullName =
          '${widget.selectedList['firstName'] + ' ' + widget.selectedList['lastName']}';
      String address = '${widget.selectedList['address']}';
      String DOB = '${widget.selectedList['DOB']}';
      var transformData = DateTime.parse(widget.selectedList['created_at']);
      var formattedData = DateFormat('yyyy-MM-dd').format(transformData);
      content = Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15.0,
            ),
            ReusableContentTitle(
              title: 'Student',
              content: fullName,
            ),
            SizedBox(
              height: 15.0,
            ),
            ReusableContentTitle(
              title: 'Address',
              content: address,
            ),
            SizedBox(
              height: 15.0,
            ),
            ReusableContentTitle(
              title: 'Birthdate',
              content: DOB,
            ),
            SizedBox(
              height: 15.0,
            ),
            ReusableContentTitle(
              title: 'Created At',
              content: formattedData.toString(),
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      );
    } else if (widget.actionFrom == 'Course') {
      String courseName = '${widget.selectedList['courseName']}';
      String departmentName = '${widget.selectedList['departmentName']}';
      var transformData = DateTime.parse(widget.selectedList['created_at']);
      var formattedData = DateFormat('yyyy-MM-dd').format(transformData);

      content = Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(
              height: 15.0,
            ),
            ReusableContentTitle(title: 'Course', content: courseName),
            const SizedBox(
              height: 15.0,
            ),
            ReusableContentTitle(title: 'Department', content: departmentName),
            const SizedBox(
              height: 15.0,
            ),
            const SizedBox(
              height: 15.0,
            ),
            ReusableContentTitle(
                title: 'Created A', content: formattedData.toString()),
            const SizedBox(
              height: 15.0,
            ),
          ],
        ),
      );
    } else if (widget.actionFrom == 'Department') {
      String departmentName = '${widget.selectedList['departmentName']}';
      var transformData = DateTime.parse(widget.selectedList['created_at']);
      var formattedData = DateFormat('yyyy-MM-dd').format(transformData);
      content = Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(
              height: 15.0,
            ),
            ReusableContentTitle(title: 'Department', content: departmentName),
            const SizedBox(
              height: 15.0,
            ),
            ReusableContentTitle(
                title: 'Created at', content: formattedData.toString()),
            const SizedBox(
              height: 15.0,
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int sel_id = widget.selectedList['id'];
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          color: kDefColor,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: () {
                setState(() {
                  _showContent = !_showContent;
                });
              },
              leading: Text(
                '${widget.selectedList['id']}' ?? '',
                style: kCustomTitle.copyWith(
                  fontSize: 12.0,
                ),
              ),
              title: Text(
                getTitle(),
                style: kCustomTitle.copyWith(
                  fontSize: 14.0,
                ),
              ),
              subtitle: Text(
                widget.selectedList[widget.sub_title] ?? '',
                style: kCustomTitle.copyWith(
                    fontSize: 12.0, fontWeight: FontWeight.normal),
              ),
              trailing: Wrap(
                spacing: -14,
                children: [
                  IconButton(
                    onPressed: () {
                      Widget selectedScreen;
                      if (widget.actionFrom == 'Department') {
                        selectedScreen = EditDepartmentScreen(
                            selectedDepartment: widget.selectedList);
                        selectedScreen = EditDepartmentScreen(
                            selectedDepartment: widget.selectedList);
                      } else if (widget.actionFrom == 'Course') {
                        selectedScreen =
                            EditCourseScreen(courseToEdit: widget.selectedList);
                      } else if (widget.actionFrom == 'Student') {
                        selectedScreen = EditStudentScreen(
                            studentToEdit: widget.selectedList);
                        EditStudentScreen(studentToEdit: widget.selectedList);
                      } else {
                        selectedScreen = EditEnrollmentScreen(
                            enrollmentList: widget.sourceList,
                            enrollmentToEdit: widget.selectedList);
                      }
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: selectedScreen,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: kDefColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          barrierDismissible: true,
                          title: 'Delete ${widget.actionFrom}',
                          confirmBtnText: 'Ok',
                          cancelBtnText: 'Cancel',
                          titleColor: kDefColor,
                          textColor: kDefColor,
                          headerBackgroundColor: kDefColor,
                          text:
                              'Are you sure you want to delete this data? (Related data will be deleted as well.)',
                          onConfirmBtnTap: () {
                            if (widget.actionFrom == 'Department') {
                              Provider.of<AppServices>(context, listen: false)
                                  .deleteDepartmentData(sel_id);
                            } else if (widget.actionFrom == 'Course') {
                              Provider.of<AppServices>(context, listen: false)
                                  .deleteCourseData(sel_id);
                            } else if (widget.actionFrom == 'Student') {
                              Provider.of<AppServices>(context, listen: false)
                                  .deleteStudentData(sel_id);
                            } else {
                              Provider.of<AppServices>(context, listen: false)
                                  .deleteEnrollmentData(sel_id);
                            }

                            Navigator.pop(context);
                          },
                          onCancelBtnTap: () {
                            Navigator.pop(context);
                          });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            _showContent ? content! : Container(),
          ],
        ),
      ),
    );
  }
}
