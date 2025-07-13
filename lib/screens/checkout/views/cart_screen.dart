import 'dart:convert';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';
import 'package:urvitribe_main/route/screen_export.dart';

import '../../../Constants/constants.dart';
import '../../../Services/Api_Controls/api_call.dart';
import '../../../Services/models/cart_model.dart';
import '../../../User Auth/userloginscreen.dart';
import '../../../url_auth/url_utils.dart';
import '../../../utils/ColoUtile.dart';
import '../../../utils/shared_pref.dart';
import '../../../utils/payment_gateway_manager.dart';
import '../../address/views/addresslist.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = true;
  bool _isUpdatingQuantity = false;
  bool _isUpdatingQuantityadd = false;
  bool _isRemovingItem = false;
  int _updatingItemIndex = -1;
  int _removingItemIndex = -1;
  List<CartItem> cartItems = [];
  bool _isProcessingPayment = false;
  Address? selectedAddress; // Store the selected address
  CartModel cartData = CartModel(
      id: '',
      currencyCode: '',
      regionId: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      total: 0,
      subtotal: 0,
      taxTotal: 0,
      discountTotal: 0,
      discountSubtotal: 0,
      discountTaxTotal: 0,
      originalTotal: 0,
      originalTaxTotal: 0,
      itemTotal: 0,
      itemSubtotal: 0,
      itemTaxTotal: 0,
      originalItemTotal: 0,
      originalItemSubtotal: 0,
      originalItemTaxTotal: 0,
      shippingTotal: 0,
      shippingSubtotal: 0,
      shippingTaxTotal: 0,
      originalShippingTaxTotal: 0,
      originalShippingSubtotal: 0,
      originalShippingTotal: 0,
      salesChannelId: '',
      shippingAddressId: '',
      customerId: '',
      items: [],
      shippingAddress: ShippingAddress(
        id: '',
        address1: '',
        address2: '',
        city: '',
        countryCode: '',
        province: '',
        firstName: '',
        lastName: '',
        company: '',
        phone: '',
      ),
      shippingMethods: [],
      billingAddress: null,
      promotions: []);
  late Razorpay _razorpay;

  var delivertAmt = 50;
  final TextEditingController _couponController = TextEditingController();
  @override
  void initState() {
    getCartDetails();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Here you can call your order creation API
    createOrder();
    // Handle payment success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Successful: ${response.paymentId}')),
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    _couponController.dispose();
    super.dispose();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Failed: ${response.message}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External Wallet: ${response.walletName}')),
    );
  }

  Future<void> createOrder() async {
    setState(() {
      _isProcessingPayment = false;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return OrderSuccessAlert();
      },
    ).then((value) {
      SharedPrefs.setCartId('');
      SharedPrefs.setAccessToken('');
      SharedPrefs.setIsLoggedIn(false);
      setState(() {
        _isLoading = true;
        _isProcessingPayment = false;
      });
      getCartDetails();
    });
  }

  Text AmountForItem(CartItem item) {
    show_log_error("the item details are ${item.toJson()}");
    return Text(
      '₹${mFormatAmount((item.unitPrice * item.quantity).toStringAsFixed(2), amINeedDrCr: false)}',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: cartItems.isEmpty
          ? Center(child: Image.asset("assets/icons/emptybox.gif",))
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Review your order',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(height: 5),

                        // Product Items
                        ...List.generate(cartItems.length, (index) {
                          var item = cartItems[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(width: 0.5),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: _buildProductItem(
                                  'assets/images/milk_noimage.png', // You'll need to add your images

                                  null, '${cartItems[index].productTitle}',
                                  mFormatAmount(
                                      ((item.unitPrice * item.quantity)
                                          .toStringAsFixed(2)),
                                      amINeedDrCr: false),
                                  534.33,
                                ),
                              ),
                            ),
                          );
                        }),
                        // Divider(),

                        // Coupon Section
                        // Text(
                        //   'Your Coupon code',
                        //   style: Theme.of(context).textTheme.titleSmall,
                        // ),
                        // SizedBox(height: 15),

                        /* Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _couponController,
                      style: Theme.of(context).textTheme.titleSmall,
                      decoration: InputDecoration(
                        hintText: 'Type coupon code',
                        hintStyle: Theme.of(context).textTheme.titleSmall,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.local_offer_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ), */
                        SizedBox(height: 20),

                        // Order Summary
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              // color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 0.5),
                              boxShadow: [
                                /*   BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ), */
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order Summary',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              // SizedBox(height: 20),
                              SizedBox(height: 8),
                              _buildSummaryRow('Delivery Fee',
                                  '₹ ${mFormatAmount(delivertAmt.toStringAsFixed(2), amINeedDrCr: false)}',
                                  isGreen: true),
                              SizedBox(height: 5),
                              Divider(color: Colors.grey[300]),
                              SizedBox(height: 5),
                              _buildSummaryRow('Total',
                                  '₹ ${mFormatAmount(gettotalprice(cartItems), amINeedDrCr: false)}',
                                  isBold: true),
                              /* SizedBox(height: 12),
                        _buildSummaryRow('Estimated VAT', '\$1'), */
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Checkout Button
                Container(
                  padding: EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                        onPressed: () async {
                          // Handle checkout
                          {
                            if (SharedPrefs.getIsLoggedIn() == false ||
                                SharedPrefs.getAccessToken() == null ||
                                SharedPrefs.getCartId() == '') {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => const AuthScreen());
                            } else {
                             /*  var hasAddress = await checkAddress();
                              if (hasAddress == false) { */
                                var updatedTrue = false;
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                          backgroundColor: Colors.white,
                                          titlePadding: EdgeInsets.all(0),
                                          iconPadding: EdgeInsets.all(0),
                                          insetPadding: EdgeInsets.all(0),
                                          buttonPadding: EdgeInsets.all(0),
                                          actionsPadding: EdgeInsets.all(0),
                                          contentPadding: EdgeInsets.all(0),
                                          content: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child:
                                                  AddressListScreen() /* AddressesScreen(
                                                  isUpdated: () {
                                                updatedTrue = true;
                                              }) */
                                              ,
                                            ),
                                          ));
                                    }).then((v) {
                                      show_log_error('chcek receving data is   :: ${v}');
                                      
                                      if (v != null && v is Address) {
                                        Address selectedAddress = v;
                                        show_log_error('Selected Address: ${selectedAddress.title}');
                                        show_log_error('Address Details: ${selectedAddress.fullAddress}');
                                        show_log_error('City: ${selectedAddress.city}, Postal Code: ${selectedAddress.postalCode}');
                                        
                                        // Store the selected address for order processing
                                        setState(() {
                                          selectedAddress = selectedAddress;
                                        });
                                        
                                        show_log_error('Address stored successfully: ${selectedAddress.title}');
                                        
                                        // Proceed with order placement
                                        placeorder();
                                      } else {
                                        show_log_error('No address selected or invalid data received');
                                        // Show a message to user that address selection is required
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Please select an address to continue'),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                      }
                                      
                                      if (updatedTrue == true) {
                                        // This block can be removed since we're handling address selection above
                                        // placeorder();
                                      }
                                });
                              /* } else {
                                placeorder();
                              } */
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorUtile.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text('Checkout',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600))),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildProductItem(String imagePath, String? brand, String name,
      String price, double originalPrice) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.image,
                    color: Colors.grey[400],
                    size: 30,
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (brand != null)
                Text(
                  brand,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              SizedBox(height: 4),
              Text(
                name,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('₹ ${price}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: ColorUtile.primaryColor))
                  /*  SizedBox(width: 8),
                  Text('₹ ${originalPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.red,
                          fontSize: 10)), */
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isGreen = false, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.normal),
        ),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  getCartDetails() async {
    try {
      await PaymentGatewayManager.refreshPaymentConfig();
      if (cartItems.isNotEmpty) {
        setState(() {
          cartItems.clear();
        });
      }

      setState(() {
        _isLoading = true;
      });

      final response = await getCall(
          '${UrlUtils.getBaseUrl()}/store/carts/${SharedPrefs.getCartId().toString()}',
          headers2);

      if (response.statusCode == 200 || response.statusCode == 301) {
        final data = json.decode(response.body);
        var cartDatavalue = data['cart'];
        var cartItemsvalue = cartDatavalue['items'];

        for (var item in cartItemsvalue) {
          show_log_error('check item detailsis :: ${item}');
          setState(() {
            cartData.items.add(CartItem.fromJson(item));
          });
        }
        setState(() {
          cartData = CartModel.fromJson(cartDatavalue);
          cartItems = cartData.items;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        // throw Exception('Failed to load cart details');
      }
    } catch (e, stackTrace) {
      setState(() {
        _isLoading = false;
      });
      show_log_error("the error in cart screen is ${e}");
      show_log_error("the error in cart screen is stackTrace ${stackTrace}");
      /*    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      ); */
    }
  }

  String gettotalprice(List<CartItem> cartItems) {
    double total =
        cartItems.fold(0, (sum, item) => sum + item.unitPrice * item.quantity);
    total += 50; // Add delivery amount
    return total.toStringAsFixed(2);
  }

  Future<void> placeorder() async {
    if (SharedPrefs.getIsLoggedIn() == false ||
        SharedPrefs.getAccessToken() == null) {
      showModalBottomSheet(
        context: context,
        builder: (context) => const AuthScreen(),
      );
    } else {
      setState(() {
        _isProcessingPayment = true;
      });

      try {
        // Create payment options
        var options = {
          'key': SharedPrefs.getRazorpayId() ??
              'rzp_test_hTM3lEVaLnhHnX', // Use stored Razorpay ID or fallback
          'amount': (double.parse(gettotalprice(cartItems)) * 100)
              .toInt(), // Convert to paise
          'name': 'UrviTribe',
          'description': 'Payment for your order',
          'image': 'https://seller.urvitribe.life/wp-content/uploads/2024/12/Logo.jpg', // Use local asset or URL
          'prefill': {
            'contact': SharedPrefs.getPhone() ?? '', // Get from user profile
            'email': SharedPrefs.getEmail() ?? '', // Get from user profile
          },
          'theme': {
            'color': '#${ColorUtile.primaryColor.value.toRadixString(16).substring(2)}',
            'backdrop_color': '#FFFFFF', // Background color
            'hide_topbar': false, // Show/hide top bar
          },
         /*  'modal': {
            'confirm_close': true, // Confirm before closing
            'escape': false, // Disable escape key
            'handleback': true, // Handle back button
            'ondismiss': () {
              // Handle modal dismiss
              show_log_error('Payment modal dismissed');
            }
          } */
        };

        _razorpay.open(options);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isProcessingPayment = false;
        });
      }
    }
  }
}

class OrderSuccessAlert extends StatelessWidget {
  OrderSuccessAlert({Key? key}) : super(key: key);

  final String orderNumber = "#OD12345678";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        top: 42,
        right: 16,
        bottom: 16,
      ),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 10),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Success Icon
          CircleAvatar(
            backgroundColor: Colors.green.shade50,
            radius: 45,
            child: Icon(
              Icons.check_circle,
              color: Colors.green.shade600,
              size: 65,
            ),
          ),
          const SizedBox(height: 20),
          // Title
          Center(
            child: const Text(
              "Order Placed Successfully!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Order Details
          Text(
            "Your order ${orderNumber} has been placed. You will receive an order confirmation email shortly.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Delivery Info Box
          Visibility(
            visible: false,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.local_shipping_outlined,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Estimated Delivery",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Your items will be delivered in 3-5 business days",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Payment Info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.payments_outlined,
                color: Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Payment: Completed",
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // OK Button
          SizedBox(
            width: 150,
            height: 45,
            child: ElevatedButton(
              onPressed: () async {
                await SharedPrefs.setCartId('');
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorUtile.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 2,
              ),
              child: const Text(
                "OK",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
