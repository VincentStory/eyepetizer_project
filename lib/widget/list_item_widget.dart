import 'package:eyepetizer_project/model/common_item.dart';
import 'package:flutter/material.dart';

import '../utils/cache_image.dart';
import '../utils/date_util.dart';
import '../utils/share_util.dart';

class ListItemWidget extends StatelessWidget {
  const ListItemWidget(
      {Key? key, this.item, this.showCategory = true, this.showDivider = true})
      : super(key: key);

  final Item? item;

// 是否显示 左上角 分类文字：默认显示
  final bool showCategory;

  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    // 垂直方向的 LinearLayout
    return Column(
      children: <Widget>[
        // 视频封面图片
        // GestureDetector：手势识别 -- Inkwell
        GestureDetector(
          onTap: () {
            print('点击了,跳转详情页');
            // TODO:跳转详情页
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            // Stack:类似 FrameLayout
            child: Stack(
              children: <Widget>[
                _clipRRectImage(context),
                _categoryText(),
                _videoTime(),
              ],
            ),
          ),
        ),
        // 视频内容简介
        Container(
          decoration: const BoxDecoration(color: Colors.white),
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          // Row：水平布局，类似Android LinearLayout
          child: Row(
            children: <Widget>[
              _authorHeaderImage(item!),
              // Expanded:具有权重属性的组件，可以控制Row、Column、Flex的子控件如何布局的控件。
              _videoDescription(),
              _shareButton(),
            ],
          ),
        ),
        // // 分割线
        // // Offstage:控制是否显示组件，false 显示,类似 GONE，不会占用空间
        // Offstage(
        //   offstage: showDivider,
        //   child: const Padding(
        //     padding: EdgeInsets.only(left: 15, right: 15),
        //     // Divider：分割线
        //     child: Divider(
        //       height: 0.5,
        //       color: Colors.red,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  /// 圆角图片
  Widget _clipRRectImage(context) {
    String? url = item?.data?.cover?.feed;
    // ClipRRect:剪切圆角矩形
    return ClipRRect(
      // Hero动画：界面跳转，关联动画
      borderRadius: BorderRadius.circular(4),
      // Hero动画：界面跳转，关联动画
      child: Hero(
        // tag相同的两个widget，跳转时自动关联动画
        tag: '${item?.data?.id}${item?.data?.time}',
        child: cacheImage(
          url!,
          width: MediaQuery.of(context).size.width,
          height: 200,
        ),
      ),
    );
  }

  /// 图片左上角显示图标，视频所属分类
  Widget _categoryText() {
    String? category = item?.data?.category;
    // Positioned:用于定位Stack子组件，Positioned必须是Stack的子组件
    return Positioned(
      left: 15,
      top: 10,
      // Opacity:设置透明度，类似于Android中的invisible
      child: Opacity(
        // opacity：1不透明
        opacity: showCategory ? 1.0 : 0.0, //处理控件显示或隐藏
        child: Container(
          // 也可以用：ClipRRect
          decoration: const BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.all(Radius.circular(22)),
          ),
          height: 44,
          width: 44,
          // 文字居中
          alignment: AlignmentDirectional.center,
          child: Text(
            category!,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ),
    );
  }
  // 图片右下角显示视频总时长
  Widget _videoTime() {
    int? duration = item?.data?.duration;
    return Positioned(
      right: 15,
      bottom: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          decoration: const BoxDecoration(color: Colors.black54),
          padding: const EdgeInsets.all(5),
          child: Text(
            formatDateMsByMS(duration! * 1000),
            style: const TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  /// 作者的头像
  Widget _authorHeaderImage(Item item) {
    String? url = item.data?.author == null
        ? item.data?.provider?.icon
        : item.data?.author?.icon;
    // ClipOval:剪切椭圆，高宽一样则为圆
    return ClipOval(
      // 抗锯齿
      clipBehavior: Clip.antiAlias,
      child: cacheImage(
        url!,
        width: 40,
        height: 40,
      ),
    );
  }

  /// 视频内容简介
  Widget  _videoDescription() {
    String? title = item?.data?.title;
    String? description = item?.data?.author == null
        ? item?.data?.description
        : item?.data?.author?.name;

    // Expanded:相当于Android中设置 weight 权重
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        // 垂直的LinearLayout
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title!,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
                // 过长则省略
                overflow: TextOverflow.ellipsis),
            Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(description!,
                    style: const TextStyle(color: Color(0xff9a9a9a), fontSize: 12)))
          ],
        ),
      ),
    );
  }

  /// 分享按钮
  Widget _shareButton() {
    String? title= item?.data?.title;
    String? playUrl= item?.data?.playUrl;
    return IconButton(
      icon: const Icon(Icons.share, color: Colors.black38),
      onPressed: () => share(title!, playUrl!),
    );
  }
}
