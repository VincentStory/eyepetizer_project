import 'package:flutter/material.dart';

import '../../config/string.dart';
import '../../widget/app_bar.dart';
import 'home_body_page.dart';

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
      body: const HomeBodyPage(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
