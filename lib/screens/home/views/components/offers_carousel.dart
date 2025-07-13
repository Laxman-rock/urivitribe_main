import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:urvitribe_main/components/Banner/M/banner_m_style_1.dart';
import 'package:urvitribe_main/components/Banner/M/banner_m_style_2.dart';
import 'package:urvitribe_main/components/Banner/M/banner_m_style_3.dart';
import 'package:urvitribe_main/components/Banner/M/banner_m_style_4.dart';
import 'package:urvitribe_main/components/dot_indicators.dart';
import 'package:urvitribe_main/utils/shared_pref.dart';

import '../../../../Constants/constants.dart';
import '../../../../Services/Api_Controls/api_call.dart';
import '../../../../constants.dart';
import '../../../../url_auth/url_utils.dart';

class OffersCarousel extends StatefulWidget {
  const OffersCarousel({
    super.key,
  });

  @override
  State<OffersCarousel> createState() => _OffersCarouselState();
}

class _OffersCarouselState extends State<OffersCarousel> {
  int _selectedIndex = 0;
  late PageController _pageController;
  late Timer _timer;

  // Offers List
  List offers = [];

  bool isLoading = false;

  bool hasError = false;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    fetchCategories();
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_selectedIndex < offers.length - 1) {
        _selectedIndex++;
      } else {
        _selectedIndex = 0;
      }

      _pageController.animateToPage(
        _selectedIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    });

    super.initState();
  }

  // Method to refresh configuration
  Future<void> refreshConfiguration() async {
    await fetchCategories();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.87,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: offers.length,
            onPageChanged: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            itemBuilder: (context, index) => offers[index],
          ),
          FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: SizedBox(
                height: 16,
                child: Row(
                  children: List.generate(
                    offers.length,
                    (index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: defaultPadding / 4),
                        child: DotIndicator(
                          isActive: index == _selectedIndex,
                          activeColor: Colors.white70,
                          inActiveColor: Colors.white54,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  fetchCategories() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final bannerresponse =
          await getCall('${UrlUtils.getBaseUrl()}/store/banners', headers2);
      var storeconfig =
          await getCall('${UrlUtils.getStoreConfiguration()}', headers2);
      print("banners is  ${bannerresponse.body}");
      print("banners is  storeconfig ${storeconfig.body}");
      // Store the entire configs
      SharedPrefs.instance.setString(
          "configs", jsonEncode(jsonDecode(storeconfig.body)["config"]));
      
      // Extract and store Razorpay configuration
      try {
        var configData = jsonDecode(storeconfig.body);
        if (configData["configs"] != null && configData["configs"].isNotEmpty) {
          var defaultConfig = configData["configs"][0]; // Get the first config (default)
          if (defaultConfig["config"] != null) {
            var razorpayConfig = defaultConfig["config"];
            
            // Store Razorpay configuration
            await SharedPrefs.setRazorpayId(razorpayConfig["RAZORPAY_ID"] ?? "");
            await SharedPrefs.setRazorpaySecret(razorpayConfig["RAZORPAY_SECRET"] ?? "");
            await SharedPrefs.setRazorpayAccount(razorpayConfig["RAZORPAY_ACCOUNT"] ?? "");
            await SharedPrefs.setRazorpayWebhookSecret(razorpayConfig["RAZORPAY_WEBHOOK_SECRET"] ?? "");
            
            print("Razorpay configuration stored successfully");
          }
        }
      } catch (e) {
        print("Error storing Razorpay configuration: $e");
      }
      // print(response.statusCode);
      print("bannerresponse.statusCode is ${bannerresponse.statusCode}");

      if (bannerresponse.statusCode >= 200 || bannerresponse.statusCode < 301) {
        var body = jsonDecode(bannerresponse.body)["banners"];
        offers = [];
        show_log_error("the body of content is $body");
        for (var data in body) {
          offers.add(BannerMStyle1(
              text: data["title"],
              subTitle: data["subtxt"],
              press: () {},
              // description: data["subtxt"],
              // gradientColors: [Color(0xFF4FC3F7), Color(0xFF7B1FA2)],
              // overlayText: 'Dream',
              // overlaySubtext: 'Urban Collection',
              // overlayYear: '2024',
              image: data["image_url"]));
        }
      }
      setState(() {
        offers = offers;
      });

      /*  if (response.statusCode == 200 ||
          response.statusCode == 301 ||
          response.statusCode == 201) {
        setState(() {
          categories =
              (json.decode(response.body)['product_categories'] as List);
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
        throw Exception('Failed to load products');
      } */
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }
}
