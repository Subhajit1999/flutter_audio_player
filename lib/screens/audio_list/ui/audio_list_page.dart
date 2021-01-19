import 'package:flutter/material.dart';
import 'package:flutter_audio_player/models/storage_file_system.dart';
import 'package:flutter_audio_player/shared/file_list_item.dart';
import 'package:flutter_audio_player/shared/toolbar.dart';
import 'package:flutter_audio_player/theme/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AudioListPage extends StatefulWidget {
  final AudioDirectory directory;

  AudioListPage(this.directory);

  @override
  _AudioListPageState createState() => _AudioListPageState();
}

class _AudioListPageState extends State<AudioListPage> {
  String dirName;
  @override
  Widget build(BuildContext context) {
    dirName = widget.directory.directoryPath.split('/').last;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: ToolBar('$dirName', false,
        leadingIcon: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
            child: Icon(FontAwesomeIcons.arrowLeft, color: AppColors.secondaryColor, size: 20,)),
      ),
      body: pageBody(),
    );
  }

  Widget pageBody() {
    return Container(
      child: ListView.builder(
        itemCount: widget.directory.filesInDir.length,
          itemBuilder: (BuildContext context, int index) {
            return FileListItem(widget.directory.filesInDir[index]);
          }
      )
    );
  }
}
