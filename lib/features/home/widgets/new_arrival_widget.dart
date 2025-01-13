import 'package:klixstore/helper/responsive_helper.dart';
import 'package:klixstore/localization/language_constrants.dart';
import 'package:klixstore/provider/localization_provider.dart';
import 'package:klixstore/features/product/providers/product_provider.dart';
import 'package:klixstore/common/enums/search_short_by_enum.dart';
import 'package:klixstore/utill/dimensions.dart';
import 'package:klixstore/utill/routes.dart';
import 'package:klixstore/common/widgets/custom_slider_list_widget.dart';
import 'package:klixstore/common/widgets/product_card_widget.dart';
import 'package:klixstore/common/widgets/product_shimmer_widget.dart';
import 'package:klixstore/common/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewArrivalWidget extends StatefulWidget {
  const NewArrivalWidget({Key? key}) : super(key: key);

  @override
  State<NewArrivalWidget> createState() => _NewArrivalWidgetState();
}

class _NewArrivalWidgetState extends State<NewArrivalWidget> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    // Initialize the scroll controller
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    // Dispose the scroll controller to avoid memory leaks
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLtr =
        Provider.of<LocalizationProvider>(context, listen: false).isLtr;

    return Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
      return productProvider.newArrivalProductsModel?.products != null &&
              productProvider.newArrivalProductsModel!.products!.isNotEmpty
          ? Container(
              margin: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(Dimensions.paddingSizeDefault),
                color: Theme.of(context).focusColor.withOpacity(0.15),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0, // Dimensions.paddingSizeDefault,
                  vertical: Dimensions.paddingSizeSmall,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeDefault,
                      ),
                      child: TitleWidget(
                          title: getTranslated('new_arrival', context),
                          onTap: () {
                            Navigator.pushNamed(
                                context,
                                Routes.getSearchResultRoute(
                                    shortBy: SearchShortBy.newArrivals));
                          }),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    SizedBox(
                      height: 170,
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        controller: scrollController,
                        itemCount: productProvider
                            .newArrivalProductsModel!.products!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) {
                          var product = productProvider
                              .newArrivalProductsModel!.products![index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeExtraSmall),
                            width: 360,
                            height: 170,
                            child: ProductCardWidget(
                              newarrival: true,
                              product: product,
                              direction: Axis.horizontal,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                  ],
                ),
              ),
            )
          : const SizedBox();
    });
  }
}
