import 'package:flutter/material.dart';
import 'package:flutter_audio_player/theme/colors.dart';
import 'package:flutter_audio_player/utils/sizes.dart';

class ToolBar extends StatefulWidget with PreferredSizeWidget{
  final String title;
  final bool hasAction;
  final Widget action, leadingIcon;

  @override
  final Size preferredSize;

  ToolBar(this.title, this.hasAction, {Key key, this.action, this.leadingIcon}) : preferredSize = Size.fromHeight(Sizes.mainToolBarSize),
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
      title: Text(widget.title, style: Theme.of(context).textTheme.headline5,
        maxLines: 1, overflow: TextOverflow.ellipsis,),
      leading: widget.leadingIcon,
      actions: [
        widget.hasAction? widget.action : SizedBox()
      ],
    );
  }
}
