import 'package:flutter/material.dart';

import 'constant_colors.dart';

const TextStyle kNotesDefaultTextStyle = TextStyle(
  color: kTextColor,
  fontFamily: 'Quicksand',
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

const TextStyle kNotesDefaultHeadingStyle = TextStyle(
  color: kTextColor,
  fontSize: 24,
  fontFamily: 'Quicksand',
  fontWeight: FontWeight.w500,
);

const pi = 3.1415926535897932;
const InputBorder kNoInputBorder = InputBorder.none;

const String kNoSearchResultsFound =
    'assets/images/no_search_results_found.svg';
const String kSearchMemoLottie = 'assets/lottie/search_notes.json';
const String kSplashScreenLottie = 'assets/lottie/notes_animation.json';
const String kEmptyMemoLottie = 'assets/lottie/empty_notes.json';
const String kArrowDownLottie = 'assets/lottie/arrow_down.json';

const String kDeleteConfirmationText =
    'Are you sure you want to delete this memo ?';
const String kNoSearchResultsFoundText = 'No search results found ...';
const String kStartSearchingText =
    'Start searching by typing in\nthe above textfield ...';

const String kSearchResultKey = 'search_results';
const String kNoResultsFoundKey = 'no_results_found';
const String kStartSearchKey = 'start_search';
