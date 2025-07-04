import 'package:flutter/material.dart';
import 'package:urvitribe_main/Constants/constants.dart';

import '../../../../constants.dart';

class UnitPrice extends StatelessWidget {
  const UnitPrice({
    super.key,
    required this.price,
    this.priceAfterDiscount,
  });

  final double price;
  final double? priceAfterDiscount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Unit price",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: defaultPadding / 1),
        Text.rich(
          TextSpan(
            text: priceAfterDiscount == null
                ? "₹ ${mFormatAmount(price.toString(),amINeedDrCr: false)}  "
                : "₹ ${mFormatAmount(priceAfterDiscount!.toStringAsFixed(2), amINeedDrCr: false)}  ",
            style: Theme.of(context).textTheme.titleLarge,
            children: [
              if (priceAfterDiscount != null)
                TextSpan(
                  text: "₹ ${mFormatAmount(price.toString(), amINeedDrCr: false)}",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      decoration: TextDecoration.lineThrough),
                ),
            ],
          ),
        )
      ],
    );
  }
}
