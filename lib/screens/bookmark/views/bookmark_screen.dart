import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:urvitribe_main/components/product/product_card.dart';
import 'package:urvitribe_main/models/product_model.dart';
import 'package:urvitribe_main/route/route_constants.dart';

import '../../../Constants/constants.dart';
import '../../../Services/Api_Controls/api_call.dart';
import '../../../components/skleton/product/products_skelton.dart';
import '../../../constants.dart';
import '../../../url_auth/url_utils.dart';
import '../../product/views/product_buy_now_screen.dart';
import '../../product/views/product_details_screen.dart';

class BookmarkScreen extends StatefulWidget {
  ProductModel? categoryInfo;
  bool? showCategories = false;
  BookmarkScreen({super.key, this.categoryInfo, this.showCategories});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  bool isLoading = false;
  List<ProductModel> kCategories = [];

  List<ProductModel> kProducts = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchCategories();
  }

  fetchCategories() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await getCall(
          '${UrlUtils.getBaseUrl()}/store/product-categories', headers2);

      if (response.statusCode == 200 ||
          response.statusCode == 301 ||
          response.statusCode == 201) {
        var body = (json.decode(response.body)['product_categories'] as List);
        for (var data in body) {
          show_log_error("the data in fetchCategories is ${data}");

          kCategories.add(ProductModel(
              image: data["metadata"]["image_url"],
              brandName: data["name"],
              title: data["description"],
              id: data["id"],
              price: 0));
          setState(() {
            kCategories = kCategories;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchProducts() async {
    try {
      final response = await getCall(
          '${UrlUtils.getBaseUrl()}/store/products?category_id=${widget.categoryInfo?.id}&region_id=${UrlUtils.regionId}',
          headers2);
      if (response.statusCode == 200 || response.statusCode == 301) {
        var body = (json.decode(response.body)['products'] as List);
        for (var data in body) {
          show_log_error("the data in fetchCategories is ${data}");

          kProducts.add(ProductModel(
              image: data["thumbnail"] ?? "",
              brandName: data["title"],
              title: data["description"],
              id: data["id"],
              productInfo: data,
              price: 0));
          setState(() {
            kProducts = kProducts;
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load products');
      }
      print("kProducts is ${kProducts.length}");
    } catch (e, stackTrace) {
      setState(() {
        isLoading = false;
      });
      show_log_error("the error is ${e},${stackTrace}");
      // Handle error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.showCategories == true
              ? "Discover"
              : "${widget.categoryInfo?.brandName}")),
      body: widget.showCategories == true
          ? Column(
              children: [
                Expanded(
                  child: isLoading
                      ? ProductsSkelton()
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.7, // Adjust this value based on your ProductCard design
                          ),
                          padding: EdgeInsets.all(defaultPadding),
                          itemCount: kCategories.length,
                          itemBuilder: (context, index) => ProductCard(
                            image: kCategories[index].image,
                            // brandName: demoPopularProducts[index].brandName,
                            title: kCategories[index].title,
                            // price: demoPopularProducts[index].price,
                            // priceAfetDiscount: demoPopularProducts[index].priceAfetDiscount,
                            dicountpercent: kCategories[index].dicountpercent,
                            press: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookmarkScreen(
                                          categoryInfo: kCategories[index])));
                            },
                          ),
                        ),
                ),
              ],
            )
          : CustomScrollView(
              slivers: [
                // While loading use 👇
                //  BookMarksSlelton(),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200.0,
                      mainAxisSpacing: defaultPadding,
                      crossAxisSpacing: defaultPadding,
                      childAspectRatio: 0.66,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return ProductCard(
                          image: kProducts[index].image,
                          brandName: kProducts[index].brandName,
                          title: kProducts[index].title,
                          price: null,
                          priceAfetDiscount: kProducts[index].priceAfetDiscount,
                          dicountpercent: (kProducts[index].productInfo != null &&
                                  kProducts[index].productInfo?['variants'] !=
                                      null &&
                                  (kProducts[index].productInfo?['variants'] as List)
                                      .isNotEmpty &&
                                  kProducts[index].productInfo?['variants'][0]
                                          ['calculated_price'] !=
                                      null &&
                                  kProducts[index].productInfo?['variants'][0]
                                          ['calculated_price']['original_amount'] !=
                                      null &&
                                  kProducts[index].productInfo?['variants'][0]
                                              ['calculated_price']
                                          ['calculated_amount'] !=
                                      null &&
                                  (kProducts[index].productInfo?['variants'][0]['calculated_price']['original_amount'] as num) >
                                      (kProducts[index].productInfo?['variants'][0]
                                          ['calculated_price']['calculated_amount'] as num))
                              ? ((((kProducts[index].productInfo?['variants'][0]['calculated_price']['original_amount'] as num) - (kProducts[index].productInfo?['variants'][0]['calculated_price']['calculated_amount'] as num)) / (kProducts[index].productInfo?['variants'][0]['calculated_price']['original_amount'] as num)) * 100).round()
                              : null,
                          press: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return ProductBuyNowScreen(
                                    productDetails: kProducts[index]);
                              },
                            ));
                          },
                        );
                      },
                      childCount: kProducts.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
