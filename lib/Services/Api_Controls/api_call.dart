import 'dart:convert';

// import 'dart:io';

import 'package:http/http.dart' as http;


import '../../Constants/constants.dart'; 
// import 'package:whynot/utils/app_utils.dart';
 

Future<http.Response> postCall(String url, {required var data, required Map<String, String> headers}) async {
  show_log_error('Api POST URL: $url data: ${jsonEncode(data)} headers: $headers');
  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: data == null ? null : json.encode(data),
  );
  if (response.statusCode >= 200 && response.statusCode < 300) {
    show_log_error(
        'Api POST Response URL: $url code: ${response.statusCode} response: ${response.body}');
  } else {
    show_log_error(
        'Api POST Response URL: 1 $url code: ${response.statusCode} response: ${response.body}');
  }
  return response;
}

Future<http.Response> putCall(String url, data, headers) async {
  show_log_error('Api PUT URL: $url data: ${jsonEncode(data)} headers: $headers');
  final response = await http.put(
    Uri.parse(url),
    headers: headers,
    body: json.encode(data),
  );
  show_log_error('Api PUT Response URL: $url code: ${response.statusCode} response: ${response.body}');
  return response;
}

Future<http.Response> getCall(String url, headers) async {
  show_log_error('Api GET URL: $url headers: $headers');
  final response = await http.get(
    Uri.parse(url),
    headers: headers,
  );
  show_log_error('Api GET Response URL: $url code: ${response.statusCode} response: ${response.body}');
  return response;
}

deleteCall(String url, headers) async {
  show_log_error('Api DELETE URL: $url headers: $headers');
  final response = await http.delete(
    Uri.parse(url),
    headers: headers,
  );
  show_log_error('Api DELETE Response URL: $url code: ${response.statusCode} response: ${response.body}');
  return response;
}

deleteCall2(String url, headers, body) async {
  show_log_error('Api DELETE URL: $url headers: $headers');
  final response = await http.delete(Uri.parse(url),
      headers: headers, body: json.encode(body));
  show_log_error('Api DELETE Response URL: $url code: ${response.statusCode} response: ${response.body}');
  return response;
}
