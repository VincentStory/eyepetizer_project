import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../viewmodel/home_page_viewmodel.dart';
import '../../widget/banner_widget.dart';
import '../../widget/loading_state_widget.dart';
import '../../widget/provide_widget.dart';

class HomeBodyPage extends StatefulWidget {
  const HomeBodyPage({Key? key}) : super(key: key);

  @override
  State<HomeBodyPage> createState() => _HomeBodyPageState();
}

class _HomeBodyPageState extends State<HomeBodyPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ProviderWidget<HomePageViewModel>(
        model: HomePageViewModel(),
        onModelInit: (model)=>model.refresh(),
        builder: (context, model, child) {
          return LoadingStateWidget(
            child: _banner(model),
            viewState: model.viewState,
            retry: model.retry,

          );
        });
  }


  _banner(model){
    return Container(
      height: 200,
      padding: const EdgeInsets.only(left: 15,top: 15,right: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: BannerWidget(model:model),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
