
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/constants.dart';
import '../controllers/pexels_page_controller.dart';

class PhotoDetailsPage extends StatelessWidget {
  final String? photographer;
  final String? photographerProfile;
  final String? alt;
  final String? averageColor; //average color of the photo
  final String? imgSource; //image on pexel page
  final String? imgUrl; //imageurl

  const PhotoDetailsPage({super.key, required this.photographer, required this.photographerProfile, required this.alt, required this.averageColor, required this.imgSource, this.imgUrl});


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final ctl = Get.put(PexelsPageController());

    return Scaffold(
      backgroundColor: AppColor.appBlack,
      appBar: AppBar(
          toolbarHeight: 60,
          centerTitle: true,
          backgroundColor: AppColor.appBlack,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: ()=> Get.back(),
              child: const Icon(CupertinoIcons.left_chevron, color: Colors.white,)),
          title: Text(
            photographer!,
            style: GoogleFonts.lato(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24),
          )),
      body: SingleChildScrollView(
          child: Container(
              width: screenWidth,
              padding: screenWidth < 800
                  ? const EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                  : const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius:
                    BorderRadius.circular(18),
                    child:
                    Image.network(imgUrl!),
                  ),
                  08.verticalSpace,
                  alt!.isNotEmpty
                      ? Text(
                    'description: $alt',
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ) : const SizedBox.shrink(),
                  24.verticalSpace,
                  averageColor!.isNotEmpty ? GestureDetector(
                    onTap: () async{
                      await Clipboard.setData(ClipboardData(
                          text: averageColor!
                              ));
                      Fluttertoast.showToast(
                        msg: 'Color Code Copied!',
                        textColor: Colors.white,
                        backgroundColor: AppColor.appColor,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Average Color',
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        08.horizontalSpace,
                        Text(
                          averageColor!,
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        08.horizontalSpace,
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ctl.hexToColor(averageColor!)
                          ),
                        ),
                      ],
                    ),
                  ) : const SizedBox.shrink(),
                  04.verticalSpace,
                  if (photographerProfile!.isNotEmpty) GestureDetector(
                    onTap: ()=> ctl.launchProfile(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            'Visit $photographer\'s profile',
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            
                          ),
                        ),
                        8.horizontalSpace,
                        const Flexible(child: Icon(Icons.open_in_new, color: Colors.white, size: 18,))
                      ],
                    ),
                  ) else const SizedBox.shrink(),
                  04.verticalSpace,
                  imgUrl!.isNotEmpty ? GestureDetector(
                    onTap: ()=> ctl.launchWebsite(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Visit Website',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        8.horizontalSpace,
                        const Icon(Icons.open_in_new, color: Colors.grey, size: 18,)
                      ],
                    ),
                  ) : const SizedBox.shrink(),
                ],
              )
          )),
    );
  }
}
