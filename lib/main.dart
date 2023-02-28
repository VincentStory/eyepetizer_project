import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app_init.dart';
import 'tab_navigation.dart';

void main() {
  runApp(const MyApp());

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //展示加载中动画
    return FutureBuilder(
      future: AppInit.init(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        print(snapshot.connectionState);

        // HttpManager.getData(
        //   Url.feedUrl,
        //   success: (result) {
        //     print(result);
        //   },
        // );

        var widget = snapshot.connectionState == ConnectionState.done
            ? TabNavigation()
            : const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );

        return GetMaterialappWidget(
          child: widget,
        );
      },
    );
  }
}

class GetMaterialappWidget extends StatefulWidget {
  final Widget child;

  const GetMaterialappWidget({Key? key, required this.child}) : super(key: key);

  @override
  State<GetMaterialappWidget> createState() => _GetMaterialappWidgetState();
}

class _GetMaterialappWidgetState extends State<GetMaterialappWidget> {
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: "EyePetizer",
    //   initialRoute: '/',
    //   routes: {
    //     '/': (BuildContext context) => widget.child,
    //   },
    // );
    return GetMaterialApp(
      title: "EyePetizer",
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => widget.child),
      ],
    );

  }
}
