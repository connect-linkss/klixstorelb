import 'package:klixstore/localization/language_constrants.dart';
import 'package:klixstore/provider/language_provider.dart';
import 'package:klixstore/utill/dimensions.dart';
import 'package:klixstore/utill/images.dart';
import 'package:klixstore/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchLanguageWidget extends StatelessWidget {
  const SearchLanguageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, searchProvider, child) => TextField(
        cursorColor: Theme.of(context).primaryColor,
        onChanged: (String query) {
          searchProvider.searchLanguage(query, context);
        },
        style: rubikMedium.copyWith(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontSize: Dimensions.fontSizeLarge),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
            borderSide: const BorderSide(style: BorderStyle.none, width: 0),
          ),
          isDense: true,
          hintText: getTranslated('find_language', context),
          fillColor: Theme.of(context).cardColor,
          hintStyle: rubikMedium.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).hintColor),
          filled: true,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(
                left: Dimensions.paddingSizeLarge,
                right: Dimensions.paddingSizeSmall),
            child: Image.asset(Images.search,
                width: 15,
                height: 15,
                color: Theme.of(context).textTheme.bodyLarge!.color),
          ),
        ),
      ),
    );
  }
}
