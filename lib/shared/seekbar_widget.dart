import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_player/configs/size_config.dart';
import 'package:flutter_audio_player/theme/colors.dart';
import 'package:flutter_audio_player/utils/static.dart';
import 'package:rxdart/rxdart.dart';

class SeekbarWidget extends StatefulWidget {
  final PlaybackState playbackState;
  final Duration duration;
  final bool isFullScreen;

  SeekbarWidget(this.isFullScreen, {this.playbackState, this.duration});

  @override
  _SeekbarWidgetState createState() => _SeekbarWidgetState();
}

class _SeekbarWidgetState extends State<SeekbarWidget> {
  double seekPos;
  final BehaviorSubject<double> _dragPositionSubject =
  BehaviorSubject.seeded(null);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Rx.combineLatest2<double, double, double>(
          _dragPositionSubject.stream,
          Stream.periodic(Duration(milliseconds: 500)),
              (dragPosition, _) => dragPosition),
      builder: (context, snapshot) {
        Duration position =
            snapshot.data ?? widget.playbackState!=null? widget.playbackState.currentPosition :
                              Duration.zero;
        Duration duration = widget.duration;
        return Column(
          children: [
            if (duration != null)
              Container(
                width: SizeConfig.screenWidth,
                height: 3.125 * SizeConfig.heightMultiplier,
                child: SliderTheme(
                  data: SliderThemeData(
                      trackHeight: 2,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8)
                  ),
                  child: Slider(
                    min: 0.0,
                    max: duration.inMilliseconds.toDouble(),
                    activeColor: AppColors.secondaryColor,
                    inactiveColor: AppColors.accentColor,
                    value: seekPos ?? max(0.0, min(position.inMilliseconds.toDouble(),
                                        duration.inMilliseconds.toDouble())),
                    onChanged: (value) {
                      // _dragPositionSubject.add(value);
                    },
                    onChangeEnd: (value) {
                      AudioService.seekTo(Duration(milliseconds: value.toInt()));
                      // Due to a delay in platform channel communication, there is
                      // a brief moment after releasing the Slider thumb before the
                      // new position is broadcast from the platform side. This
                      // hack is to hold onto seekPos until the next state update
                      // comes through.
                      // TODO: Improve this code.
                      seekPos = value.toDouble();
                      // _dragPositionSubject.add(null);
                    },
                  ),
                ),
              ),
            widget.isFullScreen? Row(
              children: [
                Text("${Statics.getTimeStamp(position)}", style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontSize: 1.75 * SizeConfig.textMultiplier,
                ),),
                Spacer(),
                Text("${Statics.getTimeStamp(duration)}", style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontSize: 1.75 * SizeConfig.textMultiplier,
                ),),
              ],
            ) : SizedBox()
          ],
        );
      },
    );
  }
}
