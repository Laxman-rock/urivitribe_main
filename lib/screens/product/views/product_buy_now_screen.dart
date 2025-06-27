import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:urvitribe_main/components/cart_button.dart';
import 'package:urvitribe_main/components/custom_modal_bottom_sheet.dart';
import 'package:urvitribe_main/components/network_image_with_loader.dart';
import 'package:urvitribe_main/models/product_model.dart';
import 'package:urvitribe_main/screens/product/views/added_to_cart_message_screen.dart';
import 'package:urvitribe_main/screens/product/views/components/product_list_tile.dart';
import 'package:urvitribe_main/screens/product/views/location_permission_store_availability_screen.dart';
import 'package:urvitribe_main/screens/product/views/size_guide_screen.dart';

import '../../../Constants/constants.dart';
import '../../../Services/Api_Controls/api_call.dart';
import '../../../components/review_card.dart';
import '../../../constants.dart';
import '../../../url_auth/url_utils.dart';
import '../../../utils/ColoUtile.dart';
import '../../../utils/shared_pref.dart';
import 'components/product_quantity.dart';
import 'components/selected_colors.dart';
import 'components/selected_size.dart';
import 'components/unit_price.dart';

class ProductBuyNowScreen extends StatefulWidget {
  ProductModel? productDetails;
  ProductBuyNowScreen({super.key, this.productDetails});

  @override
  _ProductBuyNowScreenState createState() => _ProductBuyNowScreenState();
}

