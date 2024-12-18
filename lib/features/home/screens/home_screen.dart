// ignore_for_file: prefer_const_constructors

import 'package:klixstore/common/enums/footer_type_enum.dart';
import 'package:klixstore/common/enums/product_filter_type_enum.dart';
import 'package:klixstore/common/widgets/custom_app_bar_widget.dart';
import 'package:klixstore/common/widgets/custom_single_child_list_widget.dart';
import 'package:klixstore/common/widgets/footer_web_widget.dart';
import 'package:klixstore/common/widgets/home_app_bar_widget.dart';
import 'package:klixstore/common/widgets/product_filter_popup_widget.dart';
import 'package:klixstore/common/widgets/title_widget.dart';
import 'package:klixstore/common/widgets/web_app_bar_widget.dart';
import 'package:klixstore/features/auth/providers/auth_provider.dart';
import 'package:klixstore/features/category/providers/category_provider.dart';
import 'package:klixstore/features/home/enums/banner_type_enum.dart';
import 'package:klixstore/features/home/providers/banner_provider.dart';
import 'package:klixstore/features/flash_sale/providers/flash_sale_provider.dart';
import 'package:klixstore/features/home/widgets/banner_widget.dart';
import 'package:klixstore/features/home/widgets/category_widget.dart';
import 'package:klixstore/features/home/widgets/feature_category_widget.dart';
import 'package:klixstore/features/home/widgets/flash_sale_widget.dart';
import 'package:klixstore/features/home/widgets/main_slider_shimmer_widget.dart';
import 'package:klixstore/features/home/widgets/main_slider_widget.dart';
import 'package:klixstore/features/home/widgets/new_arrival_widget.dart';
import 'package:klixstore/features/home/widgets/offer_product_widget.dart';
import 'package:klixstore/features/home/widgets/product_list_widget.dart';
import 'package:klixstore/features/menu/widgets/options_widget.dart';
import 'package:klixstore/features/product/providers/product_provider.dart';
import 'package:klixstore/features/profile/providers/profile_provider.dart';
import 'package:klixstore/features/splash/providers/splash_provider.dart';
import 'package:klixstore/features/wishlist/providers/wishlist_provider.dart';
import 'package:klixstore/helper/product_helper.dart';
import 'package:klixstore/helper/responsive_helper.dart';
import 'package:klixstore/localization/language_constrants.dart';
import 'package:klixstore/utill/dimensions.dart';
import 'package:klixstore/utill/routes.dart';
import 'package:klixstore/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  static Future<void> loadData(BuildContext context, bool reload) async {
    final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final BannerProvider bannerProvider = Provider.of<BannerProvider>(context, listen: false);
    final ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final WishListProvider wishListProvider = Provider.of<WishListProvider>(context, listen: false);
    final FlashSaleProvider flashSaleProvider = Provider.of<FlashSaleProvider>(context, listen: false);
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (reload) {
      await splashProvider.initConfig();
    }

    splashProvider.getPolicyPage(reload: reload);

    if (authProvider.isLoggedIn() && (profileProvider.userInfoModel == null || reload)) {
      await profileProvider.getUserInfo();
      await wishListProvider.getWishList();
    }

    categoryProvider.getFeatureCategories(reload, isUpdate: reload);
    categoryProvider.getCategoryList(reload);
    bannerProvider.getBannerList(reload);
    productProvider.getOfferProductList(reload);
    productProvider.getLatestProductList(1, isUpdate: reload);
    flashSaleProvider.getFlashSaleProducts(1, reload);
    productProvider.getNewArrivalProducts(1, reload);
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();
  ProductFilterType? filterType;
  final ScrollController scrollController = ScrollController();
  final ScrollController newArrivalScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // delete save area here
    return Scaffold( 
      key: drawerGlobalKey,
      endDrawerEnableOpenDragGesture: false,
      drawer: ResponsiveHelper.isTab(context) ? const Drawer(child: OptionsWidget(onTap: null)) : const SizedBox(),
      // appBar: const CustomAppBarWidget(onlyDesktop: true, space: 0),
      appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(90), child: WebAppBarWidget()) : null,
      body: RefreshIndicator(
        color: Theme.of(context).secondaryHeaderColor,
        onRefresh: () async {
          filterType = null;
          Provider.of<ProductProvider>(context, listen: false).offset = 1;
          await HomeScreen.loadData(context, true);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            // App Bar
            ResponsiveHelper.isDesktop(context)
                ? const SliverToBoxAdapter(child: SizedBox())
                : HomeAppBarWidget(drawerGlobalKey: drawerGlobalKey),

            // Search Button
            // ResponsiveHelper.isDesktop(context)
            //     ? const SliverToBoxAdapter(child: SizedBox())
            //     : SliverPersistentHeader(
            //         pinned: true,
            //         delegate: _SliverDelegate(
            //           child: Center(
            //             child: InkWell(
            //               onTap: () => Navigator.pushNamed(
            //                   context, Routes.getSearchRoute()),
            //               child: Container(
            //                 height: 60,
            //                 width: Dimensions.webScreenWidth,
            //                 padding: const EdgeInsets.symmetric(
            //                   horizontal: Dimensions.paddingSizeSmall,
            //                   vertical: Dimensions.paddingSizeExtraSmall,
            //                 ),
            //                 child: Container(
            //                   decoration: BoxDecoration(
            //                     color: Theme.of(context)
            //                         .primaryColor
            //                         .withOpacity(0.04),
            //                     borderRadius: BorderRadius.circular(50),
            //                     border: Border.all(
            //                       color: Theme.of(context)
            //                           .primaryColor
            //                           .withOpacity(0.05),
            //                     ),
            //                   ),
            //                   child: Row(
            //                     children: [
            //                       Padding(
            //                         padding: const EdgeInsets.symmetric(
            //                           horizontal: Dimensions.paddingSizeSmall,
            //                         ),
            //                         child: Icon(
            //                           Icons.search,
            //                           size: 25,
            //                           color: Theme.of(context).primaryColor,
            //                         ),
            //                       ),
            //                       Expanded(
            //                         child: Text(
            //                           getTranslated(
            //                               'search_for_products', context),
            //                           style:
            //                               rubikRegular.copyWith(fontSize: 12),
            //                         ),
            //                       ),
            //                       Spacer(),
            //                       Container(
            //                         padding: const EdgeInsets.symmetric(
            //                           horizontal: 16,
            //                           vertical: 8,
            //                         ),
            //                         decoration: BoxDecoration(
            //                           color: Colors.white, // White background
            //                           borderRadius: BorderRadius.circular(
            //                               30), // Circular radius
            //                         ),
            //                         child: Text(
            //                           'Search',
            //                           style: rubikRegular.copyWith(
            //                             fontSize: 14,
            //                             color: Theme.of(context).primaryColor,
            //                           ),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  Center(
                      child: SizedBox(
                    width: Dimensions.webScreenWidth,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      ResponsiveHelper.isDesktop(context)
                          ? Padding(
                              padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                              child: Consumer<BannerProvider>(builder: (context, bannerProvider, _) {
                                return bannerProvider.bannerList == null
                                    ? const MainSliderShimmerWidget()
                                    : SizedBox(
                                        height: 380,
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          if (bannerProvider.bannerList!.isNotEmpty)
                                            SizedBox(
                                              width: bannerProvider.secondaryBannerList!.isNotEmpty ? 780 : Dimensions.webScreenWidth,
                                              child: MainSliderWidget(
                                                bannerList: bannerProvider.bannerList,
                                                bannerType: BannerType.primary,
                                                isMainOnly: bannerProvider.secondaryBannerList!.isEmpty,
                                              ),
                                            ),
                                          if (bannerProvider.secondaryBannerList!.isNotEmpty)
                                            SizedBox(
                                              width: 380,
                                              child: MainSliderWidget(
                                                bannerList: bannerProvider.secondaryBannerList,
                                                bannerType: BannerType.secondary,
                                              ),
                                            ),
                                        ]),
                                      );
                              }),
                            )
                          : const SizedBox(),

                      const CategoryWidget(),

                      /// Flash Sale
                      const FlashSaleWidget(),

                      /// Banner
                      ResponsiveHelper.isDesktop(context)
                          ? const SizedBox()
                          : Consumer<BannerProvider>(
                              builder: (context, banner, child) {
                                return banner.bannerList == null
                                    ? const BannerWidget()
                                    : banner.bannerList!.isEmpty
                                        ? const SizedBox()
                                        : const BannerWidget();
                              },
                            ),

                      /// Offer Product
                      Consumer<ProductProvider>(
                        builder: (context, offerProduct, child) {
                          return offerProduct.offerProductList == null
                              ? const SizedBox()
                              : offerProduct.offerProductList!.isEmpty
                                  ? const SizedBox()
                                  : const OfferProductWidget();
                        },
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      /// Campaign
                      if (!ResponsiveHelper.isDesktop(context))
                        Consumer<BannerProvider>(builder: (context, bannerProvider, _) {
                          return MainSliderWidget(
                            bannerType: BannerType.secondary,
                            bannerList: bannerProvider.secondaryBannerList,
                          );
                        }),

                      //Banner
                      BannerDisplayWidget(),

                      /// New Arrival
                      const NewArrivalWidget(),

                      Consumer<CategoryProvider>(builder: (context, categoryProvider, _) {
                        return categoryProvider.featureCategoryMode != null
                            ? CustomSingleChildListWidget(
                                itemCount: categoryProvider.featureCategoryMode?.featuredData?.length ?? 0,
                                itemBuilder: (index) => FeatureCategoryWidget(
                                  featuredCategory: categoryProvider.featureCategoryMode!.featuredData?[index],
                                ),
                              )
                            : const SizedBox();
                      }),

                      NewMobileBannerWidget(),
                      Consumer<ProductProvider>(builder: (context, productProvider, _) {
                        return Padding(
                          padding: ResponsiveHelper.isDesktop(context)
                              ? const EdgeInsets.only(top: Dimensions.paddingSizeExtraLarge, bottom: Dimensions.paddingSizeLarge)
                              : const EdgeInsets.fromLTRB(10, 20, 10, 10),
                          child: TitleWidget(
                            title: getTranslated('all_items', context),
                            leadingButton: ProductFilterPopupWidget(
                              isFilterActive: filterType != null,
                              onSelected: (result) {
                                filterType = result;
                                productProvider.getLatestProductList(1, filterType: result);
                              },
                            ),
                          ),
                        );
                      }),

                      ProductListWidget(scrollController: scrollController, filterType: filterType),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      if (ResponsiveHelper.isDesktop(context)) NewSingleBannerWidget(),
                    ]),
                  )),
                ],
              ),
            ),

            const FooterWebWidget(footerType: FooterType.sliver),
          ],
        ),
      ),
    );
  }
}

