import 'package:flutter/material.dart';
import 'package:flutter_audio_player/configs/size_config.dart';
import 'package:flutter_audio_player/models/storage_file_system.dart';
import 'package:flutter_audio_player/screens/main/bloc/scanner_bloc.dart';
import 'package:flutter_audio_player/screens/main/bloc/scanner_state.dart';
import 'package:flutter_audio_player/shared/folder_list_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StorageTabView extends StatefulWidget {
  final int storageIndex;

  StorageTabView(this.storageIndex);

  @override
  _StorageTabViewState createState() => _StorageTabViewState();
}

class _StorageTabViewState extends State<StorageTabView> {
  FileScannerBloc scannerBloc;

  @override
  void initState() {
    super.initState();
    scannerBloc = BlocProvider.of<FileScannerBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;

    return BlocBuilder<FileScannerBloc, FileScannerState>(
      bloc: scannerBloc,
      builder: (BuildContext context, FileScannerState state) {

        if (state is ScanLoadingState) {
          return Center(child: CircularProgressIndicator(),);

        } else if (state is FileScanSuccessState) {
          StorageFileSystem fileSystem = widget.storageIndex==0? state.internalFileSystem : state.externalFileSystem;
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 5.6 * SizeConfig.widthMultiplier),
            child: GridView.extent(
              primary: false,
              crossAxisSpacing: 1.25 * SizeConfig.heightMultiplier,
              mainAxisSpacing: 1.25 * SizeConfig.heightMultiplier,
              maxCrossAxisExtent: 200.0,
              children: fileSystem.audioDirs.map((item) {
                return FolderItem(i++, item);
              }).toList(),
            ),
          );

        }else if(state is FileScanFailState) {

        }
        return SizedBox();
      },
    );
  }
}
