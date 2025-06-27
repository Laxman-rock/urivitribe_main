import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:urvitribe_main/Services/Api_Controls/api_call.dart';
import 'package:urvitribe_main/components/buy_full_ui_kit.dart';

import 'package:flutter/material.dart';
import 'package:urvitribe_main/utils/ColoUtile.dart';
import 'package:urvitribe_main/utils/shared_pref.dart';

import '../../../Constants/constants.dart';
import '../../../url_auth/url_utils.dart';

class AddressesScreen extends StatefulWidget {
  Function()? isUpdated;
  AddressesScreen({this.isUpdated});

  @override
  _AddressesScreenState createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _useCurrentLocation = false;
  bool _setAsDefault = true;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _poBoxController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'New address',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Address Title
                    _buildTextField(
                      controller: _titleController,
                      hintText: 'Type address title',
                      prefixIcon: Icons.location_on_outlined,
                    ),
                    SizedBox(height: 16),

                    // Use Current Location
                    /*  Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.purple[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.my_location,
                              color: Colors.purple,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Use my current location',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Jure Novakouska, Zabrnice',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    ), */

                    // Country/Region
                    _buildTextField(
                      controller: _countryController,
                      hintText: 'Country/Region',
                      prefixIcon: Icons.public,
                    ),
                    SizedBox(height: 16),

                    // Full Name
                    _buildTextField(
                      controller: _fullNameController,
                      hintText: 'Full name',
                      prefixIcon: Icons.person_outline,
                    ),
                    SizedBox(height: 16),

                    // Address Line 1
                    _buildTextField(
                      controller: _addressLine1Controller,
                      hintText: 'Address line 1',
                    ),
                    SizedBox(height: 16),

                    // Address Line 2
                    _buildTextField(
                      controller: _addressLine2Controller,
                      hintText: 'Address line 2',
                    ),
                    SizedBox(height: 16),

                    // City
                    _buildTextField(
                      controller: _cityController,
                      hintText: 'City',
                    ),
                    SizedBox(height: 16),

                    // State
                    _buildTextField(
                      controller: _stateController,
                      hintText: 'State',
                    ),
                    SizedBox(height: 16),

                    // Zip Code
                    _buildTextField(
                      controller: _zipCodeController,
                      hintText: 'Zip code',
                    ),
                    SizedBox(height: 16),

                    // Phone Number
                    _buildTextField(
                      controller: _phoneController,
                      hintText: 'Phone number',
                      prefixIcon: Icons.phone_outlined,
                      prefixText: '+1',
                    ),
                    SizedBox(height: 24),

                    // Set as Default Toggle
                    /*  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Set default address',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Switch(
                          value: _setAsDefault,
                          onChanged: (value) {
                            setState(() {
                              _setAsDefault = value;
                            });
                          },
                          activeColor: Colors.purple,
                        ),
                      ],
                    ), */
                    SizedBox(height: 100), // Space for the button
                  ],
                ),
              ),
            ),

            // Save Button
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                    await updateAddress();

                    widget.isUpdated?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorUtile.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Save address',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    String? prefixText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: TextFormField(
          controller: controller,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: hintText,

            hintStyle: Theme.of(context).textTheme.titleSmall,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: Colors.black, size: 20)
                : null,
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: Colors.black, size: 20)
                : null,
            prefixText: prefixText,
            prefixStyle: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: prefixIcon != null ? 8 : 16,
              vertical: 5,
            ),
          ),
          style: Theme.of(context).textTheme.titleSmall),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _countryController.dispose();
    _fullNameController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _poBoxController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  updateAddress() async {
    final addressData = {
      "address_1": _addressLine1Controller.text,
      "address_2": _addressLine2Controller.text,
      "city": _cityController.text,
      "country_code": "IN",
      "province": _stateController.text,
      "postal_code": _zipCodeController.text,
      "address_name": _fullNameController.text,
    };

    try {
      SharedPrefs.instance.setString("addressInfo", jsonEncode(addressData));
      var response = await postCall(UrlUtils.updateAddressAPI(),
          data: addressData, headers: headers3);
    } catch (e) {
      // Handle error, e.g., show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update address: $e')),
      );
    }
  }
}
