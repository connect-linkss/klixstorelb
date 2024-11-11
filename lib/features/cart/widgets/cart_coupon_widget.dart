import 'package:dotted_border/dotted_border.dart';
import 'package:klixstore/localization/language_constrants.dart';
import 'package:klixstore/features/coupon/providers/coupon_provider.dart';
import 'package:klixstore/provider/localization_provider.dart';
import 'package:klixstore/features/splash/providers/splash_provider.dart';
import 'package:klixstore/utill/dimensions.dart';
import 'package:klixstore/utill/images.dart';
import 'package:klixstore/utill/styles.dart';
import 'package:klixstore/common/widgets/custom_asset_image_widget.dart';
import 'package:klixstore/helper/custom_snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartCouponWidget extends StatelessWidget {
  final TextEditingController couponTextController;
  final double totalAmount;

  const CartCouponWidget({
    Key? key,
    required this.couponTextController,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Consumer<CouponProvider>(
        builder: (context, coupon, child) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: 150, // Increase width for longer button
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 2),
                      ),
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min, // Minimize the space used
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.local_offer,
                                color: Theme.of(context).primaryColor,
                                size: 30),
                          ),
                          Expanded(
                            child: TextField(
                              controller: couponTextController,
                              style: rubikRegular.copyWith(fontSize: 16),
                              decoration: InputDecoration(
                                hintText:
                                    getTranslated('apply_coupon', context),
                                hintStyle: rubikRegular.copyWith(
                                    color: Theme.of(context).hintColor),
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Apply Button outside the container but in the same row
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 60,
                    height: 40,
                    child: InkWell(
                      onTap: () {
                        if (couponTextController.text.isNotEmpty &&
                            !coupon.isLoading) {
                          coupon
                              .applyCoupon(
                                  couponTextController.text, totalAmount)
                              .then((discount) {
                            if (discount! > 0) {
                              showCustomSnackBar(
                                '${getTranslated('you_got', context)} $discount ${getTranslated('discount', context)}',
                                context,
                                isError: false,
                              );
                            } else {
                              showCustomSnackBar(
                                  getTranslated('invalid_code_or', context),
                                  context);
                            }
                          });
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: coupon.discount! <= 0
                            ? !coupon.isLoading
                                ? Text(
                                    getTranslated('apply', context),
                                    style: rubikMedium.copyWith(
                                        color: Colors.white, fontSize: 16),
                                  )
                                : const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white))
                            : const Icon(Icons.clear, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
