
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motopay/lib/controllers/pexels_page_controller.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../controllers/splash_page_controller.dart';
import 'pexels_list_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller  = Get.put(SplashPageController());

    Future.delayed(const Duration(seconds: 5), () {
      Get.off(() => const PexelsListPage());
    });

    return Scaffold(
        backgroundColor: AppColor.appBlack,
        body: Stack(children: [

          Obx(
                () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Row(),
                AnimatedScale(
                  scale: controller.shouldShowLogo.value ? 1 : 0,
                  curve: Curves.bounceInOut,
                  onEnd: () {
                    controller.updateShowLogoText();
                  },
                  duration: const Duration(milliseconds: 600),
                  child: Text(
                    AppStrings.pexels, style: GoogleFonts.pacifico(
                      fontWeight: FontWeight.bold,
                      fontSize: 40, color: Colors.white
    ),
                  ),
                ),
                4.verticalSpace,
                AnimatedSlide(
                  offset: Offset(0, controller.showLogoText.value ? 0 : 0.5),
                  duration: const Duration(milliseconds: 700),
                  child: AnimatedOpacity(
                    opacity: controller.showLogoText.value ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      AppStrings.pexelsCurated,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cabinSketch(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]));
  }
}
