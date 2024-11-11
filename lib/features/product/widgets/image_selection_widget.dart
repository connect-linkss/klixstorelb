import 'package:klixstore/common/models/product_model.dart';
import 'package:klixstore/helper/responsive_helper.dart';
import 'package:klixstore/features/cart/providers/cart_provider.dart';
import 'package:klixstore/features/product/providers/product_provider.dart';
import 'package:klixstore/features/splash/providers/splash_provider.dart';
import 'package:klixstore/utill/dimensions.dart';
import 'package:klixstore/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageSelectionWidget extends StatelessWidget {
  final Product? productModel;
  const ImageSelectionWidget({Key? key, required this.productModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
      return Consumer<CartProvider>(builder: (context, cartProvider, child) {
        return ResponsiveHelper.isDesktop(context)
            ? SizedBox(
                height: 300,
                child: productProvider.product!.image != null
                    ? ListView.builder(
                        itemCount: productProvider.product!.image!.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: Dimensions.paddingSizeSmall),
                            child: InkWell(
                              onTap: () {
                                cartProvider.setSelect(index);
                              },
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: index == cartProvider.productSelect
                                      ? LinearGradient(
                                          colors: [
                                            Theme.of(context).primaryColor,
                                            Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.3),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : null,
                                ),
                                padding: EdgeInsets.all(
                                    ResponsiveHelper.isDesktop(context)
                                        ? 3
                                        : 5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CustomImageWidget(
                                    image:
                                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${productProvider.product!.image![index]}',
                                    fit: BoxFit
                                        .cover, // Make image cover the area
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                    : const SizedBox(),
              )
            : SizedBox(
                height: 60,
                child: productProvider.product!.image != null
                    ? ListView.builder(
                        itemCount: productProvider.product!.image!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                right: Dimensions.paddingSizeSmall),
                            child: InkWell(
                              onTap: () {
                                cartProvider.setSelect(index);
                              },
                              child: Container(
                                width: 60,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: index == cartProvider.productSelect
                                      ? LinearGradient(
                                          colors: [
                                            Theme.of(context).primaryColor,
                                            Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.3),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : null,
                                ),
                                padding: EdgeInsets.all(
                                    ResponsiveHelper.isDesktop(context)
                                        ? 3
                                        : 5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CustomImageWidget(
                                    image:
                                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${productProvider.product!.image![index]}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                    : const SizedBox(),
              );
      });
    });
  }
}
