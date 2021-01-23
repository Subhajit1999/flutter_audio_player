import 'package:flutter/material.dart';
import 'package:flutter_audio_player/theme/colors.dart';

class SeekbarWidget extends StatefulWidget {
  final double width;

  SeekbarWidget(this.width);

  @override
  _SeekbarWidgetState createState() => _SeekbarWidgetState();
}

class _SeekbarWidgetState extends State<SeekbarWidget> {
  int valueHolder = 20;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: 25,
      child: SliderTheme(
        data: SliderThemeData(
            trackHeight: 2,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8)
        ),
        child: Slider(
            value: valueHolder.toDouble(),
            min: 1,
            max: 100,
            divisions: 100,
            activeColor: AppColors.secondaryColor,
            inactiveColor: AppColors.accentColor,
            label: '${valueHolder.round()}',
            onChanged: (double newValue) {
              setState(() {
                valueHolder = newValue.round();
              });
            },
            semanticFormatterCallback: (double newValue) {
              return '${newValue.round()}';
            }
        ),
      ),
    );
  }
}
