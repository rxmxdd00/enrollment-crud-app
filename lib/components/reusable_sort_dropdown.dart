import 'package:flutter/material.dart';

import '../utils/constants.dart';

class ReusableSortData extends StatelessWidget {
  final String? filterWith;
  final List<Map<String, String>> filterOptions;
  final dynamic onChanged;
  final dynamic onTap;
  const ReusableSortData(
      {super.key,
      this.filterWith,
      required this.filterOptions,
      required this.onTap,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: const Text('Filter by: '),
                value: filterWith,
                items: filterOptions.map((item) {
                  return DropdownMenuItem<String>(
                    value: item['value'],
                    child: Text('${item['viewValue']}'),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 15.0,
        ),
        GestureDetector(
          onTap: onTap,
          child: const CircleAvatar(
            backgroundColor: kDefColor,
            child: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
