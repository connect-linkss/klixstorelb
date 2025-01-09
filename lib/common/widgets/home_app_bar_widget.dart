// ignore_for_file: prefer_const_constructors

import 'package:klixstore/common/widgets/cart_count_widget.dart';
import 'package:klixstore/common/widgets/custom_text_field_widget.dart';
import 'package:klixstore/features/cart/providers/cart_provider.dart';
import 'package:klixstore/features/category/providers/category_provider.dart';
import 'package:klixstore/features/search/providers/search_provider.dart';
import 'package:klixstore/helper/cart_helper.dart';
import 'package:klixstore/helper/responsive_helper.dart';
import 'package:klixstore/utill/images.dart';
import 'package:klixstore/utill/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            height: 50,
          ),
        ),

        SizedBox(
          width: 2,
        ),

        Flexible(child: SearchMobileWidget()),

        const SizedBox(width: 15),

        InkWell(
          borderRadius: BorderRadius.circular(50),
          hoverColor: Colors.transparent,
          onTap: () => Navigator.pushNamed(context, Routes.getCouponRoute()),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 4)
              ],
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
  const SearchMobileWidget({Key? key}) : super(key: key);

  @override
  SearchMobileWidgetState createState() => SearchMobileWidgetState();
}

class SearchMobileWidgetState extends State<SearchMobileWidget> {
  int _currentCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _startCategoryRotation();
  }

  void _startCategoryRotation() {
    Future.delayed(Duration(seconds: 8), () {
      if (mounted) {
        setState(() {
          _currentCategoryIndex = (_currentCategoryIndex + 1) %
              Provider.of<CategoryProvider>(context, listen: false)
                  .categoryList!
                  .length;
        });
        _startCategoryRotation(); // Schedule the next rotation
      }
    });
  }

  @override
  void dispose() {
    // Clean up if needed, although the `mounted` check ensures safety.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final categoryList = categoryProvider.categoryList;

    String categoryName = categoryList != null && categoryList.isNotEmpty
        ? categoryList[_currentCategoryIndex].name ?? 'No Category'
        : 'Search';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.07),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
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
          Provider.of<SearchProvider>(context, listen: false)
              .getSearchText(str);
        },
        onSuffixTap: () {
          final searchProvider =
              Provider.of<SearchProvider>(context, listen: false);
          if (searchProvider.searchController.text.isNotEmpty &&
              searchProvider.isSearch == true) {
            searchProvider
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
        controller: Provider.of<SearchProvider>(context).searchController,
        inputAction: TextInputAction.search,
        onSubmit: (text) {
          if (text.isNotEmpty) {
            final searchProvider =
                Provider.of<SearchProvider>(context, listen: false);
            searchProvider.saveSearchAddress(text);
            Navigator.pushNamed(
                context, Routes.getSearchResultRoute(text: text));
            searchProvider.changeSearchStatus();
          }
        },
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      ),
    );
  }
}
