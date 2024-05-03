import 'package:flutter/material.dart';

import '../utils/constants.dart';

class ReusableModalButton extends StatelessWidget {
  final Widget? addDialogScreen;
  final bool isDisabled;
  const ReusableModalButton(
      {super.key, this.addDialogScreen, required this.isDisabled});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled
          ? null
          : () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: addDialogScreen,
                  ),
                ),
              );
            },
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(
          kDefColor,
        ),
      ),
      child: Text(
        'Add',
        style: kCustomTitle.copyWith(fontSize: 16.0, color: Colors.white),
      ),
    );
  }
}
