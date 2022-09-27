import 'dart:async';

import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerScreen({super.key, required this.videoUrl});
  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  Map<String, bool> state = {"show": false};

  late VideoPlayerController videocontroller;
  @override
  void initState() {
    videocontroller =
        VideoPlayerController.network(Uri.parse(widget.videoUrl).toString())
          ..initialize().then((_) {
            videocontroller.play();

            setState(() {});
          });

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            Center(
              child: AspectRatio(
                aspectRatio: videocontroller.value.aspectRatio,
                child: VideoPlayer(videocontroller),
              ),
            ),
            Controlls(videocontroller: videocontroller, state: state)
          ],
        ),
      ),
      onTap: () {
        state["show"] = !state["show"]!;

        _ControllsState.refresh!();
      },
    );
  }

  @override
  void dispose() {
    videocontroller.dispose();
    super.dispose();
  }
}

class Controlls extends StatefulWidget {
  const Controlls(
      {Key? key, required this.videocontroller, required this.state})
      : super(key: key);
  final state;
  final VideoPlayerController videocontroller;

  @override
  State<Controlls> createState() => _ControllsState();
}

class _ControllsState extends State<Controlls> {
  double val = 0;
  Timer? timer;
  bool show = false;
  static Function? refresh;
  @override
  void initState() {
    setState(() {
      val = widget.videocontroller.value.position.inSeconds.toDouble();
    });

    widget.videocontroller.addListener(videoChange);
    super.initState();
  }

  @override
  void dispose() {
    widget.videocontroller.removeListener(videoChange);
    super.dispose();
  }

  videoChange() {
    setState(() {
      val = widget.videocontroller.value.position.inSeconds.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.state["show"]!
        ? SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values)
        : SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: []);
    if (widget.state["show"] && !(timer?.isActive ?? false)) {
      timer = Timer(const Duration(seconds: 2), () {
        widget.state["show"] = false;
        setState(() {});
      });
    }
    refresh = () => setState(() {
          if (widget.state["show"] == false) timer!.cancel();
        });
    return widget.state["show"]
        ? Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 40,
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      widget.videocontroller.value.isPlaying
                          ? widget.videocontroller.pause()
                          : widget.videocontroller.play();
                      setState(() {});
                    },
                    icon: widget.videocontroller.value.isPlaying
                        ? const Icon(Icons.pause, color: Colors.white)
                        : const Icon(Icons.play_arrow, color: Colors.white),
                  ),
                  Expanded(
                    child: Slider(
                        value: val,
                        label:
                            "${(val / 60).floor().toString().padLeft(2, '0')}:${(val % 60).floor().toString().padLeft(2, '0')}",
                        divisions: widget
                            .videocontroller.value.duration.inSeconds
                            .toInt(),
                        min: 0,
                        max: widget.videocontroller.value.duration.inSeconds
                            .toDouble(),
                        onChanged: (newval) {
                          widget.videocontroller.removeListener(videoChange);
                          setState(() {
                            val = newval;
                            widget.videocontroller.play();
                            widget.videocontroller
                                .seekTo(Duration(seconds: val.toInt()));
                          });
                          widget.videocontroller.addListener(videoChange);
                        }),
                  ),
                  Text(
                    "${(val / 60).floor().toString().padLeft(2, '0')}:${(val % 60).floor().toString().padLeft(2, '0')}/ ${(widget.videocontroller.value.duration.inSeconds.toDouble() / 60).floor().toString().padLeft(2, '0')}:${(widget.videocontroller.value.duration.inSeconds.toDouble() % 60).floor().toString().padLeft(2, '0')} ",
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  )
                ],
              ),
            ),
          )
        : Container();
  }
}
