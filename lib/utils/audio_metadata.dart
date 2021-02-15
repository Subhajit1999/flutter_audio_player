import 'dart:io';
import 'package:media_metadata_plugin/media_media_data.dart';
import 'package:media_metadata_plugin/media_metadata_plugin.dart';

class AudioMetadata {
  String audioTitle, album, artist, timeStamp, mimeType, fileLocation, format;
  int durationMin, durationSec, fileSize;
  Duration duration;

  Future<void> getAudioMetaData(String filePath) async {
    audioTitle = filePath.split('/').last;
    fileSize = await File(filePath).length();
    fileLocation = filePath.replaceAll(audioTitle,'');
    AudioMetaData metaData = await MediaMetadataPlugin.getMediaMetaData(filePath);
    album = metaData.album!=null? metaData.album.trim().isNotEmpty? metaData.album.trim() : 'Unknown' : 'Unknown';
    artist = metaData.artistName!=null? metaData.artistName.trim().isNotEmpty? metaData.artistName.trim() : 'Unknown' : 'Unknown';
    double sec = metaData.trackDuration/1000;
    durationMin = (sec ~/ 60);
    durationSec = (sec % 60).toInt();
    duration = Duration(minutes: durationMin, seconds: durationSec);
    timeStamp = getTimeStamp(Duration(minutes: durationMin, seconds: durationSec));
    mimeType = metaData.mimeTYPE;
    format = filePath.split('/').last.split('.').last;
  }

  String getTimeStamp(Duration duration) {
    int _durationMin = duration.inMinutes;
    int _durationSec = duration.inSeconds-(_durationMin*60);
    return '${_durationMin==0? '00' : _durationMin<10? '0$_durationMin' : '$_durationMin'}:'
        '${_durationSec==0? '00' : _durationSec<10? '0$_durationSec' : '$_durationSec'}';
  }
}