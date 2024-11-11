import 'package:flutter/material.dart';
import 'package:klixstore/common/models/language_model.dart';
import 'package:klixstore/utill/app_constants.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext? context}) {
    return AppConstants.languages;
  }
}
