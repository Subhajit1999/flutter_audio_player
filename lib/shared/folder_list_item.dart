import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_audio_player/configs/size_config.dart';
import 'package:flutter_audio_player/theme/colors.dart';
import 'package:flutter_audio_player/utils/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FolderItem extends StatefulWidget {
  final int index;
  FolderItem(this.index);

  @override
  _FolderItemState createState() => _FolderItemState(index);
}

class _FolderItemState extends State<FolderItem> {
  double cardWidth, cardHeight;
  final int index;
  MaterialColor bgColor;

  _FolderItemState(this.index);

  @override
  Widget build(BuildContext context) {
    print('Index: $index');
    cardWidth = SizeConfig.screenWidth/2;
    cardHeight  = (cardWidth/2)*3;
    if(index >= Constants.ColorsList.length) {
      bgColor = Constants.ColorsList[index - ((index%10)*10)];
    }else {
      bgColor = Constants.ColorsList[index];
    }
    return Container(
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(1.5 * SizeConfig.heightMultiplier)
      ),
      padding: EdgeInsets.only(right: 1.1 * SizeConfig.widthMultiplier),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Icon(FontAwesomeIcons.ellipsisV, size: 1.75 * SizeConfig.textMultiplier, color: AppColors.secondaryColor,),
              Center(
                child: Container(
                  width: 23.6 * SizeConfig.widthMultiplier,
                  height: 23.6 * SizeConfig.widthMultiplier,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: bgColor.withOpacity(0.1)
                  ),
                  child: Icon(FontAwesomeIcons.solidFolder, size: 4 * SizeConfig.textMultiplier, color: bgColor,),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.heightMultiplier,),
          Text('Lorem ipsum dolor', style: Theme.of(context).textTheme.bodyText1.copyWith(
            fontSize: 2 * SizeConfig.textMultiplier
          ), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,),
          SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
          Text('$index media files', style: Theme.of(context).textTheme.bodyText2.copyWith(
              fontSize: 1.75 * SizeConfig.textMultiplier
          ), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,),
        ],
      ),
    );
  }
}
