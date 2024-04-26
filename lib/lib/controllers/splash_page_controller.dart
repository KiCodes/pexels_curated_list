import 'package:get/get.dart';


class SplashPageController extends GetxController {
  final shouldShowLogo = false.obs;
  final showLogoText = false.obs;

  updateShouldShowLogo() {
    shouldShowLogo(true);
  }

  updateShowLogoText() {
    showLogoText(true);
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 1500), () {
      updateShouldShowLogo();
    });
  }
}
