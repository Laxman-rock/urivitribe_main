import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:urvitribe_main/Services/Api_Controls/api_call.dart';
import 'package:urvitribe_main/constants.dart';

import '../../../Constants/constants.dart';
import '../../../url_auth/url_utils.dart';
import 'addresses_screen.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({Key? key}) : super(key: key);

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  @override
  void initState() {
    getAddressList();
    super.initState();
    // You can perform any initialization here if needed
  }

  List<Address> addresses = [];
  Address? selectedAddress; // Store the selected address
  getAddressList() async {
    // Example: Fetch addresses from API and assign to addresses list
    // Replace this with your actual API call and parsing logic
    // Here is a mockup using your checkAddress and Address model

    // If you want to use checkAddress to determine if addresses exist:
    {
      {
        // Example: Fetch customer data and parse addresses
        var response = await getCall(UrlUtils.getCustomers(), headers3);
        if (response.statusCode >= 200 && response.statusCode < 300) {
          var body = jsonDecode(response.body)["customer"];
          var addressList = body["addresses"] as List<dynamic>;
          setState(() {
            addresses = [];
            addresses = addressList
                .map((item) => Address(
                      id: item["id"].toString(),
                      title: item["address_name"] ?? '',
                      fullAddress: "${item["address_1"]} \n ${item["address_2"] ?? ''}" ?? '',
                      phoneNumber: item["phone"] ?? '',
                      isHome: item["isHome"] ?? false,
                      isDefaultShipping: item["is_default_shipping"] ?? false,
                      isDefaultBilling: item["is_default_billing"] ?? false,
                      company: item["company"],
                      firstName: item["first_name"],
                      lastName: item["last_name"],
                      address1: item["address_1"] ?? '',
                      address2: item["address_2"],
                      city: item["city"] ?? '',
                      countryCode: item["country_code"] ?? '',
                      province: item["province"] ?? '',
                      postalCode: item["postal_code"] ?? '',
                      phone: item["phone"],
                      metadata: item["metadata"],
                      customerId: item["customer_id"] ?? '',
                      createdAt: item["created_at"] ?? '',
                      updatedAt: item["updated_at"] ?? '',
                      deletedAt: item["deleted_at"],
                    ))
                .toList();
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[50],
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Addresses',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Handle menu action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Add new address button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: InkWell(
                onTap: () {
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
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: AddressesScreen(
                                  isUpdated: () {
                                  updatedTrue = true;
                                }),
                              ),
                            ));
                      }).then((v) {
                    if (updatedTrue == true) {
                      getAddressList();
                    }
                  });
                },
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add_location_outlined,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Add new address',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Address list
            Expanded(
              child: ListView.builder(
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () {
                        // Select the address and highlight it
                        setState(() {
                          selectedAddress = address;
                        });
                        show_log_error('Address selected: ${address.title}');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.transparent,
                        ),
                        child: AddressCard(
                          address: address,
                          isSelected: selectedAddress?.id == address.id,
                          onEdit: () => _editAddress(address),
                          onDelete: () => _deleteAddress(address.id),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Proceed Payment Button
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Handle proceed payment
                  if (selectedAddress != null) {
                    show_log_error('Proceed Payment with selected address: ${selectedAddress!.title}');
                    Navigator.pop(context, selectedAddress);
                  } else {
                    // Show message to select an address first
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please select an address first'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Proceed Payment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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

  void _showAddAddressDialog() {
    // Implement add address dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Address'),
        content:
            const Text('Add address functionality would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editAddress(Address address) {
    // Implement edit address functionality
    print('Edit address: ${address.title}');
  }

  void _deleteAddress(String addressId) {
    setState(() {
      addresses.removeWhere((address) => address.id == addressId);
    });
  }
}

class AddressCard extends StatelessWidget {
  final Address address;
  final bool isSelected;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AddressCard({
    Key? key,
    required this.address,
    this.isSelected = false,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue[50] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected 
              ? Colors.blue[400]! 
              : (address.isHome ? Colors.blue[200]! : Colors.grey[200]!),
          width: isSelected ? 2.0 : (address.isHome ? 1.5 : 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Colors.blue[100] 
                      : (address.isHome ? Colors.blue[50] : Colors.grey[100]),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isSelected 
                      ? Icons.check_circle
                      : (address.isHome ? Icons.home_outlined : Icons.business_outlined),
                  color: isSelected 
                      ? Colors.blue[600] 
                      : (address.isHome ? Colors.blue : Colors.grey[600]),
                  size: isSelected ? 18 : 15,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  address.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.blue[700] : null,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(address.fullAddress,
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 5),
          Text('${address.city} - ${address.postalCode}',
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 5),
          Text('${address.province}',
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 5),
          Text(address.countryCode,
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class Address {
  final String id;
  final String title;
  final String fullAddress;
  final String phoneNumber;
  final bool isHome;
  final bool isDefaultShipping;
  final bool isDefaultBilling;
  final String? company;
  final String? firstName;
  final String? lastName;
  final String address1;
  final String? address2;
  final String city;
  final String countryCode;
  final String province;
  final String postalCode;
  final String? phone;
  final String? metadata;
  final String customerId;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  Address({
    required this.id,
    required this.title,
    required this.fullAddress,
    required this.phoneNumber,
    required this.isHome,
    required this.isDefaultShipping,
    required this.isDefaultBilling,
    this.company,
    this.firstName,
    this.lastName,
    required this.address1,
    this.address2,
    required this.city,
    required this.countryCode,
    required this.province,
    required this.postalCode,
    this.phone,
    this.metadata,
    required this.customerId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
}
