import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:daliconverter/utils/app_theme.dart';
import 'main_wrapper.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_use_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _current = 0;

  final List<_Slide> _slides = [
    _Slide(
      title: 'Convert Anything',
      subtitle:
          'Length, weight, volume, area, speed and more — fast and accurate.',
      icon: Icons.autorenew,
      bullets: [
        '140+ unit combinations',
        'Smart formatting of results',
        'Instant swap between units',
      ],
    ),
    _Slide(
      title: 'Time & Dates',
      subtitle:
          'Time conversions, date differences, and age calculation made easy.',
      icon: Icons.schedule,
      bullets: [
        'Age calculator with next birthday',
        'Date difference & add/subtract days',
        'Time unit conversions (ms → weeks)',
      ],
    ),
    _Slide(
      title: 'Timezones',
      subtitle: 'DST-aware timezone converter with global coverage and search.',
      icon: Icons.public,
      bullets: [
        'Popular zones + full searchable list',
        'Accurate DST handling',
        'One‑tap copy of converted time',
      ],
    ),
    _Slide(
      title: 'Built-in Tools',
      subtitle:
          'Secure password generator and handy utilities for everyday tasks.',
      icon: Icons.build_rounded,
      bullets: [
        'Strong, customizable passwords',
        'Save favorites locally',
        'Beautiful, theme‑aware UI',
      ],
    ),
  ];

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (mounted) {
      Get.offAll(() => const MainWrapper(), transition: Transition.fadeIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:
            BoxDecoration(gradient: AppTheme.getBackgroundGradient(context)),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _current = i),
                  itemBuilder: (context, index) {
                    final s = _slides[index];
                    return Padding(
                      padding: EdgeInsets.all(6.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 6.h),
                          Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: AppTheme.getPrimaryColor(context)
                                  .withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              s.icon,
                              color: AppTheme.getPrimaryColor(context),
                              size: 18.w,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            s.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.getTextPrimaryColor(context),
                            ),
                          ),
                          SizedBox(height: 1.2.h),
                          Text(
                            s.subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppTheme.getTextSecondaryColor(context),
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 2.2.h),
                          ...s.bullets.map((b) => _Bullet(text: b)).toList(),
                          const Spacer(),
                        ],
                      ),
                    );
                  },
                ),
              ),
              _buildLegalLinks(context),
              _buildIndicators(context),
              Padding(
                padding: EdgeInsets.all(6.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _finish,
                      child: const Text('Skip'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_current < _slides.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        } else {
                          _finish();
                        }
                      },
                      icon: Icon(_current < _slides.length - 1
                          ? Icons.arrow_forward
                          : Icons.check),
                      label: Text(_current < _slides.length - 1
                          ? 'Next'
                          : 'Get Started'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicators(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_slides.length, (i) {
          final active = i == _current;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            width: active ? 16 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: active
                  ? AppTheme.getPrimaryColor(context)
                  : AppTheme.getPrimaryColor(context).withOpacity(0.25),
              borderRadius: BorderRadius.circular(999),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLegalLinks(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () => Get.to(() => const PrivacyPolicyScreen()),
            child: const Text('Privacy Policy'),
          ),
          Text(
            '·',
            style: TextStyle(
              color: AppTheme.getTextSecondaryColor(context),
            ),
          ),
          TextButton(
            onPressed: () => Get.to(() => const TermsOfUseScreen()),
            child: const Text('Terms of Use'),
          ),
        ],
      ),
    );
  }
}

class _Slide {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> bullets;
  _Slide({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bullets,
  });
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(1.2.w),
            decoration: BoxDecoration(
              color: AppTheme.getPrimaryColor(context).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              size: 3.6.w,
              color: AppTheme.getPrimaryColor(context),
            ),
          ),
          SizedBox(width: 2.4.w),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppTheme.getTextPrimaryColor(context),
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}