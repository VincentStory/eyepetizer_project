import 'package:eyepetizer_project/model/common_item.dart';
import 'package:eyepetizer_project/state/base_list_state.dart';
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

class _HomeBodyPageState extends BaseListState<Item,HomePageViewModel,HomeBodyPage>{
  @override
  Widget getContentChild(HomePageViewModel model) {
   return _banner(model);
  }

  @override
  HomePageViewModel get viewModel => HomePageViewModel();

 



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
