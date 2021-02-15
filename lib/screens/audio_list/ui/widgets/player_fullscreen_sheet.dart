import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_player/configs/size_config.dart';
import 'package:flutter_audio_player/services/audio_player_service.dart';
import 'package:flutter_audio_player/services/audio_state_stream.dart';
import 'package:flutter_audio_player/services/timer_service.dart';
import 'package:flutter_audio_player/shared/audio_detail_dialog.dart';
import 'package:flutter_audio_player/shared/circular_image.dart';
import 'package:flutter_audio_player/shared/marquee_widget.dart';
import 'package:flutter_audio_player/shared/seekbar_widget.dart';
import 'package:flutter_audio_player/theme/colors.dart';
import 'package:flutter_audio_player/utils/audio_metadata.dart';
import 'package:flutter_audio_player/utils/media.dart';
import 'package:flutter_audio_player/utils/static.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';

class PlayerFullScreenSheet extends StatefulWidget {
  final Function function;

  PlayerFullScreenSheet(this.function);

  @override
  _PlayerFullScreenSheetState createState() => _PlayerFullScreenSheetState();
}

class _PlayerFullScreenSheetState extends State<PlayerFullScreenSheet> {
  static IconData playPauseIcon = FontAwesomeIcons.solidPlayCircle;
  int sessionId;
  Duration sleepTimerDuration = Duration.zero;
  static bool showTimer = false;
  static String sleepTimeStamp = '00:00';
  static SleepTimerService timerService;

  _getMetaData(MediaItem mediaItem) async {
    if(mediaItem!=null) {
      await Statics.metadata.getAudioMetaData(mediaItem.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AudioState>(
      stream: audioStateStream,
      builder: (context, snapshot) {
        final audioState = snapshot.data;
        final queue = audioState?.queue;
        final mediaItem = audioState?.mediaItem;
        final playbackState = audioState?.playbackState;
        final processingState =
            Statics.playbackState?.processingState ?? AudioProcessingState.none;
        final playing = Statics.playbackState?.playing ?? false;

          if(playbackState!=null? playbackState.playing : true) playPauseIcon = FontAwesomeIcons.solidPauseCircle;
          else playPauseIcon = FontAwesomeIcons.solidPlayCircle;
        _getMetaData(mediaItem);
        return _body(playbackState);
      },
    );
  }

  Widget _body(PlaybackState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(2 * SizeConfig.heightMultiplier),
      decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
            Colors.white,
            AppColors.primaryColor
          ]),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(2 * SizeConfig.heightMultiplier),
              topRight: Radius.circular(2 * SizeConfig.heightMultiplier))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Close button
          _closeButton(),
          Spacer(),
          // Circular cover art
          Center(child: CircularImageView(AssetMedia.temp, 31.25 * SizeConfig.heightMultiplier, 3, AppColors.accentColor)),
          SizedBox(height: 4 * SizeConfig.heightMultiplier,),
          Center(
            child: MarqueeWidget(
              direction: Axis.horizontal,
              child: Text(Statics.metadata.audioTitle, style: Theme.of(context).textTheme.headline4.copyWith(
                  fontSize: 2.5 * SizeConfig.textMultiplier
              ), textAlign: TextAlign.center,),)
          ),
          SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
          Center(
            child: MarqueeWidget(
              direction: Axis.horizontal,
              child: Text('${Statics.metadata.album} • ${Statics.metadata.artist}', style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontSize: 1.75 * SizeConfig.textMultiplier
              ),),
            )),
          Spacer(),
          Center(
            child: Column(
              children: [
                SeekbarWidget(true, playbackState: state, duration: Statics.metadata.duration),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Playback controls
              _speedController(),
              Spacer(),
              _playbackButton(FontAwesomeIcons.undoAlt, 2.5 * SizeConfig.heightMultiplier, 4, state: state),
              Spacer(),
              _playbackButton(FontAwesomeIcons.stepBackward, 3 * SizeConfig.heightMultiplier, 0),
              SizedBox(width: 6.7 * SizeConfig.widthMultiplier,),
              _playbackButton(playPauseIcon, 6 * SizeConfig.heightMultiplier, 1, color: AppColors.accentColor, state: state),
              SizedBox(width: 6.7 * SizeConfig.widthMultiplier,),
              _playbackButton(FontAwesomeIcons.stepForward, 3 * SizeConfig.heightMultiplier, 2),
              Spacer(),
              _playbackButton(FontAwesomeIcons.redoAlt, 2.5 * SizeConfig.heightMultiplier, 5, state: state),
              Spacer(),
              _playbackButton(FontAwesomeIcons.shareAlt, 2.5 * SizeConfig.heightMultiplier, 3),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Playback controls (Bottom)
              _playbackButton(FontAwesomeIcons.solidMoon, 2.75 * SizeConfig.heightMultiplier, 10),
              showTimer? Text(sleepTimeStamp, style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: 2 * SizeConfig.textMultiplier
              ),) : SizedBox(),
              Spacer(),
              _playbackButton(FontAwesomeIcons.infoCircle, 3 * SizeConfig.heightMultiplier, 11),
            ],
          ),
        ],
      ),
    );
  }

  Widget _speedController() {
    return InkWell(
      onTap: () => _speedControlAction(),
      child: Text('${Statics.playerSpeed.toInt()}x', style: Theme.of(context).textTheme.bodyText1.copyWith(
        fontSize: 3 * SizeConfig.textMultiplier,
        fontWeight: FontWeight.bold,
      ),),
    );
  }

  _speedControlAction() {
    if(Statics.playerSpeed == 1.0){
      Statics.playerSpeed = 2.0;
    } else if(Statics.playerSpeed == 2.0){
      Statics.playerSpeed = 4.0;
    } else {
      Statics.playerSpeed = 1.0;
    }
    AudioService.setSpeed(Statics.playerSpeed);
    setState(() {});
  }

  Widget _closeButton() {
    return GestureDetector(
      onTap: () => widget.function(1),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.heightMultiplier),
        child: Icon(
          FontAwesomeIcons.chevronDown, size: 2 * SizeConfig.heightMultiplier,
          color: AppColors.secondaryColor,
        ),
      ),
    );
  }

  Widget _playbackButton(IconData icon, double size, int order, {Color color, PlaybackState state}) {
    return InkWell(
      onTap: () => _playbackAction(order, state: state),
      child: Icon(
        icon, color: color!=null? color: AppColors.secondaryColor, size: size,
      ),
    );
  }

  void _playbackAction(int order, {PlaybackState state}) {
    switch(order) {
      case 0:  // Skip to previous song
        AudioService.skipToPrevious();
        break;
      case 1:  // Play/ Pause action
        if(state.playing) {
          playPauseIcon = FontAwesomeIcons.solidPlayCircle;
          AudioService.pause();
        }else{
          playPauseIcon = FontAwesomeIcons.solidPauseCircle;
          AudioService.play();
        }
        break;
      case 2:   // Skip to next song
        AudioService.skipToNext();
        break;
      case 3:   // File share using intent
        _fileShare(AudioService.currentMediaItem.id);
        break;
      case 4:   // Backward 10 sec.
        AudioService.seekTo(Duration(seconds: state.position.inSeconds-10));
        break;
      case 5:   // Forward 10 sec.
        AudioService.seekTo(Duration(seconds: state.position.inSeconds+10));
        break;
      case 10:   // Sleep Timer
        _pickSleepTimerDuration();
        break;
      case 11:  //show audio properties dialog
        showDialog(context: context, builder: (context) => FilePropertyDialog(Statics.metadata));
        break;
    }
    setState(() {});
  }

  _fileShare(String filePath) {
    final RenderBox box = context.findRenderObject();
    if(Platform.isAndroid) {
      Share.shareFiles([filePath], mimeTypes: [Statics.metadata.mimeType],
          subject: 'Share audio file with...',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }

  Future<void> _pickSleepTimerDuration() async {
    Duration _duration = Duration.zero;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(1.5 * SizeConfig.heightMultiplier))),
          child: Container(
            height: SizeConfig.screenHeight*0.5,
            padding: EdgeInsets.all(2 * SizeConfig.heightMultiplier),
            child: Column(
              children: [
                Text('Sleep Timer', style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: 2.5 * SizeConfig.textMultiplier
                ),),
                Spacer(),
                CupertinoTimerPicker(
                    mode: CupertinoTimerPickerMode.hms,
                    minuteInterval: 1,
                    secondInterval: 1,
                    initialTimerDuration: _duration,
                    onTimerDurationChanged: (Duration duration) {
                      _duration = duration;
                    }),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel', style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 2 * SizeConfig.textMultiplier
                        ),)),
                    FlatButton(
                        onPressed: () {
                          print('Timer picked: $_duration');
                          sleepTimerDuration = _duration;
                          setState(() {
                            showTimer = true;
                          });
                          if(timerService==null){
                            timerService = SleepTimerService(_timerIntervalAction, _timerDoneAction, sleepTimerDuration);
                            timerService.start();
                          }else{
                            // already running msg
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text('Done', style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 2 * SizeConfig.textMultiplier
                        ),))
                  ],
                )
              ],
            ),
          ),
        );
      }
    );
  }

  _timerIntervalAction(int second) {  // Method callback in 1 sec. interval
    int minutes = second~/60;
    int seconds = second-(minutes*60);
    print('minute: $minutes, second: $seconds');
    sleepTimeStamp = AudioMetadata().getTimeStamp(Duration(minutes: minutes, seconds: seconds));
    if(mounted){
      this.setState(() {});
    }
  }

  _timerDoneAction() {
    print('done function called.');
    showTimer = false;
    sleepTimeStamp = '00:00';
    AudioService.pause();
    timerService = null;
    if(mounted){
      this.setState(() {});
    }
  }
}