class _ProductBuyNowScreenState extends State<ProductBuyNowScreen> {
  var quantity = 1;
  int selectedVariant = 0;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  getCartId() async {
    try {
      final body = {
        'region_id': UrlUtils.regionId.toString(),
      };

      final response = await postCall('${UrlUtils.getBaseUrl()}/store/carts',
          data: body, headers: headers2);
      if (response.statusCode == 200 || response.statusCode == 301) {
        var data = json.decode(response.body);
        var cartId = data['cart']['id'];
        show_log_error(cartId.toString());
        setState(() {
          SharedPrefs.setCartId(cartId);
          addToCart(
              widget.productDetails?.productInfo?["variants"][selectedVariant]
                      ["id"] ??
                  "",
              quantity,
              SharedPrefs.getCartId().toString());
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error appropriately
    }
  }

  addToCart(String id, int quantity, String cartId) async {
    try {
      final body = {'variant_id': id, 'quantity': quantity, 'metadata': {}};
      final response = await postCall(
          '${UrlUtils.getBaseUrl()}/store/carts/${SharedPrefs.getCartId()}/line-items',
          data: body,
          headers: headers2);
      if (response.statusCode == 200 || response.statusCode == 301) {
        var data = json.decode(response.body);
        show_log_error(data.toString());
        setState(() {
          _isLoading = false;
          showToast('Item Added to Cart');
          Navigator.pop(context);
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CartButton(
        price: mFormatAmount(
            (double.parse(
                      (widget.productDetails?.productInfo?['variants']
                                      [selectedVariant]['calculated_price']
                                  ['calculated_amount'] ??
                              '0')
                          .toString(),
                    ) *
                    quantity)
                .toStringAsFixed(2),
            amINeedDrCr: false),
        title: "Add to cart",
        subTitle: "Total price",
        press: () {
          setState(() {
            _isLoading = true;
          });

          // Your Add to Cart logic
          if (SharedPrefs.getCartId() == null ||
              SharedPrefs.getCartId().toString() == '') {
            getCartId();
          } else {
            addToCart(
                widget.productDetails?.productInfo?["variants"][selectedVariant]
                        ["id"] ??
                    "",
                quantity,
                SharedPrefs.getCartId().toString());
          }
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding / 2, vertical: defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButton(),
                Text(
                  "${widget.productDetails?.brandName}",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset("assets/icons/Bookmark.svg",
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: AspectRatio(
                        aspectRatio: 1.45,
                        child: NetworkImageWithLoader("", fit: BoxFit.contain)),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Product Description",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                      "assets/icons/Star_filled.svg"),
                                  const SizedBox(width: defaultPadding / 4),
                                  Text(
                                    "4.3 ",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  Text("(128 Reviews)")
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              "${widget.productDetails?.productInfo?["description"]}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.normal))
                        ]),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(defaultPadding),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (widget.productDetails?.productInfo?['variants']
                                                [selectedVariant]
                                            ['calculated_price']
                                        ['original_amount'] >
                                    widget.productDetails
                                                    ?.productInfo?['variants']
                                                [selectedVariant]
                                            ['calculated_price']
                                        ['calculated_amount'])
                                ? Expanded(
                                    child: UnitPrice(
                                      price: double.parse(
                                        (widget.productDetails?.productInfo?[
                                                                'variants']
                                                            [selectedVariant]
                                                        ['calculated_price']
                                                    ['calculated_amount'] ??
                                                '0')
                                            .toString(),
                                      ),
                                      priceAfterDiscount: double.parse(
                                        (widget.productDetails?.productInfo?[
                                                                'variants']
                                                            [selectedVariant]
                                                        ['calculated_price']
                                                    ['original_amount'] ??
                                                '0')
                                            .toString(),
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: UnitPrice(
                                      price: double.parse(
                                        (widget.productDetails?.productInfo?[
                                                                'variants']
                                                            [selectedVariant]
                                                        ['calculated_price']
                                                    ['calculated_amount'] ??
                                                '0')
                                            .toString(),
                                      ),
                                    ),
                                  ),
                            ProductQuantity(
                              numOfItem: quantity,
                              onIncrement: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                              onDecrement: () {
                                if (quantity > 1) {
                                  setState(() {
                                    quantity--;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        // SizedBox(width: 8),
                        /*  Text(
                            '₹ ${widget.productDetails?.productInfo?['variants'][selectedVariant]}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.red,
                                    fontSize: 10)), */
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: Divider()),
                SliverToBoxAdapter(
                  /*   height: 48,
                      width: MediaQuery.of(context).size.width * 10,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ), */
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Size",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          // border: Border.all(color: Colors.grey)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      /* 
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(color: Colors.grey), */
                                      ),
                                  child: Row(
                                    children: List.generate(
                                      widget.productDetails
                                          ?.productInfo?['variants'].length,
                                      (index) => _buildChoiceChip(index),
                                    )
                                        .expand((chip) => [
                                              chip,
                                              if (chip !=
                                                  widget
                                                      .productDetails
                                                      ?.productInfo?['variants']
                                                      .last)
                                                const SizedBox(width: 2)
                                            ])
                                        .toList()
                                      ..removeLast(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: Divider()),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: ReviewCard(
                        rating: 4.3,
                        numOfReviews: 128,
                        numOfFiveStar: 80,
                        numOfFourStar: 30,
                        numOfThreeStar: 5,
                        numOfTwoStar: 4,
                        numOfOneStar: 1),
                  ),
                ),
                /*   SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  sliver: ProductListTile(
                    title: "Size guide",
                    svgSrc: "assets/icons/Sizeguid.svg",
                    isShowBottomBorder: true,
                    press: () {
                      customModalBottomSheet(
                        context,
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: const SizeGuideScreen(),
                      );
                    },
                  ),
                ), */
                /*  SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: defaultPadding / 2),
                        Text(
                          "Store pickup availability",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: defaultPadding / 2),
                        const Text(
                            "Select a size to check store availability and In-Store pickup options.")
                      ],
                    ),
                  ),
                ), */
                /*  SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  sliver: ProductListTile(
                    title: "Check stores",
                    svgSrc: "assets/icons/Stores.svg",
                    isShowBottomBorder: true,
                    press: () {
                      customModalBottomSheet(
                        context,
                        height: MediaQuery.of(context).size.height * 0.92,
                        child: const LocationPermissonStoreAvailabilityScreen(),
                      );
                    },
                  ),
                ), */
                const SliverToBoxAdapter(
                    child: SizedBox(height: defaultPadding))
              ],
            ),
          )
        ],
      ),
    );
  }

// Helper method to build individual choice chips
  Widget _buildChoiceChip(int index) {
    show_log_error(
        "widget.product['variants'][index] is ${jsonEncode(widget.productDetails?.productInfo?['variants'][index])}");
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            // boxShadow: selectedVariant == index
            /* ? [
                    BoxShadow(
                      color: ColorUtile.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ], */
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(5),
              splashColor: ColorUtile.primaryColor.withOpacity(0.1),
              highlightColor: ColorUtile.primaryColor.withOpacity(0.05),
              onTap: () {
                setState(() {
                  selectedVariant = index;
                });
                // Add haptic feedback
                // HapticFeedback.selectionClick();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: selectedVariant == index
                        ? ColorUtile.primaryColor
                        : Colors.grey.withOpacity(0.3),
                    width: selectedVariant == index ? 2 : 1,
                  ),
                  gradient: selectedVariant == index
                      ? LinearGradient(
                          colors: [
                            ColorUtile.primaryColor.withOpacity(0.1),
                            ColorUtile.primaryColor.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: selectedVariant == index ? null : Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Selected indicator icon
                    /*  AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: selectedVariant == index ? 20 : 0,
                      child: selectedVariant == index
                          ? Icon(
                              Icons.check_circle,
                              color: ColorUtile.primaryColor,
                              size: 16,
                            )
                          : const SizedBox.shrink(),
                    ),
                    if (selectedVariant == index) const SizedBox(width: 2), */

                    // Label text
                    Flexible(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          color: selectedVariant == index
                              ? ColorUtile.primaryColor
                              : Colors.grey[700],
                          fontWeight: selectedVariant == index
                              ? FontWeight.w600
                              : FontWeight.w500,
                          fontSize: 12,
                          // letterSpacing: 0.2,
                        ),
                        child: Text(
                          (widget.productDetails
                                  ?.productInfo!['variants'][index]["title"]
                                  ?.toString() ??
                              ""),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
