import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_player/configs/menu_config.dart';
import 'package:flutter_audio_player/configs/size_config.dart';
import 'package:flutter_audio_player/models/storage_file_system.dart';
import 'package:flutter_audio_player/screens/audio_list/ui/widgets/player_fullscreen_sheet.dart';
import 'package:flutter_audio_player/screens/audio_list/ui/widgets/player_tray_sheet.dart';
import 'package:flutter_audio_player/services/ad_manager.dart';
import 'package:flutter_audio_player/services/audio_player_service.dart';
import 'package:flutter_audio_player/services/audio_state_stream.dart';
import 'package:flutter_audio_player/services/network_manager.dart';
import 'package:flutter_audio_player/shared/audio_detail_dialog.dart';
import 'package:flutter_audio_player/shared/file_list_item.dart';
import 'package:flutter_audio_player/shared/loading_dialog.dart';
import 'package:flutter_audio_player/shared/toolbar.dart';
import 'package:flutter_audio_player/theme/colors.dart';
import 'package:flutter_audio_player/utils/audio_metadata.dart';
import 'package:flutter_audio_player/utils/static.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';

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
  IconData fabBtnIcon;
  List<AudioFile> _filesList = [];
  AdmobBanner bannerAd;
  bool networkConnected = false;
  double adContainerHeight = Statics.adContainerHeight;
  AdmobInterstitial interstitialAd;

  @override
  void initState() {
    super.initState();
    interstitialAd = AdMobManager.buildInterstitialAd(_adEventCallback);
    _getNetworkStatus();
    _filesList = List.from(widget.directory.filesInDir);
    _scaffoldKey = new  GlobalKey<ScaffoldState>();
    metadata = AudioMetadata();
    _connectService();
    _prepareQueue(false);
    fabBtnIcon = FontAwesomeIcons.play;
    _loadAndInsertAd();
    interstitialAd.load();
  }

  _getNetworkStatus() async {
    networkConnected = await NetworkManager.isNetworkConnected();
  }

  _loadAndInsertAd() {
    // Loading Ad
    if(bannerAd == null) {
      // Adding null as Ad placeholder
      int randIndex = _filesList.length;
      if (_filesList.length > 3) {
        Random random = Random();
        randIndex = random.nextInt(_filesList.length);
      } else {
        adContainerHeight = 250;
      }
      print('random index: $randIndex');
      NetworkManager.isNetworkConnected().then((value) {
        if (value) {
          _filesList.insert(randIndex, null);
          bannerAd = AdMobManager.buildBannerAd(
              _filesList.length > 4 ? Statics.bannerSize : AdmobBannerSize
                  .MEDIUM_RECTANGLE);
          setState(() {});
        }
      });
    }
  }

  _adEventCallback(AdmobAdEvent event) {
    if (event == AdmobAdEvent.closed) interstitialAd.load();
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
      appBar: ToolBar('$dirName', true,
        leadingIcon: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
            child: Icon(FontAwesomeIcons.arrowLeft, color: AppColors.secondaryColor, size: 2.5 * SizeConfig.heightMultiplier,),),
        action: _folderMenu(),
      ),

      floatingActionButton: StreamBuilder<AudioState>(
        stream: audioStateStream,
        builder: (context, snapshot) {
          final audioState = snapshot.data;
          final playbackState = audioState?.playbackState;
          final playing = playbackState!=null? playbackState.playing : false;
          if(playbackState!=null) {
            if(!playing) {
              fabBtnIcon = FontAwesomeIcons.play;
            }else{
              fabBtnIcon = FontAwesomeIcons.stop;
            }
          }else{
            fabBtnIcon = FontAwesomeIcons.play;
          }
          return FloatingActionButton(
            onPressed: () => _fabAction(playing),
            child: Center(child: Icon(fabBtnIcon, size: 2.75 * SizeConfig.heightMultiplier, color: Colors.white,)),
          );
        },
      ),
      body: pageBody(),
    );
  }

  _folderMenu() {
    return PopupMenuButton<String>(
      icon: Icon(FontAwesomeIcons.ellipsisH, size: 5 * SizeConfig.widthMultiplier),
      onSelected: (value) {
        int index = AppbarMenuConfig.folderMenuItems.indexOf(value);
        _popupMenuAction(index);
      },
      itemBuilder: (BuildContext context) {
        return AppbarMenuConfig.folderMenuItems.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }
  _fileShare(AudioDirectory dir) async {
    final RenderBox box = context.findRenderObject();
    List<String> paths = [];
    AudioMetadata metadata = AudioMetadata();
    await metadata.getAudioMetaData(dir.filesInDir[0].filePath);

    for(AudioFile file in dir.filesInDir) {
      paths.add(file.filePath);
    }
    if(Platform.isAndroid) {
      Share.shareFiles(paths, mimeTypes: [metadata.mimeType],
          subject: 'Share audio file with...',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }

  _popupMenuAction(int index) {
    switch(index) {
      case 0:  // Share
        _fileShare(widget.directory);
        break;
      case 1:  // Properties
        showDialog(context: context, builder: (context) => FolderPropertyDialog(widget.directory));
        break;
    }
  }
  
  _fabAction(bool _playing) {
    print('playing...clicked');
    if(_playing) {
      print('playing...');
      AudioService.stop();
      setState(() {
        fabBtnIcon = FontAwesomeIcons.play;
      });
      if(networkConnected) {
        Timer(Duration(seconds: 1), () {
          _showAdLoadingDialog();
        });
      }
    }else{
      print('not playing, stopped...');
      openPlayerTray(PlayerTraySheet(changePlayerView));
    }
  }

  _showAdLoadingDialog() {
    showDialog(context: context,
      builder: (context) {
        return LoadingDialog('Ad Loading...');
      }, barrierDismissible: false);
    Timer(Duration(seconds: 2), () async {
      Navigator.of(context).pop();
      if(await interstitialAd.isLoaded){
        interstitialAd.show();
      }
    });
  }

  Widget pageBody() {
    return Container(
      child: ListView.builder(
        itemCount: _filesList.length,
          itemBuilder: (BuildContext context, int index) {
            if(_filesList[index]==null && networkConnected) {
              return Container(
                  width: double.infinity,
                  height: adContainerHeight,
                  color: AppColors.accentColor,
                  child: bannerAd);
            }else{
              return FileListItem(_filesList[index], index, openPlayerTray, changePlayerView);
            }
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
    AudioService.setSpeed(Statics.playerSpeed);
  }
}

void _audioPlayerTaskEntryPoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}
