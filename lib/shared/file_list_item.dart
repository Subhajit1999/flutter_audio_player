import 'package:flutter/material.dart';
import 'package:flutter_audio_player/configs/menu_config.dart';
import 'package:flutter_audio_player/configs/size_config.dart';
import 'package:flutter_audio_player/models/storage_file_system.dart';
import 'package:flutter_audio_player/theme/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:media_metadata_plugin/media_media_data.dart';
import 'package:media_metadata_plugin/media_metadata_plugin.dart';

class FileListItem extends StatefulWidget {
  final AudioFile file;

  FileListItem(this.file);

  @override
  _FileListItemState createState() => _FileListItemState();
}

class _FileListItemState extends State<FileListItem> {
  String fileName, album, artist, timeStamp;
  int durationMin, durationSec;

  @override
  void initState() {
    super.initState();
    fileName = widget.file.filePath.split('/').last;
    getAudioMetaData();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
        Container(
          width: 7 * SizeConfig.heightMultiplier,
          height: 7 * SizeConfig.heightMultiplier,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5, style: BorderStyle.solid),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/song.jpg')
              )
          ),
        ),
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
    AudioMetaData metaData = await MediaMetadataPlugin.getMediaMetaData(widget.file.filePath);
    album = metaData.album!=null? metaData.album : 'Unknown';
    artist = metaData.artistName!=null? metaData.artistName : 'Unknown';
    double sec = metaData.trackDuration/1000;
    durationMin = (sec ~/ 60);
    durationSec = (sec % 60).toInt();
    timeStamp = '${durationMin==0? '00' : durationMin<10? '0$durationMin' : '$durationMin'}:'
                '${durationSec==0? '00' : durationSec<10? '0$durationSec' : '$durationSec'}';
    // print('album name: $album | artist name: $artist | duration: $timeStamp');
    setState(() {});
  }

  void _popupMenuAction(int order) {
    switch(order) {
      case 0:
        break;
    }
  }
}
