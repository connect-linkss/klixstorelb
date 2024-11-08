import 'package:hexacom_user/helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:hexacom_user/localization/language_constrants.dart';
import 'package:hexacom_user/utill/dimensions.dart';
import 'package:hexacom_user/utill/styles.dart';

class TitleWidget extends StatelessWidget {
  final String? title;
  final Function? onTap;
  final Widget? leadingButton;

  const TitleWidget(
      {Key? key, required this.title, this.onTap, this.leadingButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title!,
          style: ResponsiveHelper.isDesktop(context)
              ? rubikMedium.copyWith(fontSize: Dimensions.fontSizeOverLarge)
              : rubikMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
        ),
        onTap != null
            ? InkWell(
                onTap: onTap as void Function()?,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    getTranslated('view_all', context),
                    style: rubikRegular.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
