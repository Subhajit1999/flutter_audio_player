import 'package:flutter/material.dart';
import 'package:flutter_audio_player/configs/menu_config.dart';
import 'package:flutter_audio_player/configs/size_config.dart';
import 'package:flutter_audio_player/theme/colors.dart';
import 'package:flutter_audio_player/utils/sizes.dart';
import 'package:flutter_audio_player/utils/strings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ToolBar extends StatefulWidget with PreferredSizeWidget{
  @override
  final Size preferredSize;

  ToolBar({Key key}) : preferredSize = Size.fromHeight(Sizes.mainToolBarSize),
        super(key: key);

  @override
  _ToolBarState createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      iconTheme: Theme.of(context).primaryIconTheme,
      backgroundColor: AppColors.primaryColor,
      title: Text(Strings.appName, style: Theme.of(context).textTheme.headline5.copyWith(

      ),),
      actions: [
        popupMenu()
      ],
    );
  }

  Widget popupMenu() {
    return PopupMenuButton<String>(
      icon: Icon(FontAwesomeIcons.ellipsisH, size: 5 * SizeConfig.widthMultiplier,),
      onSelected: handleClick,
      itemBuilder: (BuildContext context) {
        return AppbarMenuConfig.appbarMenuItems.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  void handleClick(String value) {
    switch (value) {
    }
  }
}
