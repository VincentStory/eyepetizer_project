import 'package:eyepetizer_project/viewmodel/base_list_viewmodel.dart';

import '../http/Url.dart';
import '../model/common_item.dart';
import '../model/issue_model.dart';

class HomePageViewModel extends BaseListViewModel<Item, IssueEntity> {
  List<Item> bannerList = [];

  @override
  String getUrl() => Url.feedUrl;

  @override
  IssueEntity getModel(Map<String, dynamic> json) => IssueEntity.fromJson(json);

  @override
  void getData(List<Item>? list) {
    bannerList = list!;
    itemList?.clear();
    itemList?.add(Item());
  }

  @override
  void removeUselessData(List<Item>? list) {
    list?.removeWhere((element) => element.type == "banner2");
  }

  @override
  void doExtraAfterRefresh() async {
    await loadMore();
  }
}
