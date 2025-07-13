import 'package:http/http.dart' as http;
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

class ProductsView extends StatefulWidget {
  ProductModel? categoryInfo;
  bool? showCategories = false;

  bool? isHorizontalScrolling = false;
  ProductsView(
      {super.key,
      this.categoryInfo,
      this.showCategories,
      this.isHorizontalScrolling});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  bool isLoading = false;
  List<ProductModel> kCategories = [];

  List<ProductModel> kProducts = [];
  List<ProductModel> kProductsFinal = [];

  String _searchText = '';

  @override
  void initState() {
    super.initState();
    fetchProducts();
    // fetchCategories();
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
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
          Uri.parse(
              '${UrlUtils.getBaseUrl()}/store/products?region_id=${UrlUtils.regionId}'),
          headers: {
            'x-publishable-api-key': '${UrlUtils.token}',
            'Accept': 'application/json',
          });

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var body = (json.decode(response.body)['products'] as List);
        setState(() {
          for (var data in body) {
            show_log_error("the data in fetchCategories products is ${data}");

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
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e, stackTrace) {
      setState(() {
        isLoading = false;
      });
      print('Failed to load products, ${e} ${stackTrace}');
    }
  }

  @override
  Widget build(BuildContext context) {
      kProductsFinal = kProducts.length == 0
        ? []
        : kProducts
            .where((product) {
              print("product.brandName is ${product.brandName}");
              return product.brandName.toString()
                .toLowerCase()
                .contains(_searchText.toLowerCase()) as bool;
            })
            .toList();
    return Scaffold(
      appBar: widget.isHorizontalScrolling == true
          ? const PreferredSize(
              preferredSize: Size.zero,
              child: SizedBox(),
            )
          : AppBar(
            // automaticallyImplyLeading: true,
            leading: IconButton(
              padding: EdgeInsets.all(0),
              onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.chevron_left)),
              title: const Text("Products", textAlign: TextAlign.center,),
              toolbarHeight: 50,
              bottom: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 30),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:8.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search products",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide.none)
                    ),
                  ),
                ),
              ),
            ),
      body: widget.isHorizontalScrolling == true
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(kProducts.length, (index) {
                  final product = kProducts[index];
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ProductCard(
                      image: product.image,
                      brandName: product.brandName,
                      title: product.title,
                      price: null,
                      priceAfetDiscount: product.priceAfetDiscount,
                      dicountpercent: _calculateDiscount(product),
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductBuyNowScreen(
                              productDetails: product,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding,
                    vertical: defaultPadding,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      mainAxisSpacing: defaultPadding,
                      crossAxisSpacing: defaultPadding,
                      childAspectRatio: 0.66,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = kProductsFinal[index];
                        return ProductCard(
                          image: product.image,
                          brandName: product.brandName,
                          title: product.title,
                          price: null,
                          priceAfetDiscount: product.priceAfetDiscount,
                          dicountpercent: _calculateDiscount(product),
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductBuyNowScreen(
                                  productDetails: product,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      childCount: kProductsFinal.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
  int? _calculateDiscount(dynamic product) {
  try {
    final variants = product.productInfo?['variants'];
    if (variants is List && variants.isNotEmpty) {
      final priceInfo = variants[0]['calculated_price'];
      if (priceInfo != null &&
          priceInfo['original_amount'] != null &&
          priceInfo['calculated_amount'] != null) {
        final original = priceInfo['original_amount'] as num;
        final discounted = priceInfo['calculated_amount'] as num;
        if (original > discounted) {
          return (((original - discounted) / original) * 100).round();
        }
      }
    }
  } catch (_) {}
  return null;
}

}
