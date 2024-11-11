import 'package:klixstore/common/models/product_details_model.dart';
import 'package:klixstore/helper/responsive_helper.dart';
import 'package:klixstore/localization/language_constrants.dart';
import 'package:klixstore/utill/dimensions.dart';
import 'package:klixstore/utill/styles.dart';
import 'package:klixstore/common/widgets/custom_single_child_list_widget.dart';
import 'package:klixstore/common/widgets/product_card_widget.dart';
import 'package:flutter/material.dart';

class RelatedProductWidget extends StatelessWidget {
  final ProductDetailsModel? productDetailsModel;
  const RelatedProductWidget({Key? key, this.productDetailsModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return productDetailsModel != null &&
            productDetailsModel?.relatedProducts != null &&
            productDetailsModel!.relatedProducts!.isNotEmpty
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(getTranslated('similar_items_you_might_also_like', context),
                style: rubikMedium.copyWith(
                    fontSize: ResponsiveHelper.isDesktop(context)
                        ? Dimensions.fontSizeLarge
                        : Dimensions.fontSizeDefault)),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeDefault),
              width: Dimensions.webScreenWidth,
              color: Theme.of(context).canvasColor,
              child: CustomSingleChildListWidget(
                crossAxisAlignment: CrossAxisAlignment.start,
                scrollDirection: Axis.horizontal,
                itemCount: productDetailsModel?.relatedProducts?.length ?? 0,
                itemBuilder: (index) => Container(
                  width: 190,
                  margin: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraSmall),
                  child: ProductCardWidget(
                      product: productDetailsModel!.relatedProducts![index]),
                ),
              ),
            )
          ])
        : const SizedBox();
  }
}
