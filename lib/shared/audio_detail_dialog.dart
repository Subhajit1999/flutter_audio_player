import 'package:flutter/material.dart';
import 'package:flutter_audio_player/configs/size_config.dart';
import 'package:flutter_audio_player/models/storage_file_system.dart';
import 'package:flutter_audio_player/theme/colors.dart';
import 'package:flutter_audio_player/utils/audio_metadata.dart';

class FilePropertyDialog extends StatelessWidget {
  final AudioMetadata metadata;

  FilePropertyDialog(this.metadata);

  @override
  Widget build(BuildContext context) {
    print('title: ${metadata.audioTitle}');
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(1.5 * SizeConfig.heightMultiplier))),
      child: Container(
        height: SizeConfig.screenHeight*0.55,
        padding: EdgeInsets.all(2 * SizeConfig.heightMultiplier),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(metadata.audioTitle.split('.').first, style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontSize: 2.375 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.bold
            ), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,),
            SizedBox(height: 2.5 * SizeConfig.heightMultiplier,),
            Expanded(
              flex: 7,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    propertyColWidget(context,'File:',metadata.audioTitle),
                    SizedBox(height: SizeConfig.heightMultiplier,),
                    propertyColWidget(context,'Location:',metadata.fileLocation),
                    SizedBox(height: SizeConfig.heightMultiplier,),
                    propertyColWidget(context,'Album:',metadata.album),
                    SizedBox(height: SizeConfig.heightMultiplier,),
                    propertyColWidget(context,'Artist:',metadata.artist),
                    SizedBox(height: SizeConfig.heightMultiplier,),
                    propertyRowWidget(context,'Size:','${(metadata.fileSize/(1024*1024)).toStringAsFixed(2)} MB  (${metadata.fileSize} bytes)'),
                    SizedBox(height: SizeConfig.heightMultiplier,),
                    propertyRowWidget(context,'Format:', '.${metadata.format}'),
                    SizedBox(height: SizeConfig.heightMultiplier,),
                    propertyRowWidget(context,'Length:',metadata.timeStamp),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.5 * SizeConfig.heightMultiplier,),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  color: AppColors.accentColor,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Got it', style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget propertyColWidget(BuildContext context, String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyText1.copyWith(
          fontSize: 2.125 * SizeConfig.textMultiplier
        ),),
        SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
        Text(value, style: Theme.of(context).textTheme.bodyText2.copyWith(
          fontSize: 2 * SizeConfig.textMultiplier
        ),),
      ],
    );
  }

  static Widget propertyRowWidget(BuildContext context, String title, String value) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyText1.copyWith(
          fontSize: 2.125 * SizeConfig.textMultiplier
        ),),
        SizedBox(width: 2 * SizeConfig.heightMultiplier,),
        Text(value, style: Theme.of(context).textTheme.bodyText2.copyWith(
            fontSize: 2 * SizeConfig.textMultiplier
        ),),
      ],
    );
  }
}

class FolderPropertyDialog extends StatelessWidget {
  final AudioDirectory dir;

  FolderPropertyDialog(this.dir);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(1.5 * SizeConfig.heightMultiplier))),
      child: Container(
        height: SizeConfig.screenHeight*0.35,
        padding: EdgeInsets.all(2 * SizeConfig.heightMultiplier),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(dir.directoryPath.split('/').last, style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontSize: 2.375 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.bold
            ), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,),
            SizedBox(height: 2.5 * SizeConfig.heightMultiplier,),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FilePropertyDialog.propertyColWidget(context,'Folder:',dir.directoryPath.split('/').last),
                    SizedBox(height: SizeConfig.heightMultiplier,),
                    FilePropertyDialog.propertyColWidget(context,'Location:',dir.directoryPath),
                    SizedBox(height: SizeConfig.heightMultiplier,),
                    FilePropertyDialog.propertyColWidget(context,'Files:','${dir.filesInDir.length} Audio Files'),
                  ],
                ),
              ),
            ),
            // SizedBox(height: 2.5 * SizeConfig.heightMultiplier,),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                    color: AppColors.accentColor,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Got it', style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
