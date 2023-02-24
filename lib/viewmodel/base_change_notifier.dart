import 'package:flutter/cupertino.dart';

class BaseChangeNotifier extends ChangeNotifier {
  //页面销毁不发送通知
  bool _dispost = false;

  @override
  void dispose() {
    super.dispose();
    _dispost = true;
  }

  @override
  void notifyListeners() {
    if (_dispost) {
      super.notifyListeners();
    }
  }
}
