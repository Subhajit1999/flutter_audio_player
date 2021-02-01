import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_player/configs/size_config.dart';
import 'package:flutter_audio_player/models/storage_file_system.dart';
import 'package:flutter_audio_player/screens/audio_list/ui/widgets/player_fullscreen_sheet.dart';
import 'package:flutter_audio_player/screens/audio_list/ui/widgets/player_tray_sheet.dart';
import 'package:flutter_audio_player/services/audio_player_service.dart';
import 'package:flutter_audio_player/shared/file_list_item.dart';
import 'package:flutter_audio_player/shared/toolbar.dart';
import 'package:flutter_audio_player/theme/colors.dart';
import 'package:flutter_audio_player/utils/audio_metadata.dart';
import 'package:flutter_audio_player/utils/static.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AudioListPage extends StatefulWidget {
  final AudioDirectory directory;

  AudioListPage(this.directory);

  @override
  _AudioListPageState createState() => _AudioListPageState();
}

class _AudioListPageState extends State<AudioListPage> {
  String dirName;
  Widget playerWidget;
  GlobalKey<ScaffoldState> _scaffoldKey;
  var duration;
  AudioMetadata metadata;
  bool bottomSheetVisible = false;
  List<MediaItem> _queue = <MediaItem>[], _singleFileQueue = <MediaItem>[];

  @override
  void initState() {
    super.initState();
    _scaffoldKey = new  GlobalKey<ScaffoldState>();
    metadata = AudioMetadata();
    _connectService();
    _prepareQueue(false);
  }

  _connectService() async {
    await AudioService.connect();
  }

  @override
  Widget build(BuildContext context) {
    dirName = widget.directory.directoryPath.split('/').last;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.primaryColor,
      appBar: ToolBar('$dirName', false,
        leadingIcon: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
            child: Icon(FontAwesomeIcons.arrowLeft, color: AppColors.secondaryColor, size: 2.5 * SizeConfig.heightMultiplier,),),
      ),

      floatingActionButton: !bottomSheetVisible? FloatingActionButton(
        onPressed: () => openPlayerTray(PlayerTraySheet(changePlayerView)),
        child: Center(child: Icon(FontAwesomeIcons.play, size: 2.75 * SizeConfig.heightMultiplier, color: Colors.white,)),
      ) : SizedBox(),
      body: pageBody(),
    );
  }

  Widget pageBody() {
    return Container(
      child: ListView.builder(
        itemCount: widget.directory.filesInDir.length,
          itemBuilder: (BuildContext context, int index) {
            return FileListItem(widget.directory.filesInDir[index], index, openPlayerTray, changePlayerView);
          }
      )
    );
  }

  Future<void> openPlayerTray(Widget _widget, {String filePath, bool changeView = false}) async {
    playerWidget = _widget;
    if(!changeView) {
      if(filePath != null) await _prepareQueue(true, filePath: filePath);
      await AudioService.stop();
      await _startAudioService(filePath!=null? _singleFileQueue : _queue);
      closePlayerTray();
    }
    Statics.controller = _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
      bottomSheetVisible = true;
      return GestureDetector(
          onVerticalDragStart: (_) {},
          child: playerWidget
      );
    });
  }

  void closePlayerTray() {
    AudioService.playbackStateStream.listen((event) {
      if(!AudioService.running && bottomSheetVisible) {
        Navigator.of(context).pop();
        bottomSheetVisible = false;
      }
    });
  }

  void changePlayerView(int view) {
    if(view == 0){
      playerWidget = PlayerFullScreenSheet(changePlayerView);
    }else {
      playerWidget = PlayerTraySheet(changePlayerView);
    }
    Statics.controller.close();
    openPlayerTray(playerWidget, changeView: true);
  }

  Future<void> _prepareQueue(bool single, {String filePath}) async {
    if(single) {
      _singleFileQueue.clear();
      await metadata.getAudioMetaData(filePath);
      MediaItem mediaItem = MediaItem(id: filePath, album: metadata.album, title: filePath.split('/').last.split('.').first);
      _singleFileQueue.add(mediaItem);
    }else {
      _queue.clear();
      for(AudioFile file in widget.directory.filesInDir) {
        await metadata.getAudioMetaData(file.filePath);
        MediaItem mediaItem = MediaItem(id: file.filePath, album: metadata.album, title: file.filePath.split('/').last.split('.').first);
        _queue.add(mediaItem);
      }
    }
  }

  _startAudioService(List<MediaItem> queue) async {
    print('Starting audio service.');
    List<dynamic> list = List();
    for (int i = 0; i < queue.length; i++) {
      var m = queue[i].toJson();
      list.add(m);
    }
    var params = {"data": list};
    await AudioService.start(
      backgroundTaskEntrypoint: _audioPlayerTaskEntryPoint,
      androidEnableQueue: true,
      androidNotificationChannelName: 'AirWave',
      androidNotificationChannelDescription: 'Description',
      androidNotificationColor: 0xFFE7F6FB,
      androidNotificationIcon: 'mipmap/ic_launcher',
      params: params,
    );
  }
}

void _audioPlayerTaskEntryPoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}
