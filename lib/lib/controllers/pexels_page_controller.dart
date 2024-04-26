import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:motopay/lib/models/photo_model_response.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/api_key.dart';
import '../constants/app_colors.dart';

class PexelsPageController extends GetxController {
  List<Photo> allPhotos = <Photo>[].obs;
  String? nextPageUrl; // URL for the next page
  int pageNumber = 1; // tracking page numbering
  // Boolean variable to track loading state
  RxBool isLoading = false.obs;

  final Uri _urlProfile = Uri.parse('https://tellybucks.intellyjent.com/login');
  final Uri _urlWebsite = Uri.parse('https://tellybucks.intellyjent.com/login');

  Future<void> fetchData({String? url}) async {
    bool isConnected =  await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      try {
        final response = await http.get(Uri.parse(url ?? 'https://api.pexels.com/v1/curated?page=1&per_page=20'),
          headers: {
            'Authorization': ApiKey.apiKey,
          },);
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          final photoModelResponse = PhotoModelResponse.fromJson(jsonData);

          // Update nextPageUrl
          nextPageUrl = photoModelResponse.nextPage;


          // Append fetched photoModelResponse to the photoList
          for (var photo in photoModelResponse.photos!) {
            // Check if the photo ID already exists in the list
            if (!allPhotos.any((existingPhoto) => existingPhoto.id == photo.id)) {
              allPhotos.add(photo);
            }
          }
          print(allPhotos.length);
          // Notify listeners about the changes in photoList
          update();
        } else {
          Fluttertoast.showToast(msg: 'Something went wrong',
              backgroundColor: AppColor.appColor, textColor: Colors.white
          );
          throw Exception('Failed to load data');
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Something went wrong',
            backgroundColor: AppColor.appColor, textColor: Colors.white
        );
        throw Exception('Failed to load data: $e');
      }
    }
    else{
      Fluttertoast.showToast(msg: 'No Internet Connection',
          backgroundColor: AppColor.appColor, textColor: Colors.white
      );
    }
  }

  // Method to fetch next page data
  Future<void> fetchNextPage() async {
    if (nextPageUrl != null) {
      await fetchData(url: nextPageUrl);
    }else{
      Fluttertoast.showToast(msg: 'End of List',
          backgroundColor: AppColor.appColor, textColor: Colors.white
      );
    }
  }


  //launch photographer profile
  Future<void> launchProfile() async {
    if (!await launchUrl(_urlProfile)) {
      throw Exception('Could not launch $_urlProfile');
    }
  }

  //lanch img website
  Future<void> launchWebsite() async {
    if (!await launchUrl(_urlWebsite)) {
      throw Exception('Could not launch $_urlWebsite');
    }
  }

  Color hexToColor(String code) {
    // Remove the "#" character
    String cleanCode = code.replaceAll("#", "");

    // Parse the hexadecimal string as an integer
    int colorInt = int.parse(cleanCode, radix: 16);

    // Create a Color object using the integer value and the 0xFF prefix
    return Color(0xFF000000 + colorInt);
  }

}
