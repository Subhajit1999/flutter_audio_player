import 'package:flutter/material.dart';
import 'package:flutter_audio_player/configs/size_config.dart';

class LoadingDialog extends StatelessWidget {
  final String text;

  LoadingDialog(this.text);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(SizeConfig.heightMultiplier))),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        height: 8 * SizeConfig.heightMultiplier,
        padding: EdgeInsets.symmetric(vertical: 2 * SizeConfig.heightMultiplier, horizontal: 8.9 * SizeConfig.widthMultiplier),
        child: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 4.4 * SizeConfig.widthMultiplier,),
            Text(text, style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontSize: 2.5 * SizeConfig.textMultiplier
            ),)
          ],
        ),
      ),
    );
  }
}
