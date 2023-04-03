import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/src/material/material_progress_bar.dart';

import '../utils/format_duration_util.dart';

///自定义播放器UI
class VideoControlsWidget extends StatefulWidget {
  // 初始化是是否显示 加载动画：默认为true
  final bool showLoadingOnInitialize;

  // 是否显示大播放按钮：默认为true
  final bool showBigPlayIcon;

  // 浮层 Ui
  final Widget? overlayUI;

  // 底层控制栏的背景色：一般设为渐变色
  final Gradient? bottomGradient;

  const VideoControlsWidget(
      {Key? key,
        this.showLoadingOnInitialize = true,
        this.showBigPlayIcon = true,
        this.overlayUI,
        this.bottomGradient})
      : super(key: key);

  @override
  _VideoControlsWidgetState createState() => _VideoControlsWidgetState();
}

// SingleTickerProviderStateMixin:ticker,定义 AnimationController 需要
class _VideoControlsWidgetState extends State<VideoControlsWidget>
    with SingleTickerProviderStateMixin {
  // 视频播放数据：当前播放位置，缓存状态，错误状态，设置等
  VideoPlayerValue? _latestValue;

  // 声音大小
  double? _latestVolume;
  bool _hideStuff = true;

  // 控制栏隐藏时间计时器
  Timer? _hideTimer;
  Timer? _initTimer;

  // 全屏切换 Timer
  Timer? _showAfterExpandCollapseTimer;
  bool _dragging = false;
  bool _displayTapped = false;

  // 底部控制栏的高度
  final barHeight = 48.0;
  final marginSize = 5.0;

  // 视频播放控制器
  VideoPlayerController? controller;
  ChewieController? chewieController;

  // 播放暂停图标动画控制器
  AnimationController? playPauseIconAnimationController;

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    controller?.removeListener(_updateState);
    _hideTimer?.cancel();
    _initTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
  }

  @override
  void didChangeDependencies() {
    final _oldController = chewieController;
    chewieController = ChewieController.of(context);
    controller = chewieController?.videoPlayerController;
    // vsync:ticker 驱动动画,每次屏幕刷新都会调用TickerCallback，
    // 一般 SingleTickerProviderStateMixin 添加到 State，直接使用this
    playPauseIconAnimationController ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 400),
    );

    if (_oldController != chewieController) {
      _dispose();
      _initialize();
    }

    super.didChangeDependencies();
  }

  /// 初始化
  Future<void> _initialize() async {
    controller?.addListener(_updateState);

    // 更新状态：重新获取视频播放的状态数据
    _updateState();

    if ((controller?.value != null && controller?.value.isPlaying == true) ||
        chewieController?.autoPlay == true) {
      _startHideTimer();
    }

    if (chewieController?.showControlsOnInitialize == true) {
      _initTimer = Timer(const Duration(milliseconds: 200), () {
        setState(() {
          _hideStuff = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? des =
        chewieController?.videoPlayerController.value.errorDescription;
    if (_latestValue?.hasError == true) {
      if (des == null) {
        return const Center(
            child: Icon(Icons.error, color: Colors.white, size: 42));
      } else {
        return Center(
          child: Text(
            des ?? "",
            style: const TextStyle(color: Colors.white),
          ),
        );
      }
    }

    return _playVideo();
  }

  /// 播放器
  Widget _playVideo() {
    return GestureDetector(
      onTap: () => _cancelAndRestartTimer(),
      // AbsorbPointer:禁止用户输入的控件，会消耗掉事件，跟 IgnorePointer(不消耗事件) 类似
      child: AbsorbPointer(
        // absorbing：true 不响应事件
        absorbing: _hideStuff,
        // 类似AndroidFrameLayout
        child: Stack(
          children: [
            // Container(),
            // 类似 垂直方向的 LinearLayout
            Column(
              children: <Widget>[
                // 不是正在播放 && duration == null || 正在缓冲
                if (_latestValue != null &&
                    _latestValue?.isPlaying == false &&
                    _latestValue?.duration == null ||
                    _latestValue?.isBuffering == true)
                // 圆形进度条
                  Expanded(child: Center(child: _loadingIndicator()))
                else
                // 创建点击区
                  _buildHitArea(),
                // 底部控制栏
                _buildBottomBar(context),
              ],
            ),
            // 浮层
            _overlayUI()
          ],
        ),
      ),
    );
  }

  ///中间进度条
  _loadingIndicator() {
    //初始化时是否显示loading
    return widget.showLoadingOnInitialize ? CircularProgressIndicator() : null;
  }

  /// 视频点击区
  Expanded _buildHitArea() {
    // 视频是否播放完：当前位置 >= 持续时间
    Duration position = _latestValue?.position ?? const Duration(seconds: 0);
    Duration duration = _latestValue?.duration ?? const Duration(seconds: 0);
    final bool isFinished = position >= duration;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          // 显示隐藏控制栏
          if (_latestValue != null && _latestValue?.isPlaying == true) {
            if (_displayTapped) {
              setState(() {
                _hideStuff = true;
              });
            } else {
              _cancelAndRestartTimer();
            }
          } else {
            setState(() {
              _hideStuff = true;
            });
          }
        },
        // 中间大按钮
        child: Container(
          color: Colors.transparent,
          child: Center(
            // AnimatedOpacity:使子组件变的透明
            child: AnimatedOpacity(
              opacity: _latestValue != null &&
                  _latestValue?.isPlaying == false &&
                  !_dragging
                  ? 1.0
                  : 0.0,
              // 动画执行的时间
              duration: const Duration(milliseconds: 300),
              // 中间播放按钮,showBigPlayIcon:是否显示大播放按钮
              child: widget.showBigPlayIcon
                  ? _palyPauseButton(isFinished)
                  : Container(),
            ),
          ),
        ),
      ),
    );
  }

  /// 播放、暂停、重播按钮
  Widget _palyPauseButton(isFinished) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.circular(48.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Material(
            child: IconButton(
              icon: isFinished
                  ? const Icon(Icons.replay, size: 32.0)
              // AnimatedIcon:动画图标
                  : AnimatedIcon(
                // 播放到暂停的动画图标
                icon: AnimatedIcons.play_pause,
                // 设置图标的动画
                progress: playPauseIconAnimationController ??
                    AnimationController(
                      vsync: this,
                      duration: const Duration(milliseconds: 400),
                      reverseDuration: const Duration(milliseconds: 400),
                    ),
                size: 32.0,
              ),
              onPressed: () {
                // 开始播放或暂停
                _playPause();
              },
            ),
          ),
        ),
      ),
    );
  }

  /// 开始播放或者暂停
  void _playPause() {
    // 是否播放完
    bool isFinished;
    if (_latestValue?.duration != null) {
      Duration position = _latestValue?.position ?? const Duration(seconds: 0);
      Duration duration = _latestValue?.duration ?? const Duration(seconds: 0);

      isFinished = position >= duration;
    } else {
      isFinished = false;
    }

    setState(() {
      //如果正在播放
      if (controller?.value.isPlaying == true) {
        // 方向执行动画：从播放到暂停
        playPauseIconAnimationController?.reverse();
        _hideStuff = false;
        _hideTimer?.cancel();
        controller?.pause();
      } else {
        _cancelAndRestartTimer();

        if (controller?.value.isInitialized == false) {
          controller?.initialize().then((_) {
            controller?.play();
            // 正向执行动画：从暂停到播放
            playPauseIconAnimationController?.forward();
          });
        } else {
          // 如果播放完，跳转到开始
          if (isFinished) {
            controller?.seekTo(const Duration());
          }
          // 正向执行动画：从暂停到播放
          playPauseIconAnimationController?.forward();
          controller?.play();
        }
      }
    });
  }

  /// 底部控制栏
  AnimatedOpacity _buildBottomBar(BuildContext context) {
    final iconColor = Theme.of(context).textTheme.button?.color;

    // AnimatedOpacity:使子组件变的透明
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: barHeight,
        //背景色：渐变
        decoration: BoxDecoration(gradient: widget.bottomGradient),
        child: Row(
          children: <Widget>[
            // 暂停和播放icon
            _buildPlayPause(controller),
            // 进度条：如果是直播
            if (chewieController?.isLive == true)
            // SizedBox:具有固定宽高的组件,适合控制2个组件之间的空隙
              const SizedBox()
            else
              _buildProgressBar(),
            // 播放时间：如果是直播
            if (chewieController?.isLive == true)
              const Expanded(child: Text('LIVE'))
            else
              _buildPosition(iconColor ?? Colors.white),
            // 是否显示播放速度设置按钮
            if (chewieController?.allowPlaybackSpeedChanging == true)
              _buildSpeedButton(controller),
            // 静音按钮
            if (chewieController?.allowMuting == true)
              _buildMuteButton(controller),
            // 全屏按钮
            if (chewieController?.allowFullScreen == true) _buildExpandButton(),
          ],
        ),
      ),
    );
  }

  ///底部控制栏的暂停和播放icon
  GestureDetector _buildPlayPause(VideoPlayerController? controller) {
    return GestureDetector(
      onTap: _playPause,
      child: Container(
        height: barHeight,
        color: Colors.transparent,
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
        ),
        child: Icon(
          controller?.value.isPlaying == true
              ? Icons.pause_rounded
              : Icons.play_arrow_rounded,
          color: Colors.white,
        ),
      ),
    );
  }

  ///底部控制栏的进度条
  Widget _buildProgressBar() {
    ChewieController chewie = chewieController ?? ChewieController.of(context);
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 15, left: 15),
        child: MaterialVideoProgressBar(
          controller ?? chewie.videoPlayerController,
          onDragStart: () {
            setState(() {
              _dragging = true;
            });

            _hideTimer?.cancel();
          },
          onDragEnd: () {
            setState(() {
              _dragging = false;
            });

            _startHideTimer();
          },
          colors: chewieController?.materialProgressColors ??
              ChewieProgressColors(
                  playedColor: Theme.of(context).accentColor,
                  handleColor: Theme.of(context).accentColor,
                  bufferedColor: Theme.of(context).backgroundColor,
                  backgroundColor: Theme.of(context).disabledColor),
        ),
      ),
    );
  }

  ///底部控制栏播放时间
  Widget _buildPosition(Color iconColor) {
    final position = _latestValue != null && _latestValue?.position != null
        ? _latestValue?.position
        : Duration.zero;
    final duration = _latestValue != null && _latestValue?.duration != null
        ? _latestValue?.duration
        : Duration.zero;

    return Padding(
      padding: EdgeInsets.only(right: 5.0),
      child: Text(
        "${formatDuration(position ?? const Duration(seconds: 0))}/${formatDuration(duration ?? const Duration(seconds: 0))}",
        style: TextStyle(fontSize: 10, color: Colors.white),
      ),
    );
  }

  //'${formatDuration(position)}/${formatDuration(duration)}',

  /// 底部控制栏播放速度按钮
  Widget _buildSpeedButton(VideoPlayerController? controller) {
    return GestureDetector(
      onTap: () async {
        _hideTimer?.cancel();

        final chosenSpeed = await showModalBottomSheet<double>(
          context: context,
          isScrollControlled: true,
          useRootNavigator: true,
          builder: (context) => _PlaybackSpeedDialog(
            // 可以选择的播放速度
            allowedSpeeds: chewieController?.playbackSpeeds ?? [0.0],
            // 当前的播放速度
            currentSpeed: _latestValue?.playbackSpeed ?? 0,
          ),
        );

        if (chosenSpeed != null) {
          controller?.setPlaybackSpeed(chosenSpeed);
        }

        if (_latestValue?.isPlaying == true) {
          _startHideTimer();
        }
      },
      child: Container(
        height: barHeight,
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: const Icon(Icons.speed),
      ),
    );
  }

  /// 底部控制栏静音按钮
  GestureDetector _buildMuteButton(VideoPlayerController? controller) {
    return GestureDetector(
      onTap: () {
        _cancelAndRestartTimer();

        if (_latestValue?.volume == 0) {
          // 打开声音
          controller?.setVolume(_latestVolume ?? 0.5);
        } else {
          // 关闭声音，保存当前值
          _latestVolume = controller?.value.volume;
          controller?.setVolume(0.0);
        }
      },
      child: Container(
        height: barHeight,
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Icon(
          (_latestValue != null && (_latestValue?.volume ?? 0) > 0)
              ? Icons.volume_up
              : Icons.volume_off,
          color: Colors.white,
        ),
      ),
    );
  }

  ///底部控制栏全屏按钮
  GestureDetector _buildExpandButton() {
    return GestureDetector(
      onTap: _onExpandCollapse,
      child: Container(
        height: barHeight,
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Center(
          child: Icon(
            chewieController?.isFullScreen == true
                ? Icons.fullscreen_exit_rounded
                : Icons.fullscreen_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// 底部控制栏 全屏按钮事件回调方法
  void _onExpandCollapse() {
    if (chewieController?.videoPlayerController.value.size == null) {
      print('_onExpandCollapse:videoPlayerController.value.size is null.');
      return;
    }
    setState(() {
      _hideStuff = true;

      // 切换全屏
      chewieController?.toggleFullScreen();
      _showAfterExpandCollapseTimer =
          Timer(const Duration(milliseconds: 300), () {
            setState(() {
              _cancelAndRestartTimer();
            });
          });
    });
  }

  /// 取消并重新开始计时：隐藏时间
  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    setState(() {
      _hideStuff = false;
      _displayTapped = true;
    });
  }

  /// 开始隐藏时间计时
  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _hideStuff = true;
      });
    });
  }

  /// 更新状态：重新获取视频播放的状态数据
  void _updateState() {
    setState(() {
      _latestValue = controller?.value;
    });
  }

  ///浮层
  _overlayUI() {
    return widget.overlayUI != null
        ? AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: Duration(milliseconds: 300),
        child: widget.overlayUI)
        : Container();
  }
}

