// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:io';
import 'package:klixstore/common/widgets/cookies_widget.dart';
import 'package:klixstore/features/address/providers/location_provider.dart';
import 'package:klixstore/features/auth/providers/registration_provider.dart';
import 'package:klixstore/features/auth/providers/verification_provider.dart';
import 'package:klixstore/features/checkout/providers/checkout_provider.dart';
import 'package:klixstore/features/rate_review/providers/rate_review_provider.dart';
import 'package:klixstore/features/track/providers/order_map_provider.dart';
import 'package:klixstore/helper/notification_helper.dart';
import 'package:klixstore/helper/responsive_helper.dart';
import 'package:klixstore/helper/router_helper.dart';
import 'package:klixstore/features/flash_sale/providers/flash_sale_provider.dart';
import 'package:klixstore/utill/dimensions.dart';
import 'package:klixstore/utill/images.dart';
import 'package:klixstore/utill/routes.dart';
import 'package:klixstore/common/widgets/third_party_chat_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:klixstore/localization/app_localization.dart';
import 'package:klixstore/features/auth/providers/auth_provider.dart';
import 'package:klixstore/features/home/providers/banner_provider.dart';
import 'package:klixstore/features/cart/providers/cart_provider.dart';
import 'package:klixstore/features/category/providers/category_provider.dart';
import 'package:klixstore/features/chat/providers/chat_provider.dart';
import 'package:klixstore/features/coupon/providers/coupon_provider.dart';
import 'package:klixstore/provider/localization_provider.dart';
import 'package:klixstore/features/notification/providers/notification_provider.dart';
import 'package:klixstore/features/order/providers/order_provider.dart';
import 'package:klixstore/features/address/providers/address_provider.dart';
import 'package:klixstore/features/product/providers/product_provider.dart';
import 'package:klixstore/provider/language_provider.dart';
import 'package:klixstore/features/onboarding/providers/onboarding_provider.dart';
import 'package:klixstore/features/profile/providers/profile_provider.dart';
import 'package:klixstore/features/search/providers/search_provider.dart';
import 'package:klixstore/features/splash/providers/splash_provider.dart';
import 'package:klixstore/provider/theme_provider.dart';
import 'package:klixstore/features/wishlist/providers/wishlist_provider.dart';
import 'package:klixstore/theme/dark_theme.dart';
import 'package:klixstore/theme/light_theme.dart';
import 'package:klixstore/utill/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show PlatformDispatcher, kIsWeb;
import 'package:url_strategy/url_strategy.dart';
import 'di_container.dart' as di;
import 'provider/news_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  if (ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = MyHttpOverrides();
  }
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBRobgZqIC-dFsr05MzxUQXxQITjKpnDH0",
            authDomain: "emarket-e420c.firebaseapp.com",
            projectId: "emarket-e420c",
            storageBucket: "emarket-e420c.appspot.com",
            messagingSenderId: "151590191214",
            appId: "1:151590191214:web:6d2f54d2dd45fc7aa5667f",
            measurementId: "G-RQ899NQVHN"));

    // await FacebookAuth.instance.webAndDesktopInitialize(
    //   appId: "YOUR_APP_ID",
    //   cookie: true,
    //   xfbml: true,
    //   version: "v13.0",
    // );
  } else {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.requestPermission();

    //firebase crashlytics
    // FlutterError.onError = (errorDetails) {
    //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    // };
    //
    // PlatformDispatcher.instance.onError = (error, stack) {
    //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    //   return true;
    // };
  }
  await di.init();
  int? orderID;
  try {
    final RemoteMessage? remoteMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {
      orderID = remoteMessage.notification!.titleLocKey != null
          ? int.parse(remoteMessage.notification!.titleLocKey!)
          : null;
    }
    await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  } catch (e) {}

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LanguageProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OnBoardingProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CategoryProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BannerProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProductProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<RegistrationProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<VerificationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AddressProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CartProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderMapProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CheckoutProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ChatProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<NotificationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CouponProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<WishListProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<NewsLetterProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SearchProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<FlashSaleProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<RateReviewProvider>()),
    ],
    child: MyApp(orderId: orderID, isWeb: !kIsWeb),
  ));
}

