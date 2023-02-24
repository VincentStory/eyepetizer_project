
import 'package:eyepetizer_project/http/Url.dart';
import 'package:flutter_splash_screen/flutter_splash_screen.dart';
class AppInit{


  AppInit._();


  ///hide your splash screen
  static Future<void> init() async {
    Url.baseUrl= 'http://baobab.kaiyanapp.com/api/';

    Future.delayed(const Duration(milliseconds: 2000), () {
      FlutterSplashScreen.hide();
    });
  }

}