class _PlaybackSpeedDialog extends StatelessWidget {
  const _PlaybackSpeedDialog({
    Key? key,
    required List<double> allowedSpeeds,
    required double currentSpeed,
  })  : _allowedSpeeds = allowedSpeeds,
        _currentSpeed = currentSpeed,
        super(key: key);

  final List<double> _allowedSpeeds;
  final double _currentSpeed;

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = Theme.of(context).primaryColor;

    return ListView.builder(
      // shrinkWrap:决定列表的长度是否仅包裹其内容的长度。true,仅包裹其内容的长度。
      // 当ListView嵌在一个无限长的容器组件中时，shrinkWrap必须为true，否则Flutter会给出警告
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemBuilder: (context, index) {
        final _speed = _allowedSpeeds[index];
        return ListTile(
          // dense:使文本更小，并将所有内容打包在一起
          dense: true,
          title: Row(
            children: <Widget>[
              if (_speed == _currentSpeed)
                Icon(Icons.check, size: 20.0, color: selectedColor)
              else
                Container(width: 20.0),
              const SizedBox(width: 16.0),
              Text(_speed.toString()),
            ],
          ),
          selected: _speed == _currentSpeed,
          onTap: () {
            Navigator.of(context).pop(_speed);
          },
        );
      },
      itemCount: _allowedSpeeds.length,
    );
  }
}
