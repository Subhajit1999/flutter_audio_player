class StorageFileSystem {
  final String rootPath;
  final List<AudioDirectory> audioDirs;
  StorageFileSystem({this.rootPath, this.audioDirs});

  factory StorageFileSystem.fromJson(Map<String, dynamic> json) => StorageFileSystem(
    rootPath: json['root_path'],
    audioDirs: List<AudioDirectory>.from(json["dirs"].map((x) => AudioDirectory.fromJson(x)))
  );

  Map<String, dynamic> toJson() => {
    "root_path": rootPath,
    "dirs": List<dynamic>.from(audioDirs.map((x) => x.toJson())),
  };
}

class AudioDirectory {
  final String directoryPath;
  final List<AudioFile> filesInDir;
  AudioDirectory({this.directoryPath, this.filesInDir});

  factory AudioDirectory.fromJson(Map<String, dynamic> json) => AudioDirectory(
      directoryPath: json['dir_path'],
      filesInDir: List<AudioFile>.from(json["files"].map((x) => AudioFile.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "dir_path": directoryPath,
    "files": List<dynamic>.from(filesInDir.map((x) => x.toJson())),
  };
}

class AudioFile {
  final String filePath;
  AudioFile({this.filePath});

  factory AudioFile.fromJson(Map<String, dynamic> json) => AudioFile(
      filePath: json['file_path'],
  );

  Map<String, dynamic> toJson() => {
    "file_path": filePath,
  };
}