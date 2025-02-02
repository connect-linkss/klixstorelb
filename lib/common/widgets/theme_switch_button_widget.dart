import 'package:klixstore/localization/language_constrants.dart';
import 'package:klixstore/provider/theme_provider.dart';
import 'package:klixstore/utill/dimensions.dart';
import 'package:klixstore/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSwitchButtonWidget extends StatefulWidget {
  final bool fromWebBar;
  const ThemeSwitchButtonWidget({Key? key, this.fromWebBar = true})
      : super(key: key);

  @override
  State<ThemeSwitchButtonWidget> createState() =>
      _ThemeSwitchButtonWidgetState();
}

class _ThemeSwitchButtonWidgetState extends State<ThemeSwitchButtonWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, _) {
      return InkWell(
        hoverColor: Colors.transparent,
        onTap: () => themeProvider.toggleTheme(),
        child: AnimatedContainer(
          curve: Curves.easeInOutCirc,
          duration: const Duration(seconds: 1),
          child: Row(children: [
            if (widget.fromWebBar)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall),
                child: Text(
                    getTranslated(
                        themeProvider.darkTheme ? 'dark' : 'light', context),
                    style: rubikMedium.copyWith(
                        fontSize: Dimensions.fontSizeSmall)),
              ),
            Icon(
              themeProvider.darkTheme ? Icons.dark_mode : Icons.light_mode,
              size: widget.fromWebBar ? Dimensions.paddingSizeLarge : 35,
              color: widget.fromWebBar ? null : Colors.white,
            ),
          ]),
        ),
      );
    });
  }
}
