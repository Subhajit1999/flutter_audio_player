import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_player/configs/size_config.dart';
import 'package:flutter_audio_player/shared/circular_image.dart';
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.function(0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Close Button
            // _closeButton(),

            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Circular cover-art
                  CircularImageView(AssetMedia.temp, 64, 2, AppColors.secondaryColor),
                  // Content area
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Music info
                        Text('Titanic theme song - unplugged cover', style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        ), maxLines: 1, overflow: TextOverflow.ellipsis,),
                        Text('by Unknown', style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 12,
                        ), maxLines: 1, overflow: TextOverflow.ellipsis,),
                        SizedBox(height: 4,),
                        // Music playback controls
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Playback controls
                            _playbackButton(FontAwesomeIcons.stepBackward, 20, 0),
                            _playbackButton(FontAwesomeIcons.solidPauseCircle, 36, 1),
                            _playbackButton(FontAwesomeIcons.stepForward, 20, 2),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            // SeekBar control
            SeekbarWidget(SizeConfig.screenWidth),
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
        FontAwesomeIcons.times, size: 16, color: AppColors.secondaryColor,
      ),
    );
  }

  Widget _playbackButton(IconData icon, double size, int order) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        icon, color: AppColors.secondaryColor, size: size,
      ),
    );
  }
}
