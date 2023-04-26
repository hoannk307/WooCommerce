// Copyright (c) 2023, WooSignal Ltd.
// All rights reserved.
//
// Redistribution and use in source and binary forms are permitted
// provided that the above copyright notice and this paragraph are
// duplicated in all such forms and that any documentation,
// advertising materials, and other materials related to such
// distribution and use acknowledge that the software was developed
// by the WooSignal. The name of the
// WooSignal may not be used to endorse or promote products derived
// from this software without specific prior written permission.
// THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

import './menu_link.dart';

class WooSignalApp {
  String appName = 'Link Design';
  String appLogo = '';
  String appTermsLink = '';
  String appPrivacyLink = '';
  int appDebug = 1;
  int appStatus = 1;
  CurrencyMeta? currencyMeta;
  List<String> bannerImages = [];
  bool stripeLiveMode = true;
  String stripeAccount = '';
  int wpLoginEnabled = 0;
  bool couponEnabled = true;
  bool showProductReviews = true;
  bool showRelatedProducts = true;
  bool showUpsellProducts = true;
  String wpLoginBaseUrl = '';
  String wpLoginForgotPasswordUrl = '';
  String wpLoginWpApiPath = '';
  int productPricesIncludeTax = 1;
  int disableShipping = 0;
  String theme = '';
  String locale = '';
  String paypalLocale = '';
  String paypalEmail = '';
  bool stripeEnabled = true;
  bool codEnabled = true;
  bool paypalEnabled = true;
  bool wishlistEnabled = false;
  bool paypalLiveMode = true;
  String stripeCountryCode = '';
  String themeFont = '';
  Map<String, dynamic> socialLinks = {};
  List<MenuLink> menuLinks = [];
  Map<String, dynamic> themeColors = {};

  WooSignalApp(
      {appName,
      appLogo,
      appTermsLink,
      appPrivacyLink,
      appDebug,
      appStatus,
      currencyMeta,
      bannerImages,
      stripeLiveMode,
      stripeAccount,
      wpLoginEnabled,
      wpLoginBaseUrl,
      wpLoginForgotPasswordUrl,
      wpLoginWpApiPath,
      productPricesIncludeTax,
      disableShipping,
      theme,
      locale,
      paypalLocale,
      paypalEmail,
      stripeEnabled,
      codEnabled,
      paypalEnabled,
      paypalLiveMode,
      stripeCountryCode,
      couponEnabled,
      wishlistEnabled,
      themeFont,
      socialLinks,
      menuLinks = const [],
      themeColors});
}

class CurrencyMeta {
  String symbol = '';
  String name = '';
  String symbolNative = '';
  int decimalDigits = 1;
  int rounding = 1;
  String code = '';
  String namePlural = '';

  CurrencyMeta(
      {symbol, name, symbolNative, decimalDigits, rounding, code, namePlural});
}
