import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const _kAccessToken = 'accessToken';
  static const _kFirebaseAccessToken = 'firebaseAccessToken';
  static const _kPinCode = 'pinCode';
  static const _kLanguageCode = 'language_code';
  static const _kLanguageCode2 = 'languagecode'; 
  static const _kCheckLogin = 'checkLogin';
  static const _kUserId = 'userId';
  static const _kDOB = 'dob'; 
  static const _kCartId = 'cartId'; 
  static const _kEmail = 'email';
  static const _kPhone = 'phone';
  static const _kRazorpayId = 'razorpayId';
  static const _kRazorpaySecret = 'razorpaySecret';
  static const _kRazorpayAccount = 'razorpayAccount';
  static const _kRazorpayWebhookSecret = 'razorpayWebhookSecret';

  static SharedPreferences? _instance;

  static const List<dynamic> countrydata = [];

  static Future<void> init() async {
    _instance ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences get instance {
    if (_instance == null) {
      throw Exception(
          "SharedPrefs not initialized. Call SharedPrefs.init() first.");
    }
    return _instance!;
  }

  static Future<bool> setAccessToken(String value) =>
      instance.setString(_kAccessToken, value);
  static Future<bool> setFirebaseAccessToken(String value) =>
      instance.setString(_kFirebaseAccessToken, value);
  static Future<bool> setUserId(String value) =>
      instance.setString(_kUserId, value);
  static Future<bool> setDOB(String value) => instance.setString(_kDOB, value);
  static Future<bool> setPinCode(String value) =>
      instance.setString(_kPinCode, value);
  static Future<bool> setLanguageCode(String value) =>
      instance.setString(_kLanguageCode, value);
  static Future<bool> setLanguageCodesecondary(String value) =>
      instance.setString(_kLanguageCode2, value);
  static Future<bool> setIsLoggedIn(bool value) =>
      instance.setBool(_kCheckLogin, value);
  static Future<bool> setCartId(String value) =>
      instance.setString(_kCartId, value); 
  static Future<bool> setEmail(String value) =>
      instance.setString(_kEmail, value);
  static Future<bool> setPhone(String value) =>
      instance.setString(_kPhone, value);
  
  // Razorpay configuration methods
  static Future<bool> setRazorpayId(String value) =>
      instance.setString(_kRazorpayId, value);
  static Future<bool> setRazorpaySecret(String value) =>
      instance.setString(_kRazorpaySecret, value);
  static Future<bool> setRazorpayAccount(String value) =>
      instance.setString(_kRazorpayAccount, value);
  static Future<bool> setRazorpayWebhookSecret(String value) =>
      instance.setString(_kRazorpayWebhookSecret, value);
  
  static String? getAccessToken() => instance.getString(_kAccessToken);
  static String? getFirebaseAccessToken() =>
      instance.getString(_kFirebaseAccessToken);
  static String? getUserId() => instance.getString(_kUserId);
  static String? getDOB() => instance.getString(_kDOB);
  static String? getPinCode() => instance.getString(_kPinCode);
  static bool? getIsLoggedIn() => instance.getBool(_kCheckLogin);
  static String? getLanguageCode() => instance.getString(_kLanguageCode);
    static String? getLanguageCode2() => instance.getString(_kLanguageCode2); 
  static String? getCartId() => instance.getString(_kCartId); 
  static String? getEmail() => instance.getString(_kEmail);
  static String? getPhone() => instance.getString(_kPhone);
  
  // Razorpay configuration getters
  static String? getRazorpayId() => instance.getString(_kRazorpayId);
  static String? getRazorpaySecret() => instance.getString(_kRazorpaySecret);
  static String? getRazorpayAccount() => instance.getString(_kRazorpayAccount);
  static String? getRazorpayWebhookSecret() => instance.getString(_kRazorpayWebhookSecret);
  
  // Clear Razorpay configuration
  static Future<bool> clearRazorpayConfig() async {
    await instance.remove(_kRazorpayId);
    await instance.remove(_kRazorpaySecret);
    await instance.remove(_kRazorpayAccount);
    await instance.remove(_kRazorpayWebhookSecret);
    return true;
  }
}
