// ignore_for_file: prefer_const_constructors

import 'package:klixstore/common/widgets/wish_button_widget.dart';
import 'package:klixstore/features/cart/widgets/cart_bottom_sheet_widget.dart';
import 'package:klixstore/helper/product_helper.dart';
import 'package:klixstore/helper/responsive_helper.dart';
import 'package:klixstore/features/coupon/providers/coupon_provider.dart';
import 'package:klixstore/common/widgets/custom_directionality_widget.dart';
import 'package:klixstore/common/widgets/custom_image_widget.dart';
import 'package:klixstore/helper/custom_snackbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klixstore/common/models/cart_model.dart';
import 'package:klixstore/helper/price_converter_helper.dart';
import 'package:klixstore/localization/language_constrants.dart';
import 'package:klixstore/features/cart/providers/cart_provider.dart';
import 'package:klixstore/features/splash/providers/splash_provider.dart';
import 'package:klixstore/utill/color_resources.dart';
import 'package:klixstore/utill/dimensions.dart';
import 'package:klixstore/utill/styles.dart';
import 'package:provider/provider.dart';

import '../../product/providers/product_provider.dart';

class CartProductWidget extends StatefulWidget {
  final CartModel? cart;
  final int cartIndex;
  const CartProductWidget(
      {Key? key, required this.cart, required this.cartIndex})
      : super(key: key);

  @override
  State<CartProductWidget> createState() => _CartProductWidgetState();
}

class _CartProductWidgetState extends State<CartProductWidget> {
  @override
  Widget build(BuildContext context) {
    String? variationText = getVariationText();

    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);

