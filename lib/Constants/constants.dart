import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';

import '../Services/Api_Controls/api_call.dart';
import '../url_auth/url_utils.dart';
import '../utils/shared_pref.dart';

show_log_error(String message) {
  log(message);
}

show_log_info(String message) {
  print(message);
}

showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
  );
}

var headers = {
  HttpHeaders.contentTypeHeader: 'application/json',
  'Accept': 'application/json',
};

var headers2 = {
  'x-publishable-api-key': '${UrlUtils.token}',
  'Accept': 'application/json',
  'Content-Type': 'application/json',
};

var headers3 = {
  'Content-Type': 'application/json',
  'x-publishable-api-key': '${UrlUtils.token}',
  'Accept': 'application/json',
  'Authorization': 'Bearer ${SharedPrefs.getAccessToken()}'
};

// const kPrimar
//Amount Format
String mFormatAmount(var mAmt, {bool amINeedDrCr = true}) {
  String mValue = "0";
  var format = NumberFormat.currency(locale: 'hi', decimalDigits: 2);
  try {
    if (mAmt != null && !mAmt.isEmpty) {
      if (mAmt.startsWith("-")) {
        mAmt = mAmt.replaceAll("-", "");
        if (mAmt.contains('.')) {
          var splitter = mAmt.split('.');
          if (splitter[1].toString() == ("00") ||
              splitter[1].toString() == ("0") ||
              splitter[1].toString() == ("")) {
            mValue = splitter[0].toString() + (amINeedDrCr ? ' Dr' : "");
          } else {
            mValue = fmt(splitter[0].toString(), splitter[1].toString()) +
                (amINeedDrCr ? ' Dr' : "");
          }
          ;
        } else {
          mValue = fmt(mAmt, "") + (amINeedDrCr ? ' Dr' : '');
        }
      } else {
        if (mAmt.contains('.')) {
          var splitter = mAmt.split('.');
          print("splitter[1] is $mAmt ${splitter[1]}");
          if (splitter[1].toString() == ("00") ||
              splitter[1].toString() == ("0") ||
              splitter[1].toString() == ("")) {
            mValue = splitter[0].toString() + (amINeedDrCr ? ' Cr' : "");
          } else {
            mValue = fmt(splitter[0].toString(), splitter[1].toString()) +
                (amINeedDrCr ? ' Cr' : "");
          }
        } else {
          mValue = fmt(mAmt, "") + (amINeedDrCr ? ' Cr' : "");
        }
      }
    }
  } catch (e) {
    //show_log_error('error in formate $e');
  }
  print("mValue is ${mValue}");
  return mValue;
}

String moneyFormat(String price) {
  final oCcy = new NumberFormat("##,##,##,##0.00", "hi");
  return oCcy.format(double.parse(price));
}

String fmt(String prefix, String suffix) {
  return moneyFormat(prefix + '.' + suffix);
}

checkAddress() async {
  try {
    var isExist = SharedPrefs.instance.getString("addressInfo");
    show_log_error("isExist is ${isExist}");

    if (isExist != null) {
      return true;
    }
    var response = await getCall(UrlUtils.getCustomers(), headers3);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var body = jsonDecode(response.body)["customer"];
      show_log_error("the response for customer is ${UrlUtils.getCustomers()}");
      show_log_error("the response for customer is ${body["addresses"]}");
      if (body["addresses"] == []) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  } catch (E) {
    return false;
  }
}
