import 'package:flutter_audio_player/models/storage_file_system.dart';

abstract class FileScannerState {
  FileScannerState([List props = const []]);
}

class InitialState extends FileScannerState {
  @override
  String toString() => 'InitialState';

  @override
  List<Object> get props => [];
}

class ScanLoadingState extends FileScannerState {
  @override
  String toString() => 'ScanLoadingState';

  @override
  List<Object> get props => [];
}

class FileScanSuccessState extends FileScannerState {
  final StorageFileSystem internalFileSystem, externalFileSystem;

  FileScanSuccessState(this.internalFileSystem, this.externalFileSystem);

  @override
  String toString() => 'FileScanSuccessState';

  @override
  List<Object> get props => [];
}

class FileScanFailState extends FileScannerState {
  final String error;

  FileScanFailState(this.error);

  @override
  String toString() => 'FileScanFailState';

  @override
  List<Object> get props => [];
}