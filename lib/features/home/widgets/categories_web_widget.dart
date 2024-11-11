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
import 'package:klixstore/common/widgets/custom_slider_list_widget.dart';
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

  void scrollDown() {
    scrollController.animateTo(
      scrollController.offset + 200, // Scroll down by 200 pixels
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
                  height: 400,
                  child: Stack(
                    children: [
                      GridView.builder(
                        physics: const ClampingScrollPhysics(),
                        controller: scrollController,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6, // 6 items per row
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1,
                        ),
                        itemCount: category.categoryList?.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              hoverColor: Colors.transparent,
                              onTap: () => Navigator.pushNamed(
                                  context,
                                  Routes.getCategoryRoute(
                                      category.categoryList![index])),
                              child: Column(
                                children: [
                                  // Image Container
                                  Container(
                                    height:
                                        130, // Increased height for the image
                                    width: 130, // Increased width for the image
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(
                                          Provider.of<ThemeProvider>(context)
                                                  .darkTheme
                                              ? 0.05
                                              : 1),
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow:
                                          Provider.of<ThemeProvider>(context)
                                                  .darkTheme
                                              ? null
                                              : [
                                                  BoxShadow(
                                                    color: Theme.of(context)
                                                        .shadowColor,
                                                    blurRadius: 15,
                                                    offset: const Offset(3, 0),
                                                  ),
                                                ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: OnHover(
                                        child: CustomImageWidget(
                                          image: Provider.of<SplashProvider>(
                                                          context,
                                                          listen: false)
                                                      .baseUrls !=
                                                  null
                                              ? '${category.categoryList![index].image}'
                                              : '',
                                          width:
                                              150, // Adjusted to match new size
                                          height:
                                              150, // Adjusted to match new size
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Text Container (Card-like)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: SizedBox(
                                      width: 120,
                                      child: TextHoverWidget(
                                        builder: (hovered) {
                                          return Text(
                                            category.categoryList![index].name!,
                                            style: rubikRegular.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: hovered
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : null,
                                              fontSize:
                                                  Dimensions.fontSizeDefault,
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

                      // Scroll Down Arrow at the bottom
                      Positioned(
                        bottom: 10,
                        left: MediaQuery.of(context).size.width / 2 - 20,
                        child: GestureDetector(
                          onTap: scrollDown, // Scroll down when clicked
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Text(getTranslated('no_category_available', context)))
          : const CategoryShimmerWidget();
    });
  }
}
