import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:urvitribe_main/Services/Api_Controls/api_call.dart';

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
                      title: item["title"] ?? '',
                      fullAddress: item["fullAddress"] ?? '',
                      phoneNumber: item["phoneNumber"] ?? '',
                      isHome: item["isHome"] ?? false,
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
                                child: AddressesScreen(isUpdated: () {
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
                    child: AddressCard(
                      address: address,
                      onEdit: () => _editAddress(address),
                      onDelete: () => _deleteAddress(address.id),
                    ),
                  );
                },
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
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AddressCard({
    Key? key,
    required this.address,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: address.isHome ? Colors.blue[200]! : Colors.grey[200]!,
          width: address.isHome ? 1.5 : 1,
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
                  color: address.isHome ? Colors.blue[50] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  address.isHome
                      ? Icons.home_outlined
                      : Icons.business_outlined,
                  color: address.isHome ? Colors.blue : Colors.grey[600],
                  size: 15,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(address.title,
                    style: Theme.of(context).textTheme.titleSmall),
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
          Text(address.phoneNumber,
              style: Theme.of(context).textTheme.bodySmall)
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

  Address({
    required this.id,
    required this.title,
    required this.fullAddress,
    required this.phoneNumber,
    required this.isHome,
  });
}
