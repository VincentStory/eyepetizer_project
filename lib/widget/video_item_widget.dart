import 'package:flutter/material.dart';

import '../model/common_item.dart';
import '../utils/cache_image.dart';
import '../utils/date_util.dart';

class VideoItemWidget extends StatelessWidget {
  // 路径：common_item包
  final Data? data;

  // 点击回调方法
  final VoidCallback callBack;

  // 是否开启hero动画，默认为false
  final bool openHero;
  final Color titleColor;
  final Color categoryColor;

  const VideoItemWidget(
      {Key? key,
      this.data,
      required this.callBack,
      this.titleColor = Colors.white,
      this.categoryColor = Colors.white,
      this.openHero = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // InkWell：带有点击事件和点击效果的widget
    return InkWell(
      onTap: () {
        callBack();
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
        child: Row(
          children: <Widget>[
            // 左边图片显示设置
            _videoImage(),
            // 右边文字显示设置
            _videoText(),
          ],
        ),
      ),
    );
  }

  /// 左边图片显示设置
  Widget _videoImage() {
    int? dur = data?.duration;
    // 类似 FrameLayout
    return Stack(
      children: <Widget>[
        // 图片
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: _coverWidget(),
        ),
        // 右下角视频播放时长
        Positioned(
          right: 5,
          bottom: 5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              decoration: BoxDecoration(color: Colors.black54),
              padding: EdgeInsets.all(3),
              child: Text(
                formatDateMsByMS(dur == null ? 0 : dur * 1000),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _coverWidget() {
    if (openHero) {
      return Hero(
        tag: '${data?.id}${data?.time}',
        child: _imageWidget(),
      );
    } else {
      return _imageWidget();
    }
  }

  Widget _imageWidget() {
    return cacheImage(
      data?.cover?.detail ?? "",
      width: 135,
      height: 80,
    );
  }

  /// 右边文字显示设置
  Widget _videoText() {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              data?.title ?? "",
              style: TextStyle(
                  color: titleColor, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text(
                '#${data?.category} / ${data?.author?.name}',
                style: TextStyle(color: categoryColor, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
