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

class PlayerTraySheet extends StatefulWidget {
  final Function function;

  PlayerTraySheet(this.function);

  @override
  _PlayerTraySheetState createState() => _PlayerTraySheetState();
}

class _PlayerTraySheetState extends State<PlayerTraySheet> {
  static IconData playPauseIcon = FontAwesomeIcons.solidPlayCircle;
  Duration duration;

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

  Widget _body(PlaybackState playbackState) {
    return GestureDetector(
      onTap: () => widget.function(0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.8 * SizeConfig.widthMultiplier, vertical: SizeConfig.heightMultiplier),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(2 * SizeConfig.heightMultiplier),
                topRight: Radius.circular(2 * SizeConfig.heightMultiplier))
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            Padding(
              padding: EdgeInsets.only(top: SizeConfig.heightMultiplier),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Circular cover-art
                  CircularImageView(AssetMedia.temp, 8 * SizeConfig.heightMultiplier, 2, AppColors.secondaryColor),
                  // Content area
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Music info
                        MarqueeWidget(
                          direction: Axis.horizontal,
                            child: Text(Statics.metadata.audioTitle!=null? Statics.metadata.audioTitle : 'Audio Title', style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontSize: 1.75 * SizeConfig.textMultiplier,
                                fontWeight: FontWeight.bold
                            ), maxLines: 1)),
                        MarqueeWidget(
                          direction: Axis.horizontal,
                          child: Text('by ${Statics.metadata.artist}', style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: 1.5 * SizeConfig.textMultiplier,
                          ), maxLines: 1),),
                        SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
                        // Music playback controls
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Playback controls
                            _playbackButton(FontAwesomeIcons.stepBackward, 2.5 * SizeConfig.heightMultiplier, 0),
                            _playbackButton(playPauseIcon, 4.5 * SizeConfig.heightMultiplier, 1, state: playbackState),
                            _playbackButton(FontAwesomeIcons.stepForward, 2.5 * SizeConfig.heightMultiplier, 2),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

            // SeekBar control
            SeekbarWidget(false, playbackState: playbackState, duration: Statics.metadata.duration),
          ],
        ),
      ),
    );
  }

  Widget _closeButton() {
    return GestureDetector(
      onTap: () {
        if(Statics.controller != null) {
          Statics.controller.close();
          Statics.controller = null;
        }
      },
      child: Icon(
        FontAwesomeIcons.times, size: 2 * SizeConfig.heightMultiplier, color: AppColors.secondaryColor,
      ),
    );
  }

  Widget _playbackButton(IconData icon, double size, int order, {PlaybackState state}) {
    return IconButton(
      onPressed: () => playbackAction(order, state: state),
      icon: Icon(
        icon, color: AppColors.secondaryColor, size: size,
      ),
    );
  }

  void playbackAction(int order, {PlaybackState state}) {
    switch(order) {
      case 0:
        AudioService.skipToPrevious();
        break;
      case 1:  // Play/Pause
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
    }
    setState(() {});
  }
}
