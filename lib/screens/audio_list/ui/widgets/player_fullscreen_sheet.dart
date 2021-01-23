import 'package:flutter/material.dart';
import 'package:flutter_audio_player/configs/size_config.dart';
import 'package:flutter_audio_player/shared/circular_image.dart';
import 'package:flutter_audio_player/shared/seekbar_widget.dart';
import 'package:flutter_audio_player/theme/colors.dart';
import 'package:flutter_audio_player/utils/media.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerFullScreenSheet extends StatefulWidget {
  final Function function;

  PlayerFullScreenSheet(this.function);

  @override
  _PlayerFullScreenSheetState createState() => _PlayerFullScreenSheetState();
}

class _PlayerFullScreenSheetState extends State<PlayerFullScreenSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
          Colors.white,
          AppColors.primaryColor
        ]),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Close button
          _closeButton(),
          // Circular cover art
          Center(child: CircularImageView(AssetMedia.temp, 250, 2, AppColors.primaryColor)),
          SizedBox(height: 24,),
          Center(
            child: Text('Titanic theme - unplugged cover', style: Theme.of(context).textTheme.headline4.copyWith(
              fontSize: 22
            ), ),
          ),
          SizedBox(height: 4,),
          Center(
            child: Text('Unplugged cover • Nayanika Das', style: Theme.of(context).textTheme.bodyText2.copyWith(
              fontSize: 14
            ),),
          ),
          Spacer(),
          Center(
            child: Column(
              children: [
                SeekbarWidget(SizeConfig.screenWidth),
                Row(
                  children: [
                    Text('00:02', style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontSize: 14,
                    ),),
                    Spacer(),
                    Text('03:32', style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontSize: 14
                    ),),
                  ],
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Playback controls
              _playbackButton(FontAwesomeIcons.stepBackward, 24, 0),
              SizedBox(width: 24,),
              _playbackButton(FontAwesomeIcons.solidPauseCircle, 48, 1, color: AppColors.accentColor),
              SizedBox(width: 24,),
              _playbackButton(FontAwesomeIcons.stepForward, 24, 2),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Playback controls
              _playbackButton(FontAwesomeIcons.retweet, 22, 0),
              Spacer(),
              _playbackButton(FontAwesomeIcons.heart, 28, 1, color: AppColors.accentColor),
              Spacer(),
              _playbackButton(FontAwesomeIcons.bars, 22, 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _closeButton() {
    return GestureDetector(
      onTap: () => widget.function(1),
      child: Icon(
        FontAwesomeIcons.chevronDown, size: 16, color: AppColors.secondaryColor,
      ),
    );
  }

  Widget _playbackButton(IconData icon, double size, int order, {Color color}) {
    return InkWell(
      onTap: () {},
      child: Icon(
        icon, color: color!=null? color: AppColors.secondaryColor, size: size,
      ),
    );
  }
}
