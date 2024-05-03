import 'package:crud_app/utils/constants.dart';
import 'package:flutter/material.dart';

class ReusableSearchTextField extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String>? searchCallback;
  const ReusableSearchTextField(
      {super.key, required this.searchController, this.searchCallback});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: searchCallback,
      controller: searchController,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: 'Search',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: kDefColor, width: 1.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      ),
    );
  }
}
