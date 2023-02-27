

import 'package:eyepetizer_project/viewmodel/base_change_notifier.dart';

class TabNavigationViewModel extends BaseChangeNotifier {
  int currentIndex = 0;

  changeBottomTabIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
