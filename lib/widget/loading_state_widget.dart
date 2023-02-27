import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/color.dart';
import '../config/string.dart';

enum ViewState { loading, done, error }

class LoadingStateWidget extends StatelessWidget {

  final ViewState viewState;
  final VoidCallback? retry;
  final Widget? child;

  const LoadingStateWidget({super.key, this.viewState = ViewState
      .loading, this.retry, this.child});


  // LoadingStateWidget(this.viewState, this.retry, this.child);

  @override
  Widget build(BuildContext context) {
    if (viewState == ViewState.loading) {
      return _loadView;
    } else if (viewState == ViewState.error) {
      return _errorView;
    }
    return _loadView;
  }




  Widget get _errorView {
    return Center(
      // 类似LinearLayout
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'images/ic_error.png',
            width: 100,
            height: 100,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              ConfigString.net_request_fail,
              style: TextStyle(color: ConfigColor.hitTextColor, fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: OutlinedButton(
              onPressed: retry,
              child: Text(
                ConfigString.reload_again,
                style: TextStyle(color: Colors.black87),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  overlayColor: MaterialStateProperty.all(Colors.black12)),
            ),
          )
        ],
      ),
    );
  }


  Widget get _loadView {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

}