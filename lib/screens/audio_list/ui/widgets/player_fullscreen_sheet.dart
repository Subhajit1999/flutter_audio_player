import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_player/configs/size_config.dart';
import 'package:flutter_audio_player/services/audio_player_service.dart';
import 'package:flutter_audio_player/services/audio_state_stream.dart';
import 'package:flutter_audio_player/shared/circular_image.dart';
import 'package:flutter_audio_player/shared/marquee_widget.dart';
import 'package:flutter_audio_player/shared/seekbar_widget.dart';
import 'package:flutter_audio_player/theme/colors.dart';
import 'package:flutter_audio_player/utils/media.dart';
import 'package:flutter_audio_player/utils/static.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerFullScreenSheet extends StatefulWidget {
  final Function function;

  PlayerFullScreenSheet(this.function);

  @override
  _PlayerFullScreenSheetState createState() => _PlayerFullScreenSheetState();
}

class _PlayerFullScreenSheetState extends State<PlayerFullScreenSheet> {
  IconData playPauseIcon;

  @override
  void initState() {
    super.initState();
  }

  _getMetaData() {
    if(AudioService.currentMediaItem!=null) {
      Statics.metadata.getAudioMetaData(AudioService.currentMediaItem.id).then((value) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _getMetaData();

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
        if(playPauseIcon == null) {
          if(playbackState.playing) playPauseIcon = FontAwesomeIcons.solidPauseCircle;
          else playPauseIcon = FontAwesomeIcons.solidPlayCircle;
        }

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
          // Circular cover art
          Center(child: CircularImageView(AssetMedia.temp, 31.25 * SizeConfig.heightMultiplier, 2, AppColors.primaryColor)),
          SizedBox(height: 3 * SizeConfig.heightMultiplier,),
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
              _playbackButton(FontAwesomeIcons.stepBackward, 3 * SizeConfig.heightMultiplier, 0),
              SizedBox(width: 6.7 * SizeConfig.widthMultiplier,),
              _playbackButton(playPauseIcon, 6 * SizeConfig.heightMultiplier, 1, color: AppColors.accentColor, state: state),
              SizedBox(width: 6.7 * SizeConfig.widthMultiplier,),
              _playbackButton(FontAwesomeIcons.stepForward, 3 * SizeConfig.heightMultiplier, 2),
              Spacer(),
              _playbackButton(FontAwesomeIcons.solidMoon, 3 * SizeConfig.heightMultiplier, 3),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Playback controls (Bottom)
              _playbackButton(FontAwesomeIcons.retweet, 2.75 * SizeConfig.heightMultiplier, 10),
              Spacer(),
              _playbackButton(FontAwesomeIcons.heart, 3.5 * SizeConfig.heightMultiplier, 11, color: AppColors.accentColor),
              Spacer(),
              _playbackButton(FontAwesomeIcons.bars, 2.75 * SizeConfig.heightMultiplier, 12),
            ],
          ),
        ],
      ),
    );
  }

  Widget _speedController() {
    return Text('1x', style: Theme.of(context).textTheme.bodyText1.copyWith(
      fontSize: 3 * SizeConfig.textMultiplier,
      fontWeight: FontWeight.bold,
    ),);
  }

  Widget _closeButton() {
    return GestureDetector(
      onTap: () => widget.function(1),
      child: Icon(
        FontAwesomeIcons.chevronDown, size: 2 * SizeConfig.heightMultiplier, color: AppColors.secondaryColor,
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
      case 0:
        AudioService.skipToPrevious();
        break;
      case 1:
        if(state.playing) {
          playPauseIcon = FontAwesomeIcons.solidPlayCircle;
          AudioService.pause();
        }else{
          playPauseIcon = FontAwesomeIcons.solidPauseCircle;
          AudioService.play();
        }
        break;
      case 2:
        AudioService.skipToNext();
        break;
      case 10:
        AudioService.setRepeatMode(AudioServiceRepeatMode.one);
        break;
    }
    setState(() {});
  }
}
