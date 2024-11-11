import 'package:klixstore/utill/dimensions.dart';
import 'package:klixstore/utill/styles.dart';
import 'package:klixstore/common/widgets/custom_directionality_widget.dart';
import 'package:flutter/material.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget(
      {Key? key, required this.title, required this.subTitle, this.style})
      : super(key: key);

  final String title;
  final String subTitle;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title,
          style: style ??
              rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
      CustomDirectionalityWidget(
          child: Text(
        subTitle,
        style:
            style ?? rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
      )),
    ]);
  }
}