class MyApp extends StatefulWidget {
  final int? orderId;
  final bool isWeb;
  const MyApp({Key? key, required this.orderId, required this.isWeb})
      : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    RouterHelper.setupRouter();

    if (kIsWeb) {
      Provider.of<SplashProvider>(context, listen: false).initSharedData();
      Provider.of<CartProvider>(context, listen: false).getCartData();
      Provider.of<SplashProvider>(context, listen: false).getPolicyPage();
      _route();
    }
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false)
        .initConfig()
        .then((bool isSuccess) async {
      if (isSuccess) {
        Timer(const Duration(seconds: 1), () async {
          Provider.of<AuthProvider>(context, listen: false).updateToken();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Locale> locals = [];
    for (var language in AppConstants.languages) {
      locals.add(Locale(language.languageCode!, language.countryCode));
    }
    return Consumer<SplashProvider>(
      builder: (context, splashProvider, child) {
        return (kIsWeb && splashProvider.configModel == null)
            ? const SizedBox()
            : MaterialApp(
                initialRoute: ResponsiveHelper.isMobilePhone()
                    ? widget.orderId == null
                        ? Routes.getSplashRoute()
                        : Routes.getOrderDetailsRoute(widget.orderId)
                    : splashProvider.configModel!.maintenanceMode!
                        ? Routes.getMaintainRoute()
                        : Routes.getMainRoute(),
                onGenerateRoute: RouterHelper.router.generator,
                title: splashProvider.configModel != null
                    ? splashProvider.configModel!.ecommerceName ?? ''
                    : AppConstants.appName,
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                theme: Provider.of<ThemeProvider>(context).darkTheme
                    ? dark
                    : light,
                locale: Provider.of<LocalizationProvider>(context).locale,
                localizationsDelegates: const [
                  AppLocalization.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: locals,
                scrollBehavior:
                    const MaterialScrollBehavior().copyWith(dragDevices: {
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.touch,
                  PointerDeviceKind.stylus,
                  PointerDeviceKind.unknown
                }),
                builder: (context, widget) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1)),
                  child: Material(
                      child: Stack(children: [
                    widget!,
                    // if (ResponsiveHelper.isDesktop(context))
                    //   Positioned.fill(
                    //     child: Align(
                    //         alignment: Alignment.bottomRight,
                    //         child: Padding(
                    //           padding: const EdgeInsets.symmetric(
                    //               vertical: 50, horizontal: 20),
                    //           child: Column(
                    //             children: [
                    //               GestureDetector(
                    //                 onTap: () {
                    //                   Navigator.pushNamed(
                    //                       context, Routes.getChatRoute());
                    //                 },
                    //                 child: Container(
                    //                   padding: const EdgeInsets.symmetric(
                    //                     vertical:
                    //                         Dimensions.paddingSizeExtraSmall,
                    //                     horizontal: Dimensions.paddingSizeSmall,
                    //                   ),
                    //                   height: 35,
                    //                   width: 55,
                    //                   decoration: BoxDecoration(
                    //                     borderRadius: BorderRadius.circular(20),
                    //                     color: Colors.white,
                    //                   ),
                    //                   child: Image.asset(
                    //                       Images.emailWithBackground),
                    //                 ),
                    //               ),
                    //               const ThirdPartyChatWidget(),
                    //             ],
                    //           ),
                    //         )),
                    //   ),
                    if (kIsWeb &&
                        splashProvider.configModel!.cookiesManagement != null &&
                        splashProvider
                            .configModel!.cookiesManagement!.status! &&
                        !splashProvider.getAcceptCookiesStatus(splashProvider
                            .configModel!.cookiesManagement!.content) &&
                        splashProvider.cookiesShow)
                      const Positioned.fill(
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: CookiesWidget())),
                  ])),
                ),
              );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class Get {
  static BuildContext? get context => navigatorKey.currentContext;
  static NavigatorState? get navigator => navigatorKey.currentState;
}
