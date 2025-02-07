// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pari_testapp/app/core/utils/app_colors.dart';
import '../controllers/splash_controller.dart';
class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    IntrinsicWidth(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text(
                                'PARI',
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'miniapp',
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: progressBar(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget progressBar(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 1),
      builder: (context, value, child) {
        return LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey[800],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          minHeight: 10,
        );
      },
    );
  }
}