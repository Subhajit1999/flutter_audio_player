import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_player/data/storage_scanner.dart';
import 'package:flutter_audio_player/models/storage_file_system.dart';
import 'package:flutter_audio_player/screens/main/bloc/scanner_event.dart';
import 'package:flutter_audio_player/screens/main/bloc/scanner_state.dart';
import 'package:flutter_audio_player/utils/static.dart';
import 'package:path_provider_ex/path_provider_ex.dart';


class FileScannerBloc extends Bloc<ScanFileStorageEvent, FileScannerState> {
  final StorageFileScanner scannerRepository;

  FileScannerBloc({@required this.scannerRepository}) : assert(scannerRepository != null);

  @override
  FileScannerState get initialState => InitialState() ;

  @override
  void onTransition(Transition<ScanFileStorageEvent, FileScannerState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  Stream<FileScannerState> mapEventToState(ScanFileStorageEvent event) async*{
    if (event is ScanFileStorage) {
      StorageFileSystem internalFileSystem, externalFileSystem;

      //Getting the storage info
      Statics.availableStorage = await PathProviderEx.getStorageInfo();
      try{
        internalFileSystem = await scannerRepository.scanFileFromStorage(0);
        if(Statics.availableStorage.length>1) {   // If external storage available
          externalFileSystem = await scannerRepository.scanFileFromStorage(1);
        }
        if(internalFileSystem != null) {
          yield FileScanSuccessState(internalFileSystem, externalFileSystem);
        }
      }catch(error) {
        yield FileScanFailState(error.toString());
      }
    }
  }
}