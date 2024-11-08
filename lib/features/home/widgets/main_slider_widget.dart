import 'package:carousel_slider/carousel_slider.dart';
import 'package:hexacom_user/features/home/domain/models/banner_model.dart';
import 'package:hexacom_user/features/home/enums/banner_type_enum.dart';
import 'package:hexacom_user/features/home/widgets/main_slider_shimmer_widget.dart';
import 'package:hexacom_user/helper/product_helper.dart';
import 'package:hexacom_user/helper/responsive_helper.dart';
import 'package:hexacom_user/features/splash/providers/splash_provider.dart';
import 'package:hexacom_user/utill/dimensions.dart';
import 'package:hexacom_user/utill/images.dart';
import 'package:hexacom_user/utill/styles.dart';
import 'package:hexacom_user/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainSliderWidget extends StatefulWidget {
  final List<BannerModel>? bannerList;
  final BannerType bannerType;
  final bool isMainOnly;

  const MainSliderWidget({
    Key? key,
    required this.bannerList,
    required this.bannerType,
    this.isMainOnly = false,
  }) : super(key: key);

  @override
  State<MainSliderWidget> createState() => _MainSliderWidgetState();
}

class _MainSliderWidgetState extends State<MainSliderWidget> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return widget.bannerList == null
        ? const MainSliderShimmerWidget()
        : widget.bannerList!.isNotEmpty
            ? Row(
                children: [
                  // Main Slider on the left (Large)
                  Expanded(
                    flex: 2, // Make this part larger
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(Dimensions.paddingSizeDefault),
                      child: CarouselSlider.builder(
                        itemCount: widget.bannerList!.length,
                        options: CarouselOptions(
                          autoPlayInterval: Duration(
                            milliseconds:
                                widget.bannerType == BannerType.primary
                                    ? 4200
                                    : 5320,
                          ),
                          height:
                              size.width * 0.6, // Adjust size to make it bigger
                          aspectRatio: 1.0,
                          enlargeCenterPage: true,
                          viewportFraction: 1,
                          autoPlay: true,
                          autoPlayCurve: Curves.easeInToLinear,
                          autoPlayAnimationDuration: Duration(
                            milliseconds:
                                widget.bannerType == BannerType.primary
                                    ? 2000
                                    : 3000,
                          ),
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),
                        itemBuilder: (ctx, index, realIdx) {
                          BannerModel banner = widget.bannerList![index];
                          return InkWell(
                            borderRadius: BorderRadius.circular(
                                Dimensions.paddingSizeDefault),
                            onTap: () => ProductHelper.onTapBannerForRoute(
                                banner, context),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(
                                    Dimensions.paddingSizeDefault),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.paddingSizeDefault),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CustomImageWidget(
                                      placeholder: widget.isMainOnly
                                          ? Images.placeHolderOneToOne
                                          : Images.placeholder(context),
                                      image:
                                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}/${banner.image}',
                                      width: size.width *
                                          0.6, // Make image width larger
                                      height: size.width *
                                          0.6, // Make image height larger
                                      fit: BoxFit.cover,
                                    ),
                                    // Title Overlay
                                    Positioned(
                                      bottom: 20,
                                      left: 20,
                                      right: 20,
                                      child: Text(
                                        banner.title ?? 'No Title',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 10,
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              offset: Offset(2, 2),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Right Section with two smaller sliders stacked vertically
                  Expanded(
                    flex: 1, // Smaller size for the right section
                    child: Column(
                      children: [
                        // First Smaller Slider (show different images)
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                Dimensions.paddingSizeDefault),
                            child: CarouselSlider.builder(
                              itemCount: widget.bannerList!.length,
                              options: CarouselOptions(
                                height: 180, // Smaller height
                                enlargeCenterPage: true,
                                viewportFraction: 1.0,
                                autoPlay: true,
                                autoPlayInterval: Duration(milliseconds: 3000),
                              ),
                              itemBuilder: (ctx, index, realIdx) {
                                // Get a different banner for this smaller slider
                                BannerModel banner = widget.bannerList![
                                    (index + 1) % widget.bannerList!.length];
                                return InkWell(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.paddingSizeDefault),
                                  onTap: () =>
                                      ProductHelper.onTapBannerForRoute(
                                          banner, context),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.paddingSizeDefault),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.paddingSizeDefault),
                                      child: CustomImageWidget(
                                        placeholder:
                                            Images.placeholder(context),
                                        image:
                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}/${banner.image}',
                                        width: size.width -
                                            50, // Smaller width for smaller sliders
                                        height: 180,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 10), // Spacer between sliders
                        // Second Smaller Slider (show different images)
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                Dimensions.paddingSizeDefault),
                            child: CarouselSlider.builder(
                              itemCount: widget.bannerList!.length,
                              options: CarouselOptions(
                                height: 180, // Smaller height
                                enlargeCenterPage: true,
                                viewportFraction: 1.0,
                                autoPlay: true,
                                autoPlayInterval: Duration(milliseconds: 3000),
                              ),
                              itemBuilder: (ctx, index, realIdx) {
                                // Get a different banner for this smaller slider
                                BannerModel banner = widget.bannerList![
                                    (index + 2) % widget.bannerList!.length];
                                return InkWell(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.paddingSizeDefault),
                                  onTap: () =>
                                      ProductHelper.onTapBannerForRoute(
                                          banner, context),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.paddingSizeDefault),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.paddingSizeDefault),
                                      child: CustomImageWidget(
                                        placeholder:
                                            Images.placeholder(context),
                                        image:
                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}/${banner.image}',
                                        width: size.width -
                                            50, // Smaller width for smaller sliders
                                        height: 180,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const SizedBox();
  }
}
