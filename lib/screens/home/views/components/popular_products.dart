import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:urvitribe_main/components/product/product_card.dart';
import 'package:urvitribe_main/models/product_model.dart';
import 'package:urvitribe_main/route/screen_export.dart';

import '../../../../Constants/constants.dart';
import '../../../../Services/Api_Controls/api_call.dart';
import '../../../../components/skleton/product/products_skelton.dart';
import '../../../../constants.dart';
import '../../../../url_auth/url_utils.dart';
import '../../../bookmark/views/productview.dart';
import 'categories.dart';

class PopularProducts extends StatefulWidget {
  const PopularProducts({
    super.key,
  });

  @override
  State<PopularProducts> createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  List<ProductModel> kCategories = [];

  bool isLoading = false;

  bool hasError = false;
  @override
  void initState() {
    // TODO: implement initState
    fetchCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Categories",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BookmarkScreen(showCategories: true)));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(30))),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "view all",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 12,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // While loading use 👇
        // const CategoriesSkelton(),
        Categories(kCategories: kCategories),
        // const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Popular products",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsView()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(30))),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "view all",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 12,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // While loading use 👇
        // const ProductsSkelton(),
        /*  isLoading == true
            ? ProductsSkelton()
            : GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 0.5,
                    mainAxisSpacing: 1,
                    childAspectRatio: 0.7),
                padding: EdgeInsets.all(5),
                itemCount: kCategories.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ProductCard(
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
              ) */
        Container(
            width: MediaQuery.of(context).size.width,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProductsView(isHorizontalScrolling: true),
            ))
      ],
    );
  }

  Future<void> fetchCategories() async {
    setState(() {
      isLoading = true;
      hasError = false;
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
            isLoading = false;
          });
        }
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }
}
