import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpManager {
  static Utf8Decoder utf8decoder = const Utf8Decoder();

  static void getData(String url,
      {Map<String, String>? headers,
      Function? success,
      Function? fail,
      Function? complete}) async {
    try {
      var response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        // 解析 json 字符串，返回的是 Map<String, dynamic> 类型
        var result = json.decode(utf8decoder.convert(response.bodyBytes));
        success!(result);
      } else {
        throw Exception('"Request failed with status: ${response.statusCode}"');
      }
    } catch (e) {
      fail!(e);
    } finally {
      if (complete != null) {
        complete();
      }
    }
  }

  static Future requestData(String url, {Map<String, String>? headers}) async {
    try {
      var response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var result = json.decode(utf8decoder.convert(response.bodyBytes));
        return result;
      } else {
        throw Exception('"Request failed with status: ${response.statusCode}"');
      }
    } catch (e) {
      Future.error(e);
    }
  }
}