class _SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  _SliverDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(_SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 || oldDelegate.minExtent != 50 || child != oldDelegate.child;
  }
}

class SingleBannerWidget extends StatelessWidget {
  const SingleBannerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final double bannerWidth = isMobile
        ? MediaQuery.of(context).size.width / 2 - 20 // Adjust width for two banners on mobile
        : (MediaQuery.of(context).size.width / 2) - 30; // Adjust width for desktop spacing

    return Column(
      children: [
        Consumer<BannerProvider>(
          builder: (context, banner, child) {
            return banner.bannerList != null && banner.bannerList!.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: banner.bannerList!.take(2).map((bannerItem) {
                      return Expanded(
                        child: _buildBannerItem(
                          context,
                          bannerItem,
                          bannerWidth,
                          isMobile ? 160 : 200,
                        ),
                      );
                    }).toList(),
                  )
                : Center(
                    child: Text(
                      'No banner available',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
          },
        ),
      ],
    );
  }

  Widget _buildBannerItem(BuildContext context, bannerItem, double width, double height) {
    return InkWell(
      onTap: () => ProductHelper.onTapBannerForRoute(bannerItem, context),
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.all(5), // Adjusted spacing
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            // BoxShadow(
            //   color: Theme.of(context).shadowColor,
            //   spreadRadius: 1,
            //   blurRadius: 5,
            // ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}/${bannerItem.image}',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class BannerDisplayWidget extends StatelessWidget {
  const BannerDisplayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context)
        ? SingleBannerWidget() // Display the original widget on desktop
        : const MobileBannerWidget(); // Display mobile column layout
  }
}

