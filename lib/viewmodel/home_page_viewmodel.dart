import 'dart:convert';


import '../http/Url.dart';
import '../http/http_manager.dart';
import '../model/common_item.dart';
import '../model/issue_model.dart';
import '../utils/toast_util.dart';
import '../widget/loading_state_widget.dart';
import 'base_change_notifier.dart';

class HomePageViewModel extends BaseChangeNotifier {
  List<Item> bannerList = [];

  void refresh() {
    HttpManager.getData(
      Url.feedUrl,
      success: (json) {
        IssueEntity model = IssueEntity.fromJson(json);
        bannerList = model.itemList!;
        bannerList.removeWhere((element) => element.type == "banner2");
        viewState = ViewState.done;
      },
      fail: (e) {
        LeoToast.showError(e.toString());
      },
      complete: () => notifyListeners(),
    );
  }

  //错误重试
  retry() {
    viewState = ViewState.loading;
    notifyListeners();
    refresh();
  }
}
