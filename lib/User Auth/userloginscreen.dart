import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:urvitribe_main/User%20Auth/newaccount.dart';
import 'package:urvitribe_main/route/screen_export.dart';

import '../Constants/constants.dart';
import '../Services/Api_Controls/api_call.dart';
import '../url_auth/url_utils.dart';
import '../utils/ColoUtile.dart';
import '../utils/shared_pref.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignIn = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() async {
    //auth/customer/emailpass/register
    if (_formKey.currentState!.validate()) {
      // Here you would typically handle authentication logic
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
      try {
        var data = {
          'email': _emailController.text,
          'password': _passwordController.text,
        };
        final response = await postCall(
          '${UrlUtils.getBaseUrl()}/auth/customer/emailpass/register',
          headers: headers2,
          data: data,
        );
        if (response.statusCode == 200) {
          var responseData = jsonDecode(response.body);
          show_log_error(responseData.toString());
          var token = responseData['token'];
          await SharedPrefs.setAccessToken(token);
          setState(() {
            _isLoading = false;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RegisterUserScreen(
                      email: _emailController.text,
                      password: _passwordController.text)));
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
        }
      } catch (e) {
        showToast(e.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      // Here you would typically handle authentication logic
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
      try {
        var data = {
          'email': _emailController.text,
          'password': _passwordController.text,
        };

        final response = await postCall(
          '${UrlUtils.getBaseUrl()}/auth/customer/emailpass',
          headers: headers2,
          data: data,
        );

        if (response.statusCode == 200) {
          // Refresh cart data after successful removal
          var responseData = jsonDecode(response.body);
          show_log_error(responseData['token']);
          var token = responseData['token'];
          await SharedPrefs.setAccessToken(token);
          await SharedPrefs.setEmail(_emailController.text);
          await SharedPrefs.setIsLoggedIn(true);
          var hasAddress = await checkAddress();
          setState(() {
            if (hasAddress == true) {
              assigedcarttouser(token);
            } else {
              var updatedTrue = false;
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(content: AddressesScreen(isUpdated: () {
                      updatedTrue = true;
                    }));
                  }).then((v) {
                if (updatedTrue == true) {
                  assigedcarttouser(token);
                }
              });
            }
          });
          setState(() {
            _isLoading = false;
          });
          Navigator.pop(context);
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
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future assigedcarttouser(var token) async {
    try {
      var data = {};
      var headersown = {
        'Content-Type': 'application/json',
        'x-publishable-api-key': '${UrlUtils.token}',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };

      final response = await postCall(
          '${UrlUtils.getBaseUrl()}/store/carts/${SharedPrefs.getCartId()}/customer',
          headers: headersown,
          data: data);

      if (response.statusCode == 200) {
        // Refresh cart data after successful removal
        var responseData = jsonDecode(response.body);
        show_log_error(responseData['token']);
      } else if (response.statusCode == 401) {
        var responseData = jsonDecode(response.body);
        showToast(responseData['message']);
      } else {}
    } catch (e) {
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.white,
          ),
          child: SafeArea(
              child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                          key: _formKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /* Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(Icons.close)),
                                  ],
                                ),
                                const SizedBox(height: 0) ,*/
                                // User circle image
                                /*  Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ), 
                                  child: Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.blue.shade300,
                                    ),
                                  ),
                                ), */
                                const SizedBox(height: 30),
                                // Email field
                                TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                        hintText: 'Email',
                                        prefixIcon: Icon(Icons.email),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade300)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade300)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.blue))),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!RegExp(
                                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                          .hasMatch(value)) {
                                        return 'Please enter a valid email address';
                                      }
                                      return null;
                                    }),
                                const SizedBox(height: 16),

                                // Password field
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscureText,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    prefixIcon: Icon(Icons.lock),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      icon: Icon(
                                        _obscureText
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Confirm Password field (only for Sign Up)
                                /*  if (!isSignIn)
                      Column(
                        children: [
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Confirm Password',
                              prefixIcon: Icon(Icons.lock),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      ), */

                                /* // Forgot Password (only for Sign In)
                    if (isSignIn)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Forgot password logic here
                          },
                          child: const Text('Forgot Password?'),
                        ),
                      ),
                     */
                                const SizedBox(height: 30),

                                // Primary Action Button (Sign In or Sign Up)
                                SizedBox(
                                  width: double.infinity,
                                  // height: 50,
                                  child: ElevatedButton(
                                    onPressed: _submitForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorUtile.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Text('Sign In',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.apply(color: Colors.white)),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Secondary Action Button (Switch between Sign In and Sign Up)
                                SizedBox(
                                    width: double.infinity,
                                    // height: 40,
                                    child: OutlinedButton(
                                        onPressed: _toggleAuthMode,
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: ColorUtile.primaryColor),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                        ),
                                        child: Text('Create an Account',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.apply(color: Colors.black))))
                              ])))))),
    );
  }
}
