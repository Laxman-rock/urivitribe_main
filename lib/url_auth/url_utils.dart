import 'package:flutter/material.dart';

class UrlUtils {
  static const String baseUrl =
      'http://qwo4sww0kosw0sgsskkg84sw.69.62.74.230.sslip.io';
  static const String token =
      'pk_6aeeb6bb3005cf27ef176edfb5b08addd08534f8edf50a96de3c36b99bb68b8c';
  static const String regionId = 'reg_01JX3MV4J76629YZJVF719SPEN';
  static String getBaseUrl() {
    return baseUrl;
  }

  static String getCategoriesUrl() => '${getBaseUrl()}/store/product-categories';

  static String getProductsUrl() => '${getBaseUrl()}/store/products';

  static String getProductByIdUrl(String id) =>
      '${getBaseUrl()}/store/products/$id';

//create cart id
  static String getCartUrl() => '${getBaseUrl()}/store/cart'; 
  static String getStoreConfiguration() => '${getBaseUrl()}/store/configurations'; 
  static String updateCustomersAddress() => '${getBaseUrl()}/store/customers/me/addresses'; 
  static String updateAddressAPI() => '${getBaseUrl()}/store/customers/me/addresses'; 
  static String getCustomers() => '${getBaseUrl()}/store/customers/me'; 

  //get cart details
  static String getCartByIdUrl(String id) => '${getBaseUrl()}/store/carts';

  //Assign cart to user
  static String getAddProductToCartUrl() => '${getBaseUrl()}/store/carts';
  static String banners() => '${getBaseUrl()}/store/banners';

  //Register customer
  static String getRegisterCustomerUrl() => '${getBaseUrl()}/store/customers';
}
