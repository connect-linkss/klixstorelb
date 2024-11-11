import 'package:klixstore/localization/language_constrants.dart';
import 'package:klixstore/features/flash_sale/providers/flash_sale_provider.dart';
import 'package:klixstore/utill/dimensions.dart';
import 'package:klixstore/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlashSaleTimerWidget extends StatelessWidget {
  const FlashSaleTimerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashSaleProvider>(
        builder: (context, flashSaleProvider, _) {
      int? days, hours, minutes, seconds;

      if (flashSaleProvider.duration != null) {
        days = flashSaleProvider.duration!.inDays;
        hours = flashSaleProvider.duration!.inHours - days * 24;
        minutes = flashSaleProvider.duration!.inMinutes -
            (24 * days * 60) -
            (hours * 60);
        seconds = flashSaleProvider.duration!.inSeconds -
            (24 * days * 60 * 60) -
            (hours * 60 * 60) -
            (minutes * 60);
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TimerWidget(
              timeCount: days ?? 0, timeUnit: getTranslated('days', context)),
          _ColonSeparator(),
          _TimerWidget(
              timeCount: hours ?? 0, timeUnit: getTranslated('hours', context)),
          _ColonSeparator(),
          _TimerWidget(
              timeCount: minutes ?? 0,
              timeUnit: getTranslated('mins', context)),
          _ColonSeparator(),
          _TimerWidget(
              timeCount: seconds ?? 0, timeUnit: getTranslated('sec', context)),
        ],
      );
    });
  }
}

class _ColonSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class _TimerWidget extends StatelessWidget {
  final int timeCount;
  final String timeUnit;

  const _TimerWidget(
      {Key? key, required this.timeUnit, required this.timeCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColorLight
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Text(
            timeCount > 9 ? timeCount.toString() : '0$timeCount',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          timeUnit,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
