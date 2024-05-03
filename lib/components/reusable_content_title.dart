import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class ReusableContentTitle extends StatelessWidget {
  const ReusableContentTitle({
    super.key,
    required this.title,
    required this.content,
  });
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$title :',
          style: kCustomTitle.copyWith(
              fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Text(
            '$content',
            style: kCustomTitle.copyWith(
                fontSize: 16.0, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
