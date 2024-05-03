import 'package:flutter/material.dart';
import 'reusable_list_tile.dart';

class ReusableList extends StatelessWidget {
  final List<dynamic> list_data;
  final dynamic tileData;
  ReusableList({required this.list_data, required this.tileData});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: list_data.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var data = list_data[index];

        return ReusableCards(
          selectedList: data,
          title: tileData['title'],
          sub_title: tileData['sub_title'],
          actionFrom: tileData['actionFrom'],
          sourceList: list_data,
        );
      },
    );
  }
}
