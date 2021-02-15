import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_audio_player/configs/size_config.dart';
import 'package:flutter_audio_player/models/storage_file_system.dart';
import 'package:flutter_audio_player/utils/static.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FolderItem extends StatefulWidget {
  final int index;
  final AudioDirectory dir;
  FolderItem(this.index, this.dir);

  @override
  _FolderItemState createState() => _FolderItemState(index);
}

class _FolderItemState extends State<FolderItem> {
  double cardWidth, cardHeight;
  final int index;
  int filesCount;
  MaterialAccentColor bgColor;
  String dirName;

  _FolderItemState(this.index);

  @override
  Widget build(BuildContext context) {
    dirName = widget.dir.directoryPath.split('/').last;
    filesCount = widget.dir.filesInDir.length;

    cardWidth = SizeConfig.screenWidth/2;
    cardHeight  = (cardWidth/2)*3;

    if(index >= Statics.ColorsList.length) {
      bgColor = Statics.ColorsList[(index - ((index~/10)*10))];
      print((index - ((index/10)*10)).toInt());
    }else {
      bgColor = Statics.ColorsList[index];
    }

    return Material(
      color: Colors.transparent,
      shadowColor: Colors.grey.withOpacity(0.1),
      child: InkWell(
        onTap: () {
          // Navigate to files list page
          Navigator.of(context).pushNamed('/files_list', arguments: widget.dir);
        },
        child: Container(
          decoration: BoxDecoration(
            color: bgColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(1.5 * SizeConfig.heightMultiplier)
          ),
          padding: EdgeInsets.only(right: 1.1 * SizeConfig.widthMultiplier),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              SizedBox(height: SizeConfig.heightMultiplier,),
              Text(dirName, style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontSize: 2 * SizeConfig.textMultiplier
              ), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,),
              SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
              Text(filesCount!=1? '$filesCount audio files' : '1 audio file', style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontSize: 1.75 * SizeConfig.textMultiplier
              ), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,),
            ],
          ),
        ),
      ),
    );
  }
}
