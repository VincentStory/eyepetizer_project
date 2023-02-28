import 'package:flutter/cupertino.dart';

import '../widget/loading_state_widget.dart';

class BaseChangeNotifier extends ChangeNotifier {
  // 页面销毁则不发送通知
  bool _dispose = false;

  ViewState viewState = ViewState.loading;

  @override
  void dispose() {
    super.dispose();
    _dispose = true;
  }

  // 报错：_debugAssertNotDisposed() --》
  // https://github.com/rrousselGit/provider/issues/78
  @override
  void notifyListeners() {
    if (!_dispose) {
      super.notifyListeners();
    }
  }
}
