import 'dart:developer';

import 'package:daliconverter/utils/external_app_launcher.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends GetxController {
  final _appVersion = ''.obs;
  final _appName = ''.obs;
  final _isLoading = false.obs;

  String get appVersion => _appVersion.value;
  String get appName => _appName.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _loadAppInfo();
  }

  /// Load app information from package
  Future<void> _loadAppInfo() async {
    _isLoading.value = true;
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _appName.value = packageInfo.appName;
      _appVersion.value = '${packageInfo.version} (${packageInfo.buildNumber})';
    } catch (e) {
      print('Error loading app info: $e');
      _appVersion.value = 'Unknown';
      _appName.value = 'Instant Converter';
    } finally {
      _isLoading.value = false;
    }
  }

  /// Launch email client for contact
  Future<void> contactUs() async {
    const String email = 'amirbayat.dev@gmail.com';
    const String subject = 'Instant Converter - Feedback';
    const String body =
        'Hi,\n\nI would like to share my feedback about the app:\n\n';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: Uri.encodeQueryComponent('subject=$subject&body=$body'),
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      }
    } catch (e) {
      log('Error launching email: $e');
    }
  }

  /// Share app information
  Future<void> shareApp() async {
    const String appUrl =
        'https://play.google.com/store/apps/details?id=com.example.converter';
    const String shareText =
        'Check out Instant Converter - Convert between multiple units instantly! $appUrl';

    ExternalAppLauncher.shareApp(text: shareText, url: appUrl);
  }

  /// Get app information formatted
  String get appInfo => '$appName v$appVersion';
}