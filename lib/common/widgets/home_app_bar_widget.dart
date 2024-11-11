// ignore_for_file: prefer_const_constructors

import 'package:klixstore/common/widgets/cart_count_widget.dart';
import 'package:klixstore/common/widgets/custom_asset_image_widget.dart';
import 'package:klixstore/common/widgets/custom_text_field_widget.dart';
import 'package:klixstore/common/widgets/web_app_bar_widget.dart';
import 'package:klixstore/features/cart/providers/cart_provider.dart';
import 'package:klixstore/features/category/providers/category_provider.dart';
import 'package:klixstore/features/search/providers/search_provider.dart';
import 'package:klixstore/features/splash/providers/splash_provider.dart';
import 'package:klixstore/helper/cart_helper.dart';
import 'package:klixstore/helper/responsive_helper.dart';
import 'package:klixstore/utill/app_constants.dart';
import 'package:klixstore/utill/images.dart';
import 'package:klixstore/utill/routes.dart';
import 'package:klixstore/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../localization/language_constrants.dart';
import '../../utill/dimensions.dart';

class HomeAppBarWidget extends StatelessWidget {
  const HomeAppBarWidget({
    Key? key,
    required this.drawerGlobalKey,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> drawerGlobalKey;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      elevation: 2,
      centerTitle: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.indigo.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      pinned: ResponsiveHelper.isTab(context),
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: Image.asset(
            Images.logo,
            height: 30,
          ),
        ),

        SizedBox(
          width: 2,
        ),
        Flexible(child: SearchMobileWidget()),

        const SizedBox(width: 15),

        // Coupon icon with subtle shadow
        InkWell(
          borderRadius: BorderRadius.circular(50),
          hoverColor: Colors.transparent,
          onTap: () => Navigator.pushNamed(context, Routes.getCouponRoute()),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(Images.coupon, height: 16, width: 16),
          ),
        ),
        const SizedBox(width: 15),

        // Notification icon
        IconButton(
          onPressed: () =>
              Navigator.pushNamed(context, Routes.getNotificationRoute()),
          icon: Icon(Icons.notifications, color: Colors.white, size: 28),
        ),

        // Cart icon with badge
        if (ResponsiveHelper.isTab(context))
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, Routes.getDashboardRoute('cart')),
            icon: Consumer<CartProvider>(
              builder: (context, cartProvider, _) => CartCountWidget(
                count: CartHelper.getCartItemCount(cartProvider.cartList),
                icon: Icons.shopping_cart,
              ),
            ),
          ),
      ],
    );
  }
}

class SearchMobileWidget extends StatefulWidget {
  @override
  _SearchMobileWidgetState createState() => _SearchMobileWidgetState();
}

class _SearchMobileWidgetState extends State<SearchMobileWidget> {
  int _currentCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryList(false);
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final categoryList = categoryProvider.categoryList;

    final searchProvider = Provider.of<SearchProvider>(context);

    String categoryName = categoryList != null && categoryList.isNotEmpty
        ? categoryList[_currentCategoryIndex].name ?? 'No Category'
        : 'Search';

    if (categoryList != null && categoryList.isNotEmpty) {
      Future.delayed(Duration(seconds: 8), () {
        setState(() {
          _currentCategoryIndex =
              (_currentCategoryIndex + 1) % categoryList.length;
        });
      });
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.07),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: CustomTextFieldWidget(
          hintText: categoryName,
          hintFontSize: 16,
          fillColor: Colors.transparent,
          style: TextStyle(fontSize: 14),
          isShowSuffixIcon: true,
          suffixIconUrl: Images.search,
          onChanged: (str) {
            str.length = 0;
            searchProvider.getSearchText(str);
          },
          onSuffixTap: () {
            if (searchProvider.searchController.text.isNotEmpty &&
                searchProvider.isSearch == true) {
              Provider.of<SearchProvider>(context, listen: false)
                  .saveSearchAddress(searchProvider.searchController.text);
              Navigator.pushNamed(
                  context,
                  Routes.getSearchResultRoute(
                      text: searchProvider.searchController.text));

              searchProvider.changeSearchStatus();
            } else if (searchProvider.searchController.text.isNotEmpty &&
                searchProvider.isSearch == false) {
              searchProvider.searchController.clear();
              searchProvider.getSearchText('');

              searchProvider.changeSearchStatus();
            }
          },
          controller: searchProvider.searchController,
          inputAction: TextInputAction.search,
          onSubmit: (text) {
            if (text.isNotEmpty) {
              searchProvider.saveSearchAddress(text);
              Navigator.pushNamed(
                  context, Routes.getSearchResultRoute(text: text));
              searchProvider.changeSearchStatus();
            }
          },
        ),
      ),
    );
  }
}
