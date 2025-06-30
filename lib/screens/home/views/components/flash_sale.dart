import 'package:flutter/material.dart';
import 'package:urvitribe_main/route/route_constants.dart';
import 'package:urvitribe_main/route/screen_export.dart';

import '../../../bookmark/views/productview.dart';
import '/components/Banner/M/banner_m_with_counter.dart';
import '../../../../components/product/product_card.dart';
import '../../../../constants.dart';
import '../../../../models/product_model.dart';

class FlashSale extends StatelessWidget {
  const FlashSale({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // While loading show 👇
        // const BannerMWithCounterSkelton(),
        BannerMWithCounter(
          duration: const Duration(hours: 8),
          text: "New Arrival \n50% Off",
          hideCounter: true,
          press: () {},
        ),
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Flash sale",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProductsView()));
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
        // While loading show 👇
        // const ProductsSkelton(),
        Container(
            width: MediaQuery.of(context).size.width,
            height: 250,
            child: ProductsView(isHorizontalScrolling: true))
      ],
    );
  }
}
