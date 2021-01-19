abstract class ScanFileStorageEvent {
  ScanFileStorageEvent([List props = const []]);
}

class ScanFileStorage extends ScanFileStorageEvent {

  @override
  List<Object> get props => [];

  @override
  String toString() => 'ScanFileStorage';
}