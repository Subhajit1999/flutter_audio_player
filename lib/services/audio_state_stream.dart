import 'package:audio_service/audio_service.dart';
import 'package:flutter_audio_player/services/audio_player_service.dart';
import 'package:rxdart/rxdart.dart';

Stream<AudioState> get audioStateStream {
  return Rx.combineLatest3<List<MediaItem>, MediaItem, PlaybackState,
      AudioState>(
    AudioService.queueStream,
    AudioService.currentMediaItemStream,
    AudioService.playbackStateStream,
        (queue, mediaItem, playbackState) => AudioState(
      queue,
      mediaItem,
      playbackState,
    ),
  );
}