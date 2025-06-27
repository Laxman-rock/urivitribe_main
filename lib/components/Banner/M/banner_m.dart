import 'package:flutter/material.dart';

import '../../network_image_with_loader.dart';

class BannerM extends StatelessWidget {
    BannerM(
      {super.key,
      required this.image,
        this.isNetwork,
      required this.press,
      required this.children});

  final String image;
  bool? isNetwork = false;
  final VoidCallback press;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.87,
      child: GestureDetector(
        onTap: press,
        child: Stack(
          children: [
            isNetwork == true
                ? Image.asset(
                    image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : NetworkImageWithLoader(image, radius: 0),
            Container(color: Colors.black45),
            ...children,
          ],
        ),
      ),
    );
  }
}