    return InkWell(
      hoverColor: Colors.transparent,
      onTap: () {
        ResponsiveHelper.isMobile(context)
            ? showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (con) => CartBottomSheetWidget(
                  product: widget.cart!.product,
                  cart: widget.cart,
                  cartIndex: widget.cartIndex,
                  callback: (CartModel cartModel) {
                    showCustomSnackBar(
                        getTranslated('added_to_cart', context), context,
                        isError: false);
                  },
                ),
              )
            : showDialog(
                context: context,
                builder: (con) => Dialog(
                      child: SizedBox(
                        width: 500,
                        child: CartBottomSheetWidget(
                          cart: widget.cart,
                          product: widget.cart!.product,
                          cartIndex: widget.cartIndex,
                          callback: (CartModel cartModel) {
                            showCustomSnackBar(
                                getTranslated('added_to_cart', context),
                                context,
                                isError: false);
                          },
                        ),
                      ),
                    ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(10)),
        child: Stack(children: [
          const Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child: Icon(Icons.delete, color: Colors.white, size: 50),
          ),
          Dismissible(
            key: UniqueKey(),
            onDismissed: (DismissDirection direction) =>
                Provider.of<CartProvider>(context, listen: false)
                    .removeFromCart(widget.cart!),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeSmall,
                  horizontal: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    blurRadius: 5,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                      crossAxisAlignment: ResponsiveHelper.isDesktop(context)
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CustomImageWidget(
                            image:
                                '${splashProvider.baseUrls?.productImageUrl}/${widget.cart?.product?.image?[0]}',
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(widget.cart!.product!.name!,
                                    style: rubikRegular,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(
                                    height: Dimensions.paddingSizeExtraSmall),
                                if (ProductHelper.getProductRatingValue(
                                        widget.cart?.product) !=
                                    null)
                                  Row(children: [
                                    Icon(Icons.star_rounded,
                                        color: ColorResources.getRatingColor(
                                            context),
                                        size: 20),
                                    const SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraSmall),
                                    Text(
                                      ProductHelper.getProductRatingValue(
                                              widget.cart?.product)!
                                          .toStringAsFixed(1),
                                      style: rubikMedium.copyWith(
                                          color: ColorResources.getGrayColor(
                                              context),
                                          fontSize: Dimensions.fontSizeDefault),
                                    ),
                                  ]),
                                const SizedBox(
                                    height: Dimensions.paddingSizeExtraSmall),
                                Row(children: [
                                  Text(
                                      '${getTranslated('unit_price', context)}: ',
                                      style: rubikRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall)),
                                  widget.cart!.discountAmount! > 0
                                      ? Flexible(
                                          child: CustomDirectionalityWidget(
                                            child: Text(
                                                PriceConverterHelper
                                                    .convertPrice(widget.cart!
                                                            .discountedPrice! +
                                                        widget.cart!
                                                            .discountAmount!),
                                                style: rubikRegular.copyWith(
                                                  color:
                                                      ColorResources.colorGrey,
                                                  fontSize: Dimensions
                                                      .fontSizeExtraSmall,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                                maxLines: 1),
                                          ),
                                        )
                                      : const SizedBox(),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  CustomDirectionalityWidget(
                                      child: Text(
                                    PriceConverterHelper.convertPrice(
                                        widget.cart!.discountedPrice),
                                    style: rubikBold,
                                  )),
                                ]),
                                if (!ResponsiveHelper.isDesktop(context))
                                  const SizedBox(
                                      height: Dimensions.paddingSizeExtraSmall),
                                if (!ResponsiveHelper.isDesktop(context))
                                  Row(children: [
                                    Text(
                                        '${getTranslated('Total Price', context)}: ',
                                        style: rubikRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeSmall)),
                                    widget.cart!.discountAmount! > 0
                                        ? CustomDirectionalityWidget(
                                            child: Text(
                                                PriceConverterHelper.convertPrice((widget
                                                            .cart
                                                            ?.discountedPrice ??
                                                        0) +
                                                    (widget.cart?.discountAmount ??
                                                            0) *
                                                        (widget.cart
                                                                ?.quantity ??
                                                            1)),
                                                style: rubikRegular.copyWith(
                                                  color:
                                                      ColorResources.colorGrey,
                                                  fontSize: Dimensions
                                                      .fontSizeExtraSmall,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                )),
                                          )
                                        : const SizedBox(),
                                    const SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraSmall),
                                    CustomDirectionalityWidget(
                                        child: Text(
                                      PriceConverterHelper.convertPrice(
                                          (widget.cart?.discountedPrice ?? 0) *
                                              (widget.cart?.quantity ?? 1)),
                                      style: rubikBold,
                                    )),
                                  ]),
                                widget.cart?.product?.variations != null &&
                                        widget.cart!.product!.variations!
                                            .isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: Dimensions
                                                .paddingSizeExtraSmall),
                                        child: Row(children: [
                                          Text(
                                              '${getTranslated('variation', context)}: ',
                                              style: rubikRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeSmall)),
                                          Expanded(
                                            child: Text(
                                              variationText!,
                                              overflow: TextOverflow.ellipsis,
                                              style: rubikRegular.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeSmall,
                                                  color: Theme.of(context)
                                                      .disabledColor),
                                            ),
                                          ),
                                        ]),
                                      )
                                    : const SizedBox(),
                              ]),
                        ),
                        SizedBox(
                            width: ResponsiveHelper.isMobile(context) ? 0 : 30),
                        if (ResponsiveHelper.isDesktop(context))
                          Row(children: [
                            Text('${getTranslated('Total Price', context)}: ',
                                style: rubikRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall)),
                            widget.cart!.discountAmount! > 0
                                ? CustomDirectionalityWidget(
                                    child: Text(
                                        PriceConverterHelper.convertPrice(
                                            ((widget.cart?.discountedPrice ??
                                                    0) +
                                                (widget.cart?.discountAmount ??
                                                        0) *
                                                    (widget.cart?.quantity ??
                                                        1))),
                                        style: rubikRegular.copyWith(
                                          color: ColorResources.colorGrey,
                                          fontSize:
                                              Dimensions.fontSizeExtraSmall,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        )),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                                width: Dimensions.paddingSizeExtraSmall),
                            CustomDirectionalityWidget(
                                child: Text(
                              PriceConverterHelper.convertPrice(
                                  (widget.cart?.discountedPrice ?? 0) *
                                      (widget.cart?.quantity ?? 1)),
                              style: rubikBold,
                            )),
                          ]),
                        SizedBox(
                            width: ResponsiveHelper.isMobile(context) ? 0 : 30),
                        RotatedBox(
                          quarterTurns:
                              ResponsiveHelper.isDesktop(context) ? 0 : 5,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.5)),
                            ),
                            child: ResponsiveHelper.isDesktop(context)
                                ? Column(
                                    children: [
                                      // Add button
                                      Container(
                                        width: 30, // Reduced width
                                        height: 30, // Reduced height
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.5),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                          ),
                                        ),
                                        child: InkWell(
                                          onTap: () =>
                                              Provider.of<CartProvider>(context,
                                                      listen: false)
                                                  .setQuantity(
                                                      true,
                                                      widget.cart,
                                                      widget.cart!.stock,
                                                      context,
                                                      false,
                                                      null),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .paddingSizeExtraSmall,
                                                vertical: Dimensions
                                                    .paddingSizeExtraSmall),
                                            child: Icon(Icons.add,
                                                size: 18), // Smaller icon size
                                          ),
                                        ),
                                      ),
                                      // Quantity text
                                      RotatedBox(
                                        quarterTurns: 0,
                                        child: Text(
                                            widget.cart!.quantity.toString(),
                                            style: rubikMedium.copyWith(
                                                fontSize: Dimensions
                                                    .fontSizeLarge)), // Reduced font size
                                      ),
                                      // Remove button when quantity is 1
                                      (widget.cart!.quantity == 1)
                                          ? SizedBox(
                                              width: 30, // Reduced width
                                              height: 30, // Reduced height
                                              child: RotatedBox(
                                                quarterTurns: 0,
                                                child: IconButton(
                                                  onPressed: () {
                                                    Provider.of<CartProvider>(
                                                            context,
                                                            listen: false)
                                                        .removeFromCart(
                                                            widget.cart!);
                                                  },
                                                  icon: const Icon(
                                                      CupertinoIcons.delete,
                                                      color: Colors.red,
                                                      size:
                                                          18), // Smaller icon size
                                                ),
                                              ),
                                            )
                                          : Container(
                                              width: 30, // Reduced width
                                              height: 30, // Reduced height
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.5),
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(5),
                                                  bottomRight:
                                                      Radius.circular(5),
                                                ),
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  if (widget.cart!.quantity! >
                                                      1) {
                                                    Provider.of<CartProvider>(
                                                            context,
                                                            listen: false)
                                                        .setQuantity(
                                                            false,
                                                            widget.cart,
                                                            widget.cart!.stock,
                                                            context,
                                                            false,
                                                            null);
                                                  } else if (widget
                                                          .cart!.quantity ==
                                                      1) {
                                                    Provider.of<CartProvider>(
                                                            context,
                                                            listen: false)
                                                        .removeFromCart(
                                                            widget.cart!);
                                                  }
                                                },
                                                child: RotatedBox(
                                                  quarterTurns: 0,
                                                  child: const Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: Dimensions
                                                            .paddingSizeExtraSmall,
                                                        vertical: Dimensions
                                                            .paddingSizeExtraSmall),
                                                    child: Icon(Icons.remove,
                                                        size:
                                                            18), // Smaller icon size
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      // Add button
                                      Container(
                                        width: 30, // Reduced width
                                        height: 30, // Reduced height
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.5),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(5),
                                            topLeft: Radius.circular(5),
                                          ),
                                        ),
                                        child: InkWell(
                                          onTap: () =>
                                              Provider.of<CartProvider>(context,
                                                      listen: false)
                                                  .setQuantity(
                                                      true,
                                                      widget.cart,
                                                      widget.cart!.stock,
                                                      context,
                                                      false,
                                                      null),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .paddingSizeExtraSmall,
                                                vertical: Dimensions
                                                    .paddingSizeExtraSmall),
                                            child: Icon(Icons.add,
                                                size: 18), // Smaller icon size
                                          ),
                                        ),
                                      ),
                                      // Quantity text
                                      RotatedBox(
                                        quarterTurns: 3,
                                        child: Text(
                                            widget.cart!.quantity.toString(),
                                            style: rubikMedium.copyWith(
                                                fontSize: Dimensions
                                                    .fontSizeLarge)), // Reduced font size
                                      ),
                                      // Remove button when quantity is 1
                                      (widget.cart!.quantity == 1)
                                          ? SizedBox(
                                              width: 30, // Reduced width
                                              height: 30, // Reduced height
                                              child: RotatedBox(
                                                quarterTurns: 3,
                                                child: IconButton(
                                                  onPressed: () {
                                                    Provider.of<CartProvider>(
                                                            context,
                                                            listen: false)
                                                        .removeFromCart(
                                                            widget.cart!);
                                                  },
                                                  icon: const Icon(
                                                      CupertinoIcons.delete,
                                                      color: Colors.red,
                                                      size:
                                                          18), // Smaller icon size
                                                ),
                                              ),
                                            )
                                          : Container(
                                              width: 30, // Reduced width
                                              height: 30, // Reduced height
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.5),
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                ),
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  if (widget.cart!.quantity! >
                                                      1) {
                                                    Provider.of<CartProvider>(
                                                            context,
                                                            listen: false)
                                                        .setQuantity(
                                                            false,
                                                            widget.cart,
                                                            widget.cart!.stock,
                                                            context,
                                                            false,
                                                            null);
                                                  } else if (widget
                                                          .cart!.quantity ==
                                                      1) {
                                                    Provider.of<CartProvider>(
                                                            context,
                                                            listen: false)
                                                        .removeFromCart(
                                                            widget.cart!);
                                                  }
                                                },
                                                child: RotatedBox(
                                                  quarterTurns: 3,
                                                  child: const Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: Dimensions
                                                            .paddingSizeExtraSmall,
                                                        vertical: Dimensions
                                                            .paddingSizeExtraSmall),
                                                    child: Icon(Icons.remove,
                                                        size:
                                                            18), // Smaller icon size
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                          ),
                        )
                      ]),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  String? getVariationText() {
    String? variationText = '';
    if (widget.cart?.variation != null &&
        widget.cart!.variation!.isNotEmpty &&
        widget.cart!.variation!.first.type != null) {
      List<String> variationTypes =
          widget.cart!.variation!.first.type!.split('-');
      if (variationTypes.length ==
          widget.cart!.product!.choiceOptions!.length) {
        int index = 0;
        for (var choice in widget.cart!.product!.choiceOptions!) {
          variationText =
              '${variationText!}${(index == 0) ? '' : ',  '}${choice.title} - ${variationTypes[index]}';
          index = index + 1;
        }
      } else {
        variationText = widget.cart!.product!.variations![0].type;
      }
    }
    return variationText;
  }
}
