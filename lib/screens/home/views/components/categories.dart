import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:urvitribe_main/models/product_model.dart';
import 'package:urvitribe_main/route/screen_export.dart';

import '../../../../constants.dart';

// For preview
class CategoryModel {
  final String name;
  final String? svgSrc, route;

  CategoryModel({
    required this.name,
    this.svgSrc,
    this.route,
  });
}

List<CategoryModel> demoCategories = [
  CategoryModel(name: "All Categories"),
  CategoryModel(
      name: "On Sale",
      svgSrc: "assets/icons/Sale.svg",
      route: onSaleScreenRoute),
  CategoryModel(name: "Man's", svgSrc: "assets/icons/Man.svg"),
  CategoryModel(name: "Woman’s", svgSrc: "assets/icons/Woman.svg"),
  CategoryModel(
      name: "Kids", svgSrc: "assets/icons/Child.svg", route: kidsScreenRoute),
];
// End For Preview

class Categories extends StatelessWidget {
  List<ProductModel>? kCategories;
  Categories({
    super.key,
    this.kCategories,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...List.generate(
            (kCategories ?? []).length,
            (index) => Padding(
              padding: EdgeInsets.only(
                  left: index == 0 ? defaultPadding : defaultPadding / 2,
                  right: index == (kCategories ?? []).length - 1
                      ? defaultPadding
                      : 0),
              child: CategoryBtn(
                category: kCategories?[index].brandName ?? "",
                svgSrc: kCategories?[index].title,
                isActive: index == 0,
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookmarkScreen(
                              categoryInfo: kCategories?[index])));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryBtn extends StatelessWidget {
  const CategoryBtn({
    super.key,
    required this.category,
    this.svgSrc,
    required this.isActive,
    required this.press,
  });

  final String category;
  final String? svgSrc;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.transparent,
          border: Border.all(
              color: isActive
                  ? Colors.transparent
                  : Theme.of(context).dividerColor),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /* if (svgSrc != null)
              SvgPicture.asset(
                svgSrc!,
                height: 20,
                colorFilter: ColorFilter.mode(
                  isActive ? Colors.white : Theme.of(context).iconTheme.color!,
                  BlendMode.srcIn,
                ),
              ),
            if (svgSrc != null) const SizedBox(width: defaultPadding / 2), */
            Text(
              category,
              
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
