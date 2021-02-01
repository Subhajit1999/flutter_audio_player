import 'package:flutter/material.dart';
import 'package:flutter_audio_player/utils/static.dart';

class CustomFABButton extends StatefulWidget {
  final Function function;
  final Widget childWidget;

  CustomFABButton(this.childWidget, this.function);

  @override
  _CustomFABButtonState createState() => _CustomFABButtonState();
}

class _CustomFABButtonState extends State<CustomFABButton> {
  bool showFab = true;

  @override
  Widget build(BuildContext context) {
    return showFab ? FloatingActionButton(
      onPressed: () {
        widget.function();
        showFloatingActionButton(false);

        Statics.controller.closed.then((value) {
          showFloatingActionButton(true);
        });
      },
      child: widget.childWidget,
    )
        : Container();
  }

  void showFloatingActionButton(bool value) {
    setState(() {
      showFab = value;
    });
  }
}
