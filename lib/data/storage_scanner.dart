import 'dart:io';
import 'package:flutter_audio_player/models/storage_file_system.dart';
import 'package:flutter_audio_player/utils/static.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';

class StorageFileScanner {

  Future<dynamic> scanFileFromStorage(int storageIndex) async {
    List<FileSystemEntity> files;
    List<AudioDirectory> audioDirs = [];
    StorageFileSystem fileSystem;

    Directory root = Directory(Statics.availableStorage[storageIndex].rootDir);

    // Finding all available files
    var fm = FileManager(root: root);
    files = await fm.filesTree(
        excludedPaths: ["$root/Android"],
        extensions: ["mp3","m4a"]
    );

    // Getting all the files organised parent folder wise
    Directory prev = root;
    for(FileSystemEntity entity in files) {
      Directory dir = entity.parent;
      if(dir.path != prev.path) {
        prev = dir;

        List<File> filesInDir = await FileManager(root: dir).filesTree(   // Getting folder wise files
            extensions: ["mp3"]
        );
        List<AudioFile> audioFiles = [];
        for(File file in filesInDir) {   // Saving file paths to a temp list
          audioFiles.add(AudioFile(filePath: file.path));
        }
        audioDirs.add(AudioDirectory(directoryPath: dir.path, filesInDir: audioFiles));  // Saving audio Directories
      }
    }
    fileSystem = StorageFileSystem(rootPath: root.path, audioDirs: audioDirs); // Saving Root fileSystem

    return fileSystem;
  }
}