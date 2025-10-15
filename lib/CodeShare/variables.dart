import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

// Dark Modes on left side
class AppColors {
  static Color get primaryColor => isDarkMode ? Colors.brown[700]! : Colors.black;
  static Color get appBackgroundColor => isDarkMode ? Color(0xFFF7E8C4) : Colors.black;
  static Color get appBarColor => isDarkMode ? Colors.brown[800]! : Colors.deepOrangeAccent;
  static Color get panelColor => isDarkMode ? Colors.brown[800]!.withValues(alpha: 0.9) : Colors.deepOrangeAccent;
  static Color get textFieldColor => isDarkMode ? Colors.grey[900]!.withValues(alpha: 0.9) : Colors.white;
  static Color get textFieldColor2 => isDarkMode ? Colors.grey[900]! : Colors.white;
  static Color get textColorPrimary => isDarkMode ? Colors.white : Colors.black;
  static Color get textColorPrimary2 => isDarkMode ? Colors.white : Colors.grey;
  static Color get textColorSecondary => isDarkMode ? Colors.black : Colors.white;
  static Color get textColorEditToolDetails => isDarkMode ? Colors.white : Colors.blue;
  static Color get tabIconColor => isDarkMode ? Colors.grey[200]! : Colors.grey[800]!;
  static Color get tabIconColor2 => isDarkMode ? Colors.brown[300]!  : Colors.grey[800]!;
  static Color get borderPrimary => isDarkMode ? Colors.grey[900]! : Colors.black;


  static Color get buttonStyle1 => Colors.green;
  static Color get cancelButton => isDarkMode ? Colors.white : Colors.grey;
  static Color get logoImageOverlay => Colors.black.withValues(alpha: 0.6);
  static Color get settingsTabs => Colors.white.withValues(alpha: 0.1);
  static bool isDarkMode = true; // This will be toggled based on SharedPreferences
  static bool enableBackgroundImage = false; // Default to background image disabled
}

class AppData {
  static double textScale = 1;


  // Standardized Spacing & Max Constraints to be phased out

  // Screen Size & Orientation
  static Size _screenSize = Size.zero;
  static EdgeInsets _safePadding = EdgeInsets.zero;

  static void updateScreenData(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _safePadding = MediaQuery.of(context).padding;
  }

  // **Device Properties**
  static double get screenWidth => _screenSize.width;
  static double get screenHeight => _screenSize.height;
  static double get safeHeight => screenHeight - _safePadding.top - _safePadding.bottom;
  static bool get isLandscape => _screenSize.aspectRatio > 1;

// **Dynamic AppBar & TabBar Heights**
  static double get appBarHeight => 56 * scalingFactorAppBar;
  static double get tabBarHeight {
    double minHeight = 56;
    double maxHeight = 90;
    double textPadding = tabBarTextSize * 0.6; // Extra space for text positioning
    double computedHeight = (tabBarTextSize + tabBarIconSize + textPadding + 18); // Added extra buffer

    return computedHeight.clamp(minHeight, maxHeight).ceilToDouble(); // Round up to prevent fractional pixel issues
  }


  // **Dynamic Scaling Factor Based on Screen Width and Height**
  static double get tabBarScalingFactor => (screenWidth / 400).clamp(1.0, 1.3);
  static double get scalingFactorAppBar => (screenWidth / 400).clamp(1.0, 1.3);
  static double get _scalingFactorPadding => (screenWidth / 400).clamp(0.9, 1.5);
  static double get _scalingFactorSizedBox => (screenWidth / 400).clamp(0.9, 2);
  static double get _heightScalingFactor => (screenHeight / 800).clamp(0.9, 1.5);
  static double get _textScalingFactor => (screenWidth / 400).clamp(0.95, 1.75); // Normalized to 400 dp width
  static double get tabletScalingFactor => (screenWidth / 400).clamp(0.95, 1.75); // Normalized to 400 dp width

  static double get _toolsIconTextScalingFactor => (screenWidth / 400).clamp(1, 1.6); // Try not to go below 1.2 for iPads

  static double get _textOrientationFactor => isLandscape ? 0.9 : 1.0;
  static double get checkboxScalingFactor => (screenWidth / 400).clamp(0.9, 1.2);

  // **User Text Scaling**
  static double get _userScalingFactor => AppData.textScale; // Normalized to 400 dp width
  static double get minTextFactor => 0.8; // Normalized to 400 dp width
  static double get maxTextFactor => 1.3; // Normalized to 400 dp width


  // **Dynamic Widths (Orientation+ScreenSize-Dependent)**
  static double get inputFieldWidth => isLandscape ? (screenWidth * 0.50) : (double.infinity);
  static double get buttonWidth => isLandscape ? (screenWidth * 0.2) : (screenWidth * 0.4);
  static double get termsAndConditionsWidth => isLandscape ? (screenWidth * 0.35) : (screenWidth * 1);
  static double get selectionDialogWidth => isLandscape ? (screenWidth * 0.5) : (screenWidth * 0.8);
  static double get miniSelectionDialogWidth => isLandscape ? (screenWidth * 0.4) : (screenWidth * 0.7);

  // **Dynamic Heights Based on Screen Height**
  static double get buttonHeight => isLandscape ? (screenHeight * 0.12) : (screenHeight * 0.1);
  static double get miniSelectionDialogHeight => isLandscape ? (screenHeight * 0.32) : (screenHeight * 0.2);

  // **Dynamic Spacing
  static double sizedBox8 = 8.0 * _scalingFactorSizedBox;
  static double sizedBox10 = 10.0 * _scalingFactorSizedBox;
  static double spacingStandard = 12.0 * _scalingFactorSizedBox;
  static double sizedBox16 = 16.0 * _scalingFactorSizedBox;
  static double sizedBox18 = 18.0 * _scalingFactorSizedBox;
  static double sizedBox20 = 20.0 * _scalingFactorSizedBox;
  static double sizedBox22 = 22.0 * _scalingFactorSizedBox;

  // **Dynamic Padding Templates**
  static double get padding32 => 32.0 * _scalingFactorPadding;
  static double get padding20 => 20.0 * _scalingFactorPadding;
  static double get padding16 => 16.0 * _scalingFactorPadding;
  static double get padding12 => 12.0 * _scalingFactorPadding;
  static double get padding10 => 10.0 * _scalingFactorPadding;
  static double get padding8 => 8.0 * _scalingFactorPadding;
  static double get padding5 => 5.0 * _scalingFactorPadding;
  static double get bottomModalPadding => 16.0 * _scalingFactorPadding;


  // **Predefined Scaled Text Sizes**
  static double get text10 => 10 * _textScalingFactor * _textOrientationFactor * _userScalingFactor;
  static double get text12 => 12 * _textScalingFactor * _textOrientationFactor * _userScalingFactor;
  static double get text14 => 14 * _textScalingFactor * _textOrientationFactor * _userScalingFactor;
  static double get text16 => 16 * _textScalingFactor * _textOrientationFactor * _userScalingFactor;
  static double get text18 => 18 * _textScalingFactor * _textOrientationFactor * _userScalingFactor;
  static double get text20 => 20 * _textScalingFactor * _textOrientationFactor * _userScalingFactor;
  static double get text22 => 22 * _textScalingFactor * _textOrientationFactor * _userScalingFactor;
  static double get text24 => 24 * _textScalingFactor * _textOrientationFactor * _userScalingFactor;
  static double get text28 => 28 * _textScalingFactor * _textOrientationFactor * _userScalingFactor;
  static double get text30 => 30 * _textScalingFactor * _textOrientationFactor * _userScalingFactor;
  static double get text32 => 32 * _textScalingFactor * _textOrientationFactor * _userScalingFactor;
  static double get text36 => 36 * _textScalingFactor * _textOrientationFactor * _userScalingFactor;
  static double get text48 => 48 * _textScalingFactor * _textOrientationFactor * _userScalingFactor;
  static double get text64 => 64 * _textScalingFactor * _textOrientationFactor * _userScalingFactor;
  static double get text96 => 96 * _textScalingFactor * _textOrientationFactor * _userScalingFactor;
  static double get appBarText => 24;
  static double get errorText => 16 * _textScalingFactor * _textOrientationFactor * _userScalingFactor;
  static double get tabBarTextSize => 14 * _textScalingFactor * _textOrientationFactor * _userScalingFactor;
  static double get tabBarIconSize => 24 * _textScalingFactor * _textOrientationFactor * _userScalingFactor;
  static double get bottomDialogTextSize => 14 * _textScalingFactor * _textOrientationFactor * _userScalingFactor;
  static double get dropDownArrowSize => 14 * _textScalingFactor * _textOrientationFactor * _userScalingFactor;
  static double get miniDialogTitleTextSize => 22 * _textScalingFactor * _textOrientationFactor * _userScalingFactor;
  static double get miniDialogBodyTextSize => 18 * _textScalingFactor * _textOrientationFactor * _userScalingFactor;
  static double get modalTextSize => 14 * _textScalingFactor * _textOrientationFactor * _userScalingFactor;

}

