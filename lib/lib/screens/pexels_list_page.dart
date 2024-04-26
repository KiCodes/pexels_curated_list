import 'package:async_builder/async_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motopay/lib/controllers/pexels_page_controller.dart';
import 'package:motopay/lib/screens/photo_details_page.dart';

import '../constants/constants.dart';

class PexelsListPage extends StatelessWidget {
  const PexelsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final ctl = Get.put(PexelsPageController());

    // Scroll controller to monitor scroll position
    final scrollController = ScrollController();

    // Add listener to the scroll controller
    scrollController.addListener(() {
      // Check if the user has reached the end of the list
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // Set loading state to true
        ctl.isLoading.value = true;
        // Fetch next page data when reaching the end of the list
        ctl.fetchNextPage().then((_) {
          // Set loading state back to false after data is fetched
          ctl.isLoading.value = false;
        });
      }
    });

    return Scaffold(
      backgroundColor: AppColor.appBlack,
      appBar: AppBar(
          toolbarHeight: 60,
          centerTitle: true,
          backgroundColor: AppColor.appBlack,
          title: Text(
            AppStrings.title,
            style: GoogleFonts.lato(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 32),
          )),
      body: SingleChildScrollView(
          controller: scrollController, // Assign the scroll controller
          child: Container(
              width: screenWidth,
              padding: screenWidth < 800
                  ? const EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                  : const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AsyncBuilder<void>(
                    future: ctl.fetchData(),
                    waiting: (context) => _buildLoadingIndicator(screenHeight, screenWidth),
                    builder: (context, value) {
                      // Display the list of photos
                      return Obx(
                        ()=> Column(
                          children: ctl.allPhotos.map((photo) {
                            return GestureDetector(
                              onTap: () => Get.to(() => PhotoDetailsPage(
                                photographer: photo.photographer,
                                photographerProfile: photo.photographerUrl,
                                alt: photo.alt,
                                averageColor: photo.avgColor,
                                imgSource: photo.url,
                                imgUrl: photo.src!.tiny,
                              )),
                              child: Container(
                                width: screenWidth * 5,
                                margin: const EdgeInsets.only(bottom: 32),
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: Colors.white38, width: 1),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                      child: ClipRRect(
                                        clipBehavior: Clip.antiAlias,
                                        borderRadius: BorderRadius.circular(18),
                                        child: Image.network(photo.src!.tiny!,
                                          width: screenWidth * 0.45,
                                        ),
                                      ),
                                    ),
                                    8.horizontalSpace,
                                    Flexible(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'By ${photo.photographer}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${photo.alt}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );

                    },
                    error: (context, error, stackTrace) => _buildNoInternetMessage(screenHeight, screenWidth, ctl),
                  ),
                  Obx(
                    ()=> Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (ctl.isLoading.value) LoadingAnimationWidget.threeArchedCircle(
                            color: AppColor.appColor, size: 30),
                        if (!ctl.isLoading.value) Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black45
                          ),
                          child: GestureDetector(
                              onTap: () {
                                ctl.fetchNextPage();
                              },
                              child: const Icon(Icons.refresh, color: Colors.white,)),
                        ),
                      ],
                    ),
                  )
                ],
              ))),
    );
  }

  Widget _buildNoInternetMessage(double screenHeight, double screenWidth, PexelsPageController ctl) {
    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Center(
        child: Column(
          children: [
            Text('No internet connection',
                style: GoogleFonts.lato(
                    fontSize: 24, fontWeight: FontWeight.w500, color: Colors.grey)),
            12.verticalSpace,
            Container(
              height: 60,
              width: 60,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.appColor
              ),
              child: GestureDetector(
                onTap: ()=> ctl.nextPageUrl,
                  child: const Icon(Icons.refresh, color: Colors.white,)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(double screenHeight, double screenWidth) {
    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Center(
        child: LoadingAnimationWidget.threeArchedCircle(
            color: AppColor.appColor, size: 60),
      ),
    );
  }
}
