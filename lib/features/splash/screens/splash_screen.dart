import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:klixstore/helper/responsive_helper.dart';
import 'package:klixstore/localization/language_constrants.dart';
import 'package:klixstore/main.dart';
import 'package:klixstore/features/auth/providers/auth_provider.dart';
import 'package:klixstore/features/cart/providers/cart_provider.dart';
import 'package:klixstore/provider/language_provider.dart';
import 'package:klixstore/features/splash/providers/splash_provider.dart';
import 'package:klixstore/utill/app_constants.dart';
import 'package:klixstore/utill/images.dart';
import 'package:klixstore/utill/routes.dart';
import 'package:klixstore/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  late StreamSubscription<List<ConnectivityResult>> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool firstTime = true;
    _onConnectivityChanged =
        Connectivity().onConnectivityChanged.listen((result) {
      if (!firstTime) {
        bool isNotConnected = result.contains(ConnectivityResult.mobile) ||
            result.contains(ConnectivityResult.wifi);
        isNotConnected
            ? const SizedBox()
            : _globalKey.currentState!.hideCurrentSnackBar();
        _globalKey.currentState!.showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected
                ? getTranslated('no_connection', _globalKey.currentContext!)
                : getTranslated('connected', _globalKey.currentContext!),
            textAlign: TextAlign.center,
          ),
        ));

        if (!isNotConnected) {
          _routeToPage();
        }
      }

      firstTime = false;
    });

    Provider.of<SplashProvider>(context, listen: false).initSharedData();

    Provider.of<CartProvider>(context, listen: false).getCartData();
    _routeToPage();
    Provider.of<LanguageProvider>(context, listen: false)
        .initializeAllLanguages(context);
  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Theme.of(context).cardColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              Images.logo2,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ), // Increased size
            // Text(AppConstants.appName,
            //     style: rubikBold.copyWith(fontSize: 30, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  void _routeToPage() {
    Provider.of<SplashProvider>(context, listen: false)
        .initConfig()
        .then((bool isSuccess) {
      if (isSuccess) {
        Timer(const Duration(seconds: 1), () async {
          double minimumVersion = 0.0;
          if (Platform.isAndroid) {
            if (Provider.of<SplashProvider>(context, listen: false)
                    .configModel!
                    .playStoreConfig!
                    .minVersion !=
                null) {
              minimumVersion =
                  Provider.of<SplashProvider>(context, listen: false)
                          .configModel!
                          .playStoreConfig!
                          .minVersion ??
                      6.0;
            }
          } else if (Platform.isIOS) {
            if (Provider.of<SplashProvider>(context, listen: false)
                    .configModel!
                    .appStoreConfig!
                    .minVersion !=
                null) {
              minimumVersion =
                  Provider.of<SplashProvider>(context, listen: false)
                          .configModel!
                          .appStoreConfig!
                          .minVersion ??
                      6.0;
            }
          }

          if (AppConstants.appVersion < minimumVersion &&
              !ResponsiveHelper.isWeb()) {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.getUpdateRoute(), (route) => false);
          } else if (Provider.of<SplashProvider>(context, listen: false)
              .configModel!
              .maintenanceMode!) {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.getMaintainRoute(), (route) => false);
          } else {
            if (Provider.of<AuthProvider>(context, listen: false)
                .isLoggedIn()) {
              Provider.of<AuthProvider>(context, listen: false).updateToken();

              Navigator.pushNamedAndRemoveUntil(
                  Get.context!, Routes.getMainRoute(), (route) => false);
            } else {
              if (Provider.of<SplashProvider>(context, listen: false)
                  .showLang()) {
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    ResponsiveHelper.isMobile(context)
                        ? Routes.getLanguageRoute('splash')
                        : Routes.getMainRoute(),
                    (route) => false);
              } else {
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.getMainRoute(), (route) => false);
              }
            }
          }
        });
      }
    });
  }
}
