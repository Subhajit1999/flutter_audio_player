import 'package:media_metadata_plugin/media_media_data.dart';
import 'package:media_metadata_plugin/media_metadata_plugin.dart';

class AudioMetadata {
  String audioTitle, album, artist, timeStamp;
  int durationMin, durationSec;
  Duration duration;

  Future<void> getAudioMetaData(String filePath) async {
    audioTitle = filePath.split('/').last;
    AudioMetaData metaData = await MediaMetadataPlugin.getMediaMetaData(filePath);
    album = metaData.album!=null? metaData.album : 'Unknown';
    artist = metaData.artistName!=null? metaData.artistName : 'Unknown';
    double sec = metaData.trackDuration/1000;
    durationMin = (sec ~/ 60);
    durationSec = (sec % 60).toInt();
    duration = Duration(minutes: durationMin, seconds: durationSec);
    timeStamp = getTimeStamp(Duration(minutes: durationMin, seconds: durationSec));
  }

  String getTimeStamp(Duration duration) {
    return '${durationMin==0? '00' : durationMin<10? '0$durationMin' : '$durationMin'}:'
        '${durationSec==0? '00' : durationSec<10? '0$durationSec' : '$durationSec'}';
  }
}