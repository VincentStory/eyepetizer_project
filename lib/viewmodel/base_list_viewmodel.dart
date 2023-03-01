import 'dart:convert';
import 'dart:math';

import 'package:eyepetizer_project/model/paging_model.dart';
import 'package:eyepetizer_project/utils/toast_util.dart';
import 'package:eyepetizer_project/viewmodel/base_change_notifier.dart';
import 'package:eyepetizer_project/widget/loading_state_widget.dart';

import '../http/http_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class BaseListViewModel<T, M extends PagingModel<T>>
    extends BaseChangeNotifier {
  List<T>? itemList = [];

  //请求数据
  String getUrl();

  String? nextPageUrl;

  //请求返回的真实数据模型
  M getModel(Map<String, dynamic> json);

  void getData(List<T>? list) {
    itemList = list;
  }

  //移除无用数据
  void removeUselessData(List<T>? list);

  //上拉加载更多数据
  String? getNextUrl(M model) {
    return model.nextPageUrl;
  }

  void doExtraAfterRefresh(){}

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void refresh() {
    HttpManager.getData(
      getUrl(),
      success: (json) {
        M model = getModel(json);
        removeUselessData(model.itemList);
        getData(model.itemList);
        viewState = ViewState.done;

        nextPageUrl = getNextUrl(model);
        refreshController.refreshCompleted();
        refreshController.footerMode?.value = LoadStatus.canLoading;
        doExtraAfterRefresh();
      },
      fail: (e) {
        ToastUtil.showError(e.toString());
      },
      complete: () => notifyListeners(),
    );
  }

  Future<void> loadMore() async {
    if (nextPageUrl == null) {
      refreshController.loadNoData();
    }
    HttpManager.getData(nextPageUrl!, success: (json) {
      M model = getModel(json);
      removeUselessData(model.itemList);
      itemList?.addAll(model.itemList!);
      nextPageUrl = getNextUrl(model);
      refreshController.loadComplete();
      notifyListeners();
    }, fail: (e) {
      ToastUtil.showError(e.toString());
      refreshController.loadFailed();
    });
  }

  //错误重试
  retry() {
    viewState = ViewState.loading;
    notifyListeners();
    refresh();
  }
}
