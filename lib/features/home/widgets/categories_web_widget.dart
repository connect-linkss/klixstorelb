// ignore_for_file: prefer_const_constructors

import 'package:klixstore/features/home/widgets/category_shimmer_widget.dart';
import 'package:klixstore/localization/language_constrants.dart';
import 'package:klixstore/features/category/providers/category_provider.dart';
import 'package:klixstore/features/splash/providers/splash_provider.dart';
import 'package:klixstore/provider/theme_provider.dart';
import 'package:klixstore/utill/dimensions.dart';
import 'package:klixstore/utill/routes.dart';
import 'package:klixstore/utill/styles.dart';
import 'package:klixstore/common/widgets/custom_image_widget.dart';
import 'package:klixstore/common/widgets/on_hover.dart';
import 'package:klixstore/common/widgets/text_hover_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesWebWidget extends StatefulWidget {
  const CategoriesWebWidget({Key? key}) : super(key: key);

  @override
  State<CategoriesWebWidget> createState() => _CategoriesWebWidgetState();
}

class _CategoriesWebWidgetState extends State<CategoriesWebWidget> {
  ScrollController scrollController = ScrollController();

  void scrollRight() {
    scrollController.animateTo(
      scrollController.offset + 200, // Scroll right by 200 pixels
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, category, child) {
      return category.categoryList != null
          ? category.categoryList!.isNotEmpty
              ? SizedBox(
                  height: 200, // Adjust height for horizontal scrolling
                  child: Stack(
                    children: [
                      ListView.builder(
                        scrollDirection: Axis.horizontal, // Horizontal scrolling
                        controller: scrollController,
                        itemCount: category.categoryList?.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Provider.of<ThemeProvider>(context).darkTheme
                                                        ? Theme.of(context).cardColor
                                                        : Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              hoverColor: Colors.transparent,
                              onTap: () => Navigator.pushNamed(context, Routes.getCategoryRoute(category.categoryList![index])),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Image Container
                                  Container(
                                    height: 150, // Outer container height
                                    width: 150, // Outer container width
                                    decoration: BoxDecoration(
                                      // color: Colors.white.withOpacity(
                                      //     Provider.of<ThemeProvider>(context)
                                      //             .darkTheme
                                      //         ? 0.05
                                      //         : 1),
                                      // borderRadius: BorderRadius.circular(
                                      //     100), // Circular shape
                                      boxShadow: Provider.of<ThemeProvider>(context).darkTheme
                                          ? null
                                          : [
                                              BoxShadow(
                                                color: Theme.of(context).shadowColor,
                                                blurRadius: 15,
                                                offset: const Offset(3, 0),
                                              ),
                                            ],
                                    ),
                                    child: Center(
                                      // Center the image inside the container
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(75), // Smaller radius for the image
                                        child: OnHover(
                                          child: CustomImageWidget(
                                            image: Provider.of<SplashProvider>(context, listen: false).baseUrls != null
                                                ? '${category.categoryList![index].image}'
                                                : '',
                                            width: 120, // Smaller image width
                                            height: 120, // Smaller image height
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Text Container
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: SizedBox(
                                      width: 130,
                                      child: TextHoverWidget(
                                        builder: (hovered) {
                                          return Text(
                                            category.categoryList![index].name!,
                                            style: rubikRegular.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: hovered ? Theme.of(context).primaryColor : null,
                                              fontSize: Dimensions.fontSizeDefault,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      // Scroll Right Button (Optional)
                      // Positioned(
                      //   right: 10,
                      //   top: 80,
                      //   child: GestureDetector(
                      //     onTap: scrollRight,
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         color: Theme.of(context).primaryColor,
                      //         borderRadius: BorderRadius.circular(50),
                      //       ),
                      //       padding: const EdgeInsets.all(8),
                      //       child: Icon(
                      //         Icons.arrow_forward,
                      //         color: Colors.white,
                      //         size: 24,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                )
              : Center(child: Text(getTranslated('no_category_available', context)))
          : const CategoryShimmerWidget();
    });
  }
}
