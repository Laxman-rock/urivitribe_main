import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:urvitribe_main/route/screen_export.dart';

import '../Constants/constants.dart';
import '../Services/Api_Controls/api_call.dart';
import '../url_auth/url_utils.dart';
import '../utils/ColoUtile.dart';
import '../utils/shared_pref.dart'; 
class RegisterUserScreen extends StatefulWidget {
  final String email;
  final String password;
  const RegisterUserScreen(
      {Key? key, required this.email, required this.password})
      : super(key: key);

  @override
  _RegisterUserScreenState createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers for form fields
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _companyNameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      // Form is valid, process registration
      final userData = {
        "email": widget.email,
        "company_name": _companyNameController.text.toString(),
        "first_name": _firstNameController.text.toString(),
        "last_name": _lastNameController.text.toString(),
        "phone": _phoneController.text.toString(),
        'metadata': {}
      };

      final response = await postCall(
        '${UrlUtils.getBaseUrl()}/store/customers',
        headers: headers3,
        data: userData,
      );
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        show_log_error(responseData.toString());
        await SharedPrefs.setEmail(widget.email);
        await SharedPrefs.setIsLoggedIn(true);
        await assigedcarttouser();
      } else if (response.statusCode == 401) {
        var responseData = jsonDecode(response.body);
        showToast(responseData['message']);
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        show_log_error(response.body);
      }
    }
  }

  Future assigedcarttouser() async {
    try {
      var data = {};

      final response = await postCall(
          '${UrlUtils.getBaseUrl()}/store/carts/${SharedPrefs.getCartId()}/customer',
          headers: headers3,
          data: data);
      if (response.statusCode == 200) {
        // Refresh cart data after successful removal
        var hasAddress = await checkAddress();
        if (hasAddress == false) {
          var updatedTrue = false;
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    titlePadding: EdgeInsets.all(0),
                    iconPadding: EdgeInsets.all(0),
                    insetPadding: EdgeInsets.all(10),
                    buttonPadding: EdgeInsets.all(0),
                    actionsPadding: EdgeInsets.all(0),
                    contentPadding: EdgeInsets.all(0),
                    content: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: AddressesScreen(/* isUpdated: () {
                          updatedTrue = true;
                        } */),
                      ),
                    ));
              }).then((v) {
            if (updatedTrue == true) {
              setState(() {
                _isLoading = false;
              });
              Navigator.pop(context);
              Navigator.pop(context);
            } else {
              setState(() {
                _isLoading = false;
              });
              Navigator.pop(context);
              Navigator.pop(context);
            }
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          Navigator.pop(context);
          Navigator.pop(context);
        }
      } else if (response.statusCode == 401) {
        // var responseData = jsonDecode(response.body);
        // showToast(responseData['message']);
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
        Navigator.pop(context);
      } else {}
    } catch (e) {
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Register User'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'Create Your Account',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                    Text(
                    'Please fill in all required fields',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 12),
                  // Company Name field
                  _buildLabel('Company Name'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _companyNameController,
                    textInputAction: TextInputAction.next,
                      style: Theme.of(context).textTheme.titleSmall,
                    decoration: InputDecoration(
                        hintStyle: Theme.of(context).textTheme.titleSmall,
                      hintText: 'Enter company name',
                      prefixIcon: const Icon(Icons.business),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter company name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // First Name field
                  _buildLabel('First Name'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _firstNameController,
                    textInputAction: TextInputAction.next,  style: Theme.of(context).textTheme.titleSmall,
                    decoration: InputDecoration(
                      hintText: 'Enter first name',
                      hintStyle: Theme.of(context).textTheme.titleSmall,
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Last Name field
                  _buildLabel('Last Name'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _lastNameController,
                    textInputAction: TextInputAction.next,
                      style: Theme.of(context).textTheme.titleSmall,
                    decoration: InputDecoration(
                      hintStyle: Theme.of(context).textTheme.titleSmall,
                      hintText: 'Enter last name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Phone field
                  _buildLabel('Phone Number'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    textInputAction: TextInputAction.done,
                      style: Theme.of(context).textTheme.titleSmall,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Enter phone number',hintStyle: Theme.of(context).textTheme.titleSmall,
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone number';
                      }
                      if (value.length < 10) {
                        return 'Phone number must be at least 10 digits';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 40),
                  // Proceed Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorUtile.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Register',
                               style: Theme.of(context).textTheme.titleSmall?.apply(color: Colors.white)
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Row(
      children: [
        Text(
          text,
             style: Theme.of(context).textTheme.titleSmall,
        ),
        const Text(
          ' *',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
