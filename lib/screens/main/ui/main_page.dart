import 'package:flutter/material.dart';
import 'package:flutter_audio_player/configs/size_config.dart';
import 'package:flutter_audio_player/shared/folder_list_item.dart';
import 'package:flutter_audio_player/shared/toolbar.dart';
import 'package:flutter_audio_player/theme/colors.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: ToolBar(),
      body: MainBody(),
    );
  }

  Widget MainBody() {
    return Container(
      width: double.infinity,
      height: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 5.6 * SizeConfig.widthMultiplier),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(2.5 * SizeConfig.heightMultiplier),
            topEnd: Radius.circular(2.5 * SizeConfig.heightMultiplier))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.5 * SizeConfig.heightMultiplier,),
          Text('Local Albums', style: Theme.of(context).textTheme.headline4.copyWith(

          ),),
          SizedBox(height: 3 * SizeConfig.heightMultiplier,),
          GridView.extent(
            shrinkWrap: true,
            primary: false,
            crossAxisSpacing: 1.25 * SizeConfig.heightMultiplier,
            mainAxisSpacing: 1.25 * SizeConfig.heightMultiplier,
            maxCrossAxisExtent: 200.0,
            children: [0,1,2,3,4,5].map((item) => FolderItem(item)).toList(),
          )
        ],
      )
    );
  }
}
