import 'package:share_plus/share_plus.dart';

void share(String title, String content) {
  Share.share('$title\n$content');
}