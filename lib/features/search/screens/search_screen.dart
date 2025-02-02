import 'package:klixstore/common/widgets/custom_app_bar_widget.dart';
import 'package:klixstore/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:klixstore/helper/responsive_helper.dart';
import 'package:klixstore/localization/language_constrants.dart';
import 'package:klixstore/features/search/providers/search_provider.dart';
import 'package:klixstore/utill/dimensions.dart';
import 'package:klixstore/utill/images.dart';
import 'package:klixstore/utill/routes.dart';
import 'package:klixstore/common/widgets/custom_text_field_widget.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Provider.of<SearchProvider>(context, listen: false).getHistoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const CustomAppBarWidget()
          : null,
      body: SafeArea(
          child: Center(
              child: SizedBox(
        width: Dimensions.webScreenWidth,
        child: Consumer<SearchProvider>(
          builder: (context, searchProvider, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .color!
                            .withOpacity(0.05),
                        offset: const Offset(0, 2),
                        blurRadius: 30,
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeLarge),
                  child: Column(children: [
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    Row(children: [
                      Expanded(
                          child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.2),
                              width: 1),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: CustomTextFieldWidget(
                            fillColor: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.04),
                            hintText:
                                getTranslated('search_for_products', context),
                            hintFontSize: Dimensions.fontSizeDefault,
                            isShowPrefixIcon: true,
                            prefixColor: Theme.of(context).primaryColor,
                            prefixIconUrl: Images.search,
                            onSuffixTap: () {
                              if (_searchController.text.isNotEmpty) {
                                searchProvider
                                    .saveSearchAddress(_searchController.text);
                                Navigator.pushNamed(
                                    context,
                                    Routes.getSearchResultRoute(
                                        text: _searchController.text));
                              }
                            },
                            controller: _searchController,
                            inputAction: TextInputAction.search,
                            isIcon: true,
                            onSubmit: (text) {
                              if (_searchController.text.isNotEmpty) {
                                searchProvider
                                    .saveSearchAddress(_searchController.text);
                                Navigator.pushNamed(
                                    context,
                                    Routes.getSearchResultRoute(
                                        text: _searchController.text));
                              }
                            },
                          ),
                        ),
                      )),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).disabledColor,
                          size: 25,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 10),
                  ]),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              if (searchProvider.historyList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeLarge),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTranslated('recent_search', context),
                        style: rubikMedium,
                      ),
                      searchProvider.historyList.isNotEmpty
                          ? TextButton(
                              onPressed: searchProvider.clearSearchAddress,
                              child: Text(
                                getTranslated('remove_all', context),
                                style: rubikRegular.copyWith(
                                    color: Theme.of(context).colorScheme.error),
                              ))
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),

              // for recent search list section
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeLarge),
                child: ListView.builder(
                  itemCount: searchProvider.historyList.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context,
                          Routes.getSearchResultRoute(
                              text: searchProvider.historyList[index]));
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.history,
                                  size: 20, color: Theme.of(context).hintColor),
                              const SizedBox(width: 13),
                              Text(
                                searchProvider.historyList[index],
                                style: rubikMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall),
                              )
                            ],
                          ),
                          Transform.rotate(
                              angle: 45,
                              child: Icon(Icons.arrow_upward,
                                  size: 20,
                                  color: Theme.of(context).hintColor)),
                        ],
                      ),
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      ))),
    );
  }
}
