//通用分页State封装
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../model/paging_model.dart';
import '../viewmodel/base_list_viewmodel.dart';
import '../widget/loading_state_widget.dart';
import '../widget/provide_widget.dart';

/// State
abstract class BaseListState<L, M extends BaseListViewModel<L, PagingModel<L>>,
        T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {

  M get viewModel; //真实获取数据的仓库

  Widget getContentChild(M model); //真实的分页控件

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<M>(
        model: viewModel,
        onModelInit: (model) => model.refresh(),
        builder: (context, model, child) {
          return LoadingStateWidget(
            viewState: model.viewState,
            retry: model.retry,
            child: Container(
              color: Colors.white,
              child: SmartRefresher(
                controller: model.refreshController,
                onRefresh: model.refresh,
                onLoading: model.loadMore,
                enablePullUp: true,
                // 显示的界面
                child: getContentChild(model),
              ),
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
