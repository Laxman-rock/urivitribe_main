import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urvitribe_main/components/list_tile/divider_list_tile.dart';
import 'package:urvitribe_main/components/network_image_with_loader.dart';
import 'package:urvitribe_main/constants.dart';
import 'package:urvitribe_main/route/screen_export.dart';
import 'package:urvitribe_main/screens/profile/views/getHelpScreen.dart';
import 'package:urvitribe_main/utils/payment_gateway_manager.dart';

import 'components/profile_card.dart';
import 'components/profile_menu_item_list_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ProfileCard(
            name: "Sepide",
            email: "theflutterway@gmail.com",
            imageSrc: "https://i.imgur.com/IXnwbLk.png",
            // proLableText: "Sliver",
            // isPro: true, if the user is pro
            press: () {
              Navigator.pushNamed(context, userInfoScreenRoute);
            },
          ),
          /* Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding * 1.5),
            child: GestureDetector(
              onTap: () {},
              child: const AspectRatio(
                aspectRatio: 1.8,
                child:
                    NetworkImageWithLoader("https://i.imgur.com/dz0BBom.png"),
              ),
            ),
          ), */

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Text(
              "Account",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ProfileMenuListTile(
            text: "Orders",
            svgSrc: "assets/icons/Order.svg",
            press: () {
              Navigator.pushNamed(context, ordersScreenRoute);
            },
          ),
          /* ProfileMenuListTile(
            text: "Returns",
            svgSrc: "assets/icons/Return.svg",
            press: () {},
          ),
          ProfileMenuListTile(
            text: "Wishlist",
            svgSrc: "assets/icons/Wishlist.svg",
            press: () {},
          ), */
          ProfileMenuListTile(
            text: "Addresses",
            svgSrc: "assets/icons/Address.svg",
            press: () {
              Navigator.pushNamed(context, addressesScreenRoute);
            },
          ),
          /*   ProfileMenuListTile(
            text: "Payment",
            svgSrc: "assets/icons/card.svg",
            press: () {
              Navigator.pushNamed(context, emptyPaymentScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "Wallet",
            svgSrc: "assets/icons/Wallet.svg",
            press: () {
              Navigator.pushNamed(context, walletScreenRoute);
            },
          ), */
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: Text(
              "Personalization",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          DividerListTileWithTrilingText(
            svgSrc: "assets/icons/Notification.svg",
            title: "Notification",
            trilingText: "Off",
            press: () {
              Navigator.pushNamed(context, enableNotificationScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "Preferences",
            svgSrc: "assets/icons/Preferences.svg",
            press: () {
              Navigator.pushNamed(context, preferencesScreenRoute);
            },
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: Text(
              "Settings",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ProfileMenuListTile(
            text: "Language",
            svgSrc: "assets/icons/Language.svg",
            press: () {
              Navigator.pushNamed(context, selectLanguageScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "Location",
            svgSrc: "assets/icons/Location.svg",
            press: () {},
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: Text(
              "Help & Support",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ProfileMenuListTile(
            text: "Get Help",
            svgSrc: "assets/icons/Help.svg",
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GetHelpScreen()));
            },
          ),
          ProfileMenuListTile(
            text: "FAQ",
            svgSrc: "assets/icons/FAQ.svg",
            press: () {},
            isShowDivider: false,
          ),
          const SizedBox(height: defaultPadding),
          
          // Payment Gateway Management Section
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: Text(
              "Payment Gateway",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ProfileMenuListTile(
            text: "Refresh Payment Config",
            svgSrc: "assets/icons/Preferences.svg",
            press: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Refresh Configuration"),
                  content: Text("This will refresh the payment gateway configuration from the server."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        bool success = await PaymentGatewayManager.refreshPaymentConfig();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(success 
                              ? "Payment configuration refreshed successfully" 
                              : "Failed to refresh payment configuration"),
                          ),
                        );
                      },
                      child: Text("Refresh"),
                    ),
                  ],
                ),
              );
            },
          ),
          ProfileMenuListTile(
            text: "Clear Payment Config",
            svgSrc: "assets/icons/Preferences.svg",
            press: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Clear Configuration"),
                  content: Text("This will clear all stored payment gateway configuration."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        bool success = await PaymentGatewayManager.clearPaymentConfig();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(success 
                              ? "Payment configuration cleared successfully" 
                              : "Failed to clear payment configuration"),
                          ),
                        );
                      },
                      child: Text("Clear"),
                    ),
                  ],
                ),
              );
            },
          ),
          ProfileMenuListTile(
            text: "Current Payment Config",
            svgSrc: "assets/icons/Preferences.svg",
            press: () {
              Map<String, String?> config = PaymentGatewayManager.getCurrentConfig();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Current Payment Configuration"),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Razorpay ID: ${config['razorpayId'] ?? 'Not set'}"),
                        SizedBox(height: 8),
                        Text("Account: ${config['razorpayAccount'] ?? 'Not set'}"),
                        SizedBox(height: 8),
                        Text("Secret: ${config['razorpaySecret'] != null ? '***' : 'Not set'}"),
                        SizedBox(height: 8),
                        Text("Webhook Secret: ${config['razorpayWebhookSecret'] != null ? '***' : 'Not set'}"),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
            },
            isShowDivider: false,
          ),
          const SizedBox(height: defaultPadding),

          // Log Out
          ListTile(
            onTap: () {},
            minLeadingWidth: 24,
            leading: SvgPicture.asset(
              "assets/icons/Logout.svg",
              height: 24,
              width: 24,
              colorFilter: const ColorFilter.mode(
                errorColor,
                BlendMode.srcIn,
              ),
            ),
            title: const Text(
              "Log Out",
              style: TextStyle(color: errorColor, fontSize: 14, height: 1),
            ),
          )
        ],
      ),
    );
  }
}
