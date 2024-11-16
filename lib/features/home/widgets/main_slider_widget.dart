import 'package:carousel_slider/carousel_slider.dart';
import 'package:klixstore/features/home/domain/models/banner_model.dart';
import 'package:klixstore/features/home/enums/banner_type_enum.dart';
import 'package:klixstore/features/home/widgets/main_slider_shimmer_widget.dart';
import 'package:klixstore/helper/product_helper.dart';
import 'package:klixstore/helper/responsive_helper.dart';
import 'package:klixstore/features/splash/providers/splash_provider.dart';
import 'package:klixstore/utill/dimensions.dart';
import 'package:klixstore/utill/images.dart';
import 'package:klixstore/utill/styles.dart';
import 'package:klixstore/common/widgets/custom_image_widget.dart';
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
                    flex: 3, // Increase flex to make this part larger
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(Dimensions.paddingSizeDefault),
                      child: CarouselSlider.builder(
                        itemCount: widget.bannerList!.length > 3
                            ? 3
                            : widget.bannerList!.length,
                        options: CarouselOptions(
                          autoPlayInterval: Duration(
                              milliseconds:
                                  widget.bannerType == BannerType.primary
                                      ? 4200
                                      : 5320),
                          height:
                              size.width * 0.9, // Increase height if necessary
                          aspectRatio:
                              1.2, // Adjust aspect ratio for wider look
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
                                          0.8, // Increased width for image
                                      height: size.width *
                                          0.6, // Increased height for image
                                      fit: BoxFit.contain,
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
                  // Displaying the current slider number on the right
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0), // spacing from the main slider
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${currentIndex + 1} / ${widget.bannerList!.length > 3 ? 3 : widget.bannerList!.length}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
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
