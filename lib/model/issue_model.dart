
import 'package:eyepetizer_project/model/common_item.dart';
import 'package:eyepetizer_project/model/paging_model.dart';

class IssueEntity extends PagingModel<Item> {
  int? nextPublishTime;
  String? newestIssueType;
  List<Issue>? issueList;

  IssueEntity({this.nextPublishTime, this.newestIssueType});

  IssueEntity.fromJson(Map<String, dynamic> json) {
    nextPublishTime = json['nextPublishTime'];
    newestIssueType = json['newestIssueType'];
    nextPageUrl = json['nextPageUrl'];
    if (json['issueList'] != null) {
      issueList = [];
      itemList = [];
      (json['issueList'] as List).forEach((v) {
        issueList?.add(new Issue.fromJson(v));
      });
      itemList = issueList?[0].itemList;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nextPublishTime'] = this.nextPublishTime;
    data['newestIssueType'] = this.newestIssueType;
    data['nextPageUrl'] = this.nextPageUrl;
    final issueList = this.issueList;
    if (issueList != null) {
      data['issueList'] = issueList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}