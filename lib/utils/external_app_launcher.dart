/// External app utilities for launching email, rating the app, opening store
/// listings, and sharing the app on Android and iOS.
///
/// Required pubspec.yaml dependencies (add if missing):
///
/// dependencies:
///   url_launcher: ^6.3.0
///   in_app_review: ^2.0.8
///   share_plus: ^10.0.2
///   package_info_plus: ^8.0.2
///
/// Android: Make sure to configure AndroidManifest queries if needed (url_launcher docs).
/// iOS: Ensure LSApplicationQueriesSchemes includes required schemes if you add custom ones.
library;

import 'dart:developer';

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Helper for launching external apps and intents in a platform-safe way.
class ExternalAppLauncher {
  ExternalAppLauncher._();

  /// Opens the default email composer with prefilled fields.
  ///
  /// Example:
  /// await ExternalAppLauncher.openEmail(
  ///   to: ['support@tronotales.com'],
  ///   subject: 'TronoTales Support',
  ///   body: 'Hello Trono team, ...',
  /// );
  static Future<bool> openEmail({
    required List<String> to,
    List<String>? cc,
    List<String>? bcc,
    String? subject,
    String? body,
  }) async {
    try {
      final uri = Uri(
        scheme: 'mailto',
        path: to.join(','),
        queryParameters: <String, String?>{
          if (subject != null && subject.isNotEmpty) 'subject': subject,
          if (body != null && body.isNotEmpty) 'body': body,
          if (cc != null && cc.isNotEmpty) 'cc': cc.join(','),
          if (bcc != null && bcc.isNotEmpty) 'bcc': bcc.join(','),
        }..removeWhere((_, v) => v == null || v.isEmpty),
      );
      if (!await launchUrl(uri)) {
        log('Error opening email');

        return false;
      }
      return true;
    } catch (_) {
      log('Error opening email');
      return false;
    }
  }

  /// Attempts to show the in-app rating dialog; falls back to opening the
  /// store listing when not available.
  ///
  /// Provide your iOS App Store ID (e.g. '1234567890') and Android package
  /// name (e.g. 'com.tronotales.app'). When null, Android package is resolved
  /// via PackageInfo; iOS App ID must be provided to open listing.
  // static Future<void> rateApp({
  //   String? androidPackageName,
  //   String? iOSAppId,
  // }) async {
  //   final inAppReview = InAppReview.instance;

  //   try {
  //     if (await inAppReview.isAvailable()) {
  //       await inAppReview.requestReview();
  //       return;
  //     }
  //   } catch (_) {
  //     // Ignore and fall back to store listing
  //     LogHelper.debug('Error requesting review');
  //   }

  //   await openStoreListing(
  //     androidPackageName: androidPackageName,
  //     iOSAppId: iOSAppId,
  //   );
  // }

  /// Opens the platform app store listing for this app.
  /// - Android: uses package name (falls back to current package)
  /// - iOS: requires [iOSAppId]
  // static Future<void> openStoreListing({
  //   String? androidPackageName,
  //   required String? iOSAppId,
  // }) async {
  //   final inAppReview = InAppReview.instance;

  //   String? pkg = androidPackageName;
  //   if ((pkg == null || pkg.isEmpty) && !_isWeb && _isAndroid) {
  //     try {
  //       final info = await PackageInfo.fromPlatform();
  //       pkg = info.packageName;
  //     } catch (_) {
  //       // ignore; will try generic Play link
  //       LogHelper.debug('Error getting package info');
  //     }
  //   }

  //   try {
  //     await inAppReview.openStoreListing(
  //       appStoreId: iOSAppId,
  //       microsoftStoreId: null,
  //     );
  //   } catch (_) {
  //     // Fallback to generic URLs
  //     final List<Uri> candidates = [];
  //     if (_isAndroid) {
  //       if (pkg != null && pkg.isNotEmpty) {
  //         candidates.add(Uri.parse('market://details?id=$pkg'));
  //         candidates.add(
  //           Uri.parse('https://play.google.com/store/apps/details?id=$pkg'),
  //         );
  //       }
  //     } else if (_isIOS && iOSAppId != null && iOSAppId.isNotEmpty) {
  //       // iOS App Store web link
  //       candidates.add(Uri.parse('https://apps.apple.com/app/id$iOSAppId'));
  //     }

  //     for (final uri in candidates) {
  //       if (await canLaunchUrl(uri)) {
  //         await launchUrl(uri, mode: LaunchMode.externalApplication);
  //         break;
  //       }
  //     }
  //   }
  // }

  /// Shares the app with customizable text and optional URL.
  ///
  /// Example:
  /// await ExternalAppLauncher.shareApp(
  ///   text: 'Join me on TronoTales! ',
  ///   url: 'https://apps.apple.com/app/idYOUR_ID',
  /// );
  static Future<void> shareApp({required String text, String? url}) async {
    final content = StringBuffer(text.trim());
    if (url != null && url.isNotEmpty) content.write('\n$url');
    await Share.share(content.toString());
  }

  /// Opens a generic URL in the external browser/app if possible.
  static Future<bool> openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri)) return false;
      return true;
    } catch (_) {
      log('Error opening url');
      return false;
    }
  }

  // static bool get _isAndroid => !kIsWeb && Platform.isAndroid;
  // static bool get _isIOS => !kIsWeb && Platform.isIOS;
  // static bool get _isWeb => kIsWeb;
}