class MobileBannerWidget extends StatelessWidget {
  const MobileBannerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double bannerWidth = MediaQuery.of(context).size.width - 40; // Full width with padding adjustment for mobile

    return Consumer<BannerProvider>(
      builder: (context, banner, child) {
        return banner.bannerList != null && banner.bannerList!.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: _buildBannerItem(
                      context,
                      banner.bannerList!.first, // Display only the first banner item
                      bannerWidth,
                      160, // Height for mobile banners
                    ),
                  ),
                ],
              )
            : Center(
                child: Text(
                  'No banner available',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
      },
    );
  }

  Widget _buildBannerItem(BuildContext context, bannerItem, double width, double height) {
    return InkWell(
      onTap: () => ProductHelper.onTapBannerForRoute(bannerItem, context),
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // boxShadow: [
          //   BoxShadow(
          //     color: Theme.of(context).shadowColor,
          //     spreadRadius: 1,
          //     blurRadius: 5,
          //   ),
          // ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}/${bannerItem.image}',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

/////// new widget for banner

class NewSingleBannerWidget extends StatelessWidget {
  const NewSingleBannerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final double bannerWidth = isMobile ? MediaQuery.of(context).size.width / 2 - 20 : (MediaQuery.of(context).size.width / 2) - 30;

    return Column(
      children: [
        Consumer<BannerProvider>(
          builder: (context, banner, child) {
            if (banner.bannerList != null && banner.bannerList!.length > 7) {
              final bannerItems = [
                banner.bannerList![6],
                banner.bannerList![7],
              ];

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: bannerItems.map((bannerItem) {
                  return Expanded(
                    child: _buildBannerItem(
                      context,
                      bannerItem,
                      bannerWidth,
                      isMobile ? 160 : 200,
                    ),
                  );
                }).toList(),
              );
            } else {
              return Center(
                child: Text(
                  'No banner available',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildBannerItem(BuildContext context, bannerItem, double width, double height) {
    return InkWell(
      onTap: () => ProductHelper.onTapBannerForRoute(bannerItem, context),
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // boxShadow: [
          //   BoxShadow(
          //     color: Theme.of(context).shadowColor,
          //     spreadRadius: 1,
          //     blurRadius: 5,
          //   ),
          // ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}/${bannerItem.image}',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class NewMobileBannerWidget extends StatelessWidget {
  const NewMobileBannerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double bannerWidth = MediaQuery.of(context).size.width - 40;

    return Consumer<BannerProvider>(
      builder: (context, banner, child) {
        if (banner.bannerList != null && banner.bannerList!.length > 6) {
          final bannerItem = banner.bannerList!.length > 7 ? banner.bannerList![7] : banner.bannerList![6];

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: _buildBannerItem(
                  context,
                  bannerItem,
                  bannerWidth,
                  160, // Height for mobile banners
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: Text(
              'No banner available',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }
      },
    );
  }

  Widget _buildBannerItem(BuildContext context, bannerItem, double width, double height) {
    return InkWell(
      onTap: () => ProductHelper.onTapBannerForRoute(bannerItem, context),
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // boxShadow: [
          //   BoxShadow(
          //     color: Theme.of(context).shadowColor,
          //     spreadRadius: 1,
          //     blurRadius: 5,
          //   ),
          // ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}/${bannerItem.image}',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
