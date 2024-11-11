import 'package:carousel_slider/carousel_slider.dart';
import 'package:klixstore/helper/product_helper.dart';
import 'package:klixstore/helper/responsive_helper.dart';
import 'package:klixstore/localization/language_constrants.dart';
import 'package:klixstore/features/home/providers/banner_provider.dart';
import 'package:klixstore/features/splash/providers/splash_provider.dart';
import 'package:klixstore/utill/dimensions.dart';
import 'package:klixstore/utill/images.dart';
import 'package:klixstore/utill/styles.dart';
import 'package:klixstore/common/widgets/custom_image_widget.dart';
import 'package:klixstore/common/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({Key? key}) : super(key: key);

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final ScrollController _scrollController = ScrollController();
  double _progressValue = 0.2;
  double _currentSliderValue = 0;
  double _listLength = 0;
  int _currentIndex = 0; // Track the current banner index

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateProgress);
  }

  void _updateProgress() {
    double maxScrollExtent = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;
    double progress = currentScroll / maxScrollExtent;
    setState(() {
      _progressValue = progress;
      _currentSliderValue = _progressValue * _listLength;
      if (_currentSliderValue < 1) {
        _currentSliderValue = 0;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateProgress);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double size =
        MediaQuery.sizeOf(context).width - (Dimensions.paddingSizeDefault * 2);

    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: TitleWidget(title: getTranslated('banner', context)),
      ),
      Stack(children: [
        SizedBox(
          height: (size), // Height for the large image
          child: Consumer<BannerProvider>(
            builder: (context, banner, child) {
              if (banner.bannerList != null) {
                _listLength = banner.bannerList!.length.toDouble();
                if (_listLength == 1) {
                  _progressValue = 1;
                }
              }

              return banner.bannerList != null
                  ? banner.bannerList!.isNotEmpty
                      ? Column(
                          children: [
                            // Carousel for Large Banner Image
                            CarouselSlider.builder(
                              itemCount: banner.bannerList!.length,
                              itemBuilder: (context, index, realIndex) {
                                return InkWell(
                                  onTap: () =>
                                      ProductHelper.onTapBannerForRoute(
                                          banner.bannerList![index], context),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CustomImageWidget(
                                      placeholder: Images.placeholder(context),
                                      image:
                                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}/${banner.bannerList![index].image}',
                                      width: size,
                                      height:
                                          (size / 2), // Height for large banner
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                height: size /
                                    2, // Adjusting height for the carousel
                                viewportFraction: 1.0,
                                enlargeCenterPage: true,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 3),
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currentIndex =
                                        index; // Update the current index
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: Dimensions.paddingSizeSmall),

                            // Carousel for Two Smaller Banners Below the Carousel
                            CarouselSlider.builder(
                              itemCount: banner.bannerList!.length,
                              itemBuilder: (context, index, realIndex) {
                                // Show only smaller banners (skip the first one for large banner)
                                if (index == 0)
                                  return Container(); // Skip first large banner
                                return InkWell(
                                  onTap: () =>
                                      ProductHelper.onTapBannerForRoute(
                                          banner.bannerList![index], context),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CustomImageWidget(
                                      placeholder: Images.placeholder(context),
                                      image:
                                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}/${banner.bannerList![index].image}',
                                      width: size / 2 -
                                          Dimensions.paddingSizeSmall,
                                      height: (size /
                                          3), // Height for small banners
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                height: size / 3,
                                viewportFraction: 0.45,
                                enlargeCenterPage: true,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 3),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                              getTranslated('no_banner_available', context)))
                  : const BannerShimmer();
            },
          ),
        ),
        Consumer<BannerProvider>(builder: (context, banner, child) {
          return Positioned(
            right: 35,
            bottom: 20,
            top: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${_currentIndex + 1}/${_listLength.toInt()}', // Updated index display
                    style: rubikRegular.copyWith(
                        color: Theme.of(context).cardColor)),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                RotatedBox(
                  quarterTurns: 3,
                  child: SizedBox(
                    height: 5,
                    width: 120,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft:
                              Radius.circular(Dimensions.radiusSizeDefault),
                          topLeft:
                              Radius.circular(Dimensions.radiusSizeDefault)),
                      child: LinearProgressIndicator(
                        minHeight: 5,
                        value: (_currentIndex + 1) / _listLength,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context)
                                .colorScheme
                                .error
                                .withOpacity(0.8)),
                        backgroundColor: Theme.of(context).cardColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ]),
    ]);
  }
}

class BannerShimmer extends StatelessWidget {
  const BannerShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      enabled: Provider.of<BannerProvider>(context).bannerList == null,
      child: Container(
        width: ResponsiveHelper.isDesktop(context)
            ? 320
            : MediaQuery.sizeOf(context).width - 32,
        height: 160,
        margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).shadowColor,
                spreadRadius: 1,
                blurRadius: 5)
          ],
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
