import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import 'video_controls_widget.dart';

//基于Chewie二次封装
class VideoPlayWidget extends StatefulWidget {
  final String url;
  final bool autoPlay;
  final bool looping;
  final bool allowFullScreen;
  final bool allowPlaybackSpeedChanging;
  final double aspectRatio;

  const VideoPlayWidget({
    Key? key,
    // 视频播放链接
    required this.url,
    // 自动播放
    this.autoPlay = true,
    // 循环播放
    this.looping = true,
    // 视频的纵横比--宽/高
    this.aspectRatio = 16 / 9,
    // 是否允许全屏
    this.allowFullScreen = true,
    // 是否允许视频速度的改变
    this.allowPlaybackSpeedChanging = true,
  }) : super(key: key);

  @override
  VideoPlayWidgetState createState() => VideoPlayWidgetState();
}

class VideoPlayWidgetState extends State<VideoPlayWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _cheWieController;

  @override
  void initState() {
    super.initState();
    // widget.url：播放地址
    _videoPlayerController = VideoPlayerController.network(widget.url);
    if (_videoPlayerController != null) {
      _cheWieController = ChewieController(
        videoPlayerController:
            _videoPlayerController ?? VideoPlayerController.network(widget.url),
        // 自动播放
        autoPlay: widget.autoPlay,
        // 循环播放
        looping: widget.looping,
        // 视频的纵横比--宽/高
        aspectRatio: widget.aspectRatio,
        // 是否允许视频速度的改变
        allowPlaybackSpeedChanging: widget.allowPlaybackSpeedChanging,
        // 是否允许全屏
        allowFullScreen: widget.allowFullScreen,
        // 定义自定义控件
        customControls: VideoControlsWidget(
          overlayUI: _videoPlayTopBar(),
          bottomGradient: _blackLinearGradient(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = width / widget.aspectRatio;
    return Container(
      width: width,
      height: height,
      child: Chewie(
        controller: _cheWieController ??
            ChewieController(
              videoPlayerController: _videoPlayerController ??
                  VideoPlayerController.network(widget.url),
              // 自动播放
              autoPlay: widget.autoPlay,
              // 循环播放
              looping: widget.looping,
              // 视频的纵横比--宽/高
              aspectRatio: widget.aspectRatio,
              // 是否允许视频速度的改变
              allowPlaybackSpeedChanging: widget.allowPlaybackSpeedChanging,
              // 是否允许全屏
              allowFullScreen: widget.allowFullScreen,
              // 定义自定义控件
              customControls: VideoControlsWidget(
                overlayUI: _videoPlayTopBar(),
                bottomGradient: _blackLinearGradient(),
              ),
            ),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _cheWieController?.dispose();
    super.dispose();
  }

  void play() {
    _cheWieController?.play();
  }

  void pause() {
    _videoPlayerController?.pause();
  }

  /// 播放视频的 TopBar
  Widget _videoPlayTopBar() {
    return Container(
      padding: EdgeInsets.only(right: 8),
      // 渐变背景色
      decoration: BoxDecoration(gradient: _blackLinearGradient(fromTop: true)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackButton(color: Colors.white),
          Icon(Icons.more_vert_rounded, color: Colors.white, size: 20),
        ],
      ),
    );
  }

  /// 渐变背景色
  _blackLinearGradient({bool fromTop = false}) {
    return LinearGradient(
      begin: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
      end: fromTop ? Alignment.bottomCenter : Alignment.topCenter,
      colors: [
        Colors.black54,
        Colors.black45,
        Colors.black38,
        Colors.black26,
        Colors.black12,
        Colors.transparent
      ],
    );
  }
}
