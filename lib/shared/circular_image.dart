import 'package:flutter/material.dart';

class CircularImageView extends StatelessWidget {
  final double width, borderWidth;
  final String image;
  final Color borderColor;

  CircularImageView(this.image, this.width, this.borderWidth, this.borderColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, style: BorderStyle.solid, width: borderWidth),
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(image)
          )
      ),
    );
  }
}
