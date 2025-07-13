import 'dart:convert';
import 'package:urvitribe_main/Services/Api_Controls/api_call.dart';
import 'package:urvitribe_main/url_auth/url_utils.dart';
import 'package:urvitribe_main/utils/shared_pref.dart';
import 'package:urvitribe_main/Constants/constants.dart';

class PaymentGatewayManager {
  static const String _configsKey = "configs";
  
  /// Clear all stored payment gateway configuration
  static Future<bool> clearPaymentConfig() async {
    try {
      await SharedPrefs.clearRazorpayConfig();
      await SharedPrefs.instance.remove(_configsKey);
      return true;
    } catch (e) {
      print("Error clearing payment config: $e");
      return false;
    }
  }
  
  /// Refresh payment gateway configuration from server
  static Future<bool> refreshPaymentConfig() async {
    try {
      final response = await getCall('${UrlUtils.getStoreConfiguration()}', headers2);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var configData = jsonDecode(response.body);
        
        // Store the entire configs
        await SharedPrefs.instance.setString(_configsKey, jsonEncode(configData["config"]));
        
        // Extract and store Razorpay configuration
        if (configData["configs"] != null && configData["configs"].isNotEmpty) {
          var defaultConfig = configData["configs"][0]; // Get the first config (default)
          if (defaultConfig["config"] != null) {
            var razorpayConfig = defaultConfig["config"];
            
            // Store Razorpay configuration
            await SharedPrefs.setRazorpayId(razorpayConfig["RAZORPAY_ID"] ?? "");
            await SharedPrefs.setRazorpaySecret(razorpayConfig["RAZORPAY_SECRET"] ?? "");
            await SharedPrefs.setRazorpayAccount(razorpayConfig["RAZORPAY_ACCOUNT"] ?? "");
            await SharedPrefs.setRazorpayWebhookSecret(razorpayConfig["RAZORPAY_WEBHOOK_SECRET"] ?? "");
            
            print("Payment gateway configuration refreshed successfully");
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      print("Error refreshing payment config: $e");
      return false;
    }
  }
  
  /// Get current payment gateway configuration
  static Map<String, String?> getCurrentConfig() {
    return {
      'razorpayId': SharedPrefs.getRazorpayId(),
      'razorpaySecret': SharedPrefs.getRazorpaySecret(),
      'razorpayAccount': SharedPrefs.getRazorpayAccount(),
      'razorpayWebhookSecret': SharedPrefs.getRazorpayWebhookSecret(),
    };
  }
  
  /// Check if payment configuration is loaded
  static bool isConfigLoaded() {
    return SharedPrefs.getRazorpayId() != null && 
           SharedPrefs.getRazorpayId()!.isNotEmpty;
  }
  
  /// Switch to a specific configuration profile (if multiple configs are available)
  static Future<bool> switchToProfile(String profileName) async {
    try {
      final response = await getCall('${UrlUtils.getStoreConfiguration()}', headers2);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var configData = jsonDecode(response.body);
        
        if (configData["configs"] != null) {
          // Find the specific profile
          var targetConfig = configData["configs"].firstWhere(
            (config) => config["name"] == profileName,
            orElse: () => null,
          );
          
          if (targetConfig != null && targetConfig["config"] != null) {
            var razorpayConfig = targetConfig["config"];
            
            // Store the new configuration
            await SharedPrefs.setRazorpayId(razorpayConfig["RAZORPAY_ID"] ?? "");
            await SharedPrefs.setRazorpaySecret(razorpayConfig["RAZORPAY_SECRET"] ?? "");
            await SharedPrefs.setRazorpayAccount(razorpayConfig["RAZORPAY_ACCOUNT"] ?? "");
            await SharedPrefs.setRazorpayWebhookSecret(razorpayConfig["RAZORPAY_WEBHOOK_SECRET"] ?? "");
            
            print("Switched to profile: $profileName");
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      print("Error switching profile: $e");
      return false;
    }
  }
  
  /// Refresh configuration with retry mechanism
  static Future<bool> refreshPaymentConfigWithRetry({int maxRetries = 3}) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        bool success = await refreshPaymentConfig();
        if (success) {
          return true;
        }
        // Wait before retry
        await Future.delayed(Duration(seconds: 2 * (i + 1)));
      } catch (e) {
        print("Retry $i failed: $e");
        if (i == maxRetries - 1) {
          return false;
        }
      }
    }
    return false;
  }
} 