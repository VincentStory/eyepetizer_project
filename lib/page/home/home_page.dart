import 'package:eyepetizer_project/config/string.dart';
import 'package:eyepetizer_project/widget/app_bar.dart';
import 'package:eyepetizer_project/widget/loading_state_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: appBar(
        ConfigString.home,
        showBack: false,
      ),
      body: LoadingStateWidget(
        viewState: ViewState.error,
        child: Container(color: Colors.blue,),
      )
    );
  }

  @override
  bool get wantKeepAlive => true;
}
