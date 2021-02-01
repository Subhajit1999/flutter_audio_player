import 'package:flutter/material.dart';
import 'package:flutter_audio_player/configs/menu_config.dart';
import 'package:flutter_audio_player/configs/size_config.dart';
import 'package:flutter_audio_player/models/storage_file_system.dart';
import 'package:flutter_audio_player/screens/audio_list/ui/widgets/player_tray_sheet.dart';
import 'package:flutter_audio_player/shared/circular_image.dart';
import 'package:flutter_audio_player/theme/colors.dart';
import 'package:flutter_audio_player/utils/audio_metadata.dart';
import 'package:flutter_audio_player/utils/media.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FileListItem extends StatefulWidget {
  final AudioFile file;
  final int index;
  final Function openTrayFunc, changeViewFunc;

  FileListItem(this.file, this.index, this.openTrayFunc, this.changeViewFunc);

  @override
  _FileListItemState createState() => _FileListItemState();
}

class _FileListItemState extends State<FileListItem> {
  String fileName, album, artist, timeStamp;

  @override
  void initState() {
    super.initState();
    fileName = widget.file.filePath.split('/').last;
    getAudioMetaData();
  }

  @override
  Widget build(BuildContext context) {
    AudioMetadata metadata = AudioMetadata();
    metadata.getAudioMetaData(widget.file.filePath);
    return InkWell(
      onTap: () {
        widget.openTrayFunc(PlayerTraySheet(widget.changeViewFunc), filePath: widget.file.filePath);
      },
      child: Container(
        padding: EdgeInsets.only(left: 4.4 * SizeConfig.widthMultiplier, top: 1.25 * SizeConfig.heightMultiplier,
            bottom: 1.25 * SizeConfig.heightMultiplier),
        child: Row(
          children: [
            // Circular thumbnail
            _audioCoverImage(),

            SizedBox(width: 2.5 * SizeConfig.widthMultiplier,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fileName, style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: 2 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.bold
                  ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                  SizedBox(height: 0.25 * SizeConfig.heightMultiplier,),
                  Text('$album • $artist', style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontSize: 1.75 * SizeConfig.textMultiplier,
                      color: AppColors.smallMetaColor
                  ), maxLines: 2, overflow: TextOverflow.ellipsis,)
                ],
              ),
            ),
            _popupMenu()
          ],
        ),
      ),
    );
  }

  Widget _audioCoverImage() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CircularImageView(AssetMedia.temp, 7 * SizeConfig.heightMultiplier, 1.5, Colors.white),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 1.1 * SizeConfig.widthMultiplier, vertical: 0.125 * SizeConfig.heightMultiplier),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(SizeConfig.heightMultiplier),
              border: Border.all(color: Colors.white, width: 1, style: BorderStyle.solid),
              color: Colors.black.withOpacity(0.5)
          ),
          child: Text(timeStamp==null? '00:00' : timeStamp, style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.white,
              fontSize: 1.375 * SizeConfig.textMultiplier
          ),),
        )
      ],
    );
  }

  Widget _popupMenu() {
    return PopupMenuButton<String>(
      icon: Icon(FontAwesomeIcons.ellipsisV, size: 1.75 * SizeConfig.textMultiplier, color: AppColors.secondaryColor,),
      onSelected: (value) => _popupMenuAction,
      itemBuilder: (BuildContext context) {
        return AppbarMenuConfig.appbarMenuItems.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  Future<void> getAudioMetaData() async {
    AudioMetadata metadata = AudioMetadata();
    await metadata.getAudioMetaData(widget.file.filePath);
    artist = metadata.artist.trim().isNotEmpty? metadata.artist.trim() : 'Unknown';
    album = metadata.album.trim().isNotEmpty? metadata.album.trim() : 'Unknown';
    timeStamp = metadata.timeStamp;
    setState(() {});
  }

  void _popupMenuAction(int order) {
    switch(order) {
      case 0:
        break;
    }
  }
}
