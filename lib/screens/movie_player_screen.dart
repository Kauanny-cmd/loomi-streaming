import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loomi_streaming/core/routes/api_routes.dart';
import 'package:video_player/video_player.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:wakelock_plus/wakelock_plus.dart';

import '../modules/auth/data/get_Firebase_token.dart';

class MoviePlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String movieTitle;
  final int movieId;

  const MoviePlayerScreen({
    super.key,
    required this.videoUrl,
    required this.movieTitle,
    required this.movieId,
  });

  @override
  State<MoviePlayerScreen> createState() => _MoviePlayerScreenState();
}

class _MoviePlayerScreenState extends State<MoviePlayerScreen> {
  late VideoPlayerController _controller;
  String? subtitleUrl;
  bool _visible = true;
  double _opacity = 1.0;
  Timer? _hideTimer;

  void _resetHideTimer() {
    _hideTimer?.cancel();
    setState(() {
      _visible = true;
      _opacity = 1.0;
    });

    _hideTimer = Timer(Duration(seconds: 3), () {
      setState(() {
        _opacity = 0.0;
        // Aguarda o fade-out antes de ocultar o widget
        Future.delayed(Duration(milliseconds: 300), () {
          setState(() {
            _visible = false;
          });
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        setState(() {});
        WakelockPlus.enable();
      });

    // Phone on
    _controller.addListener(() {
      final isFinished = _controller.value.position >= _controller.value.duration;
      if (isFinished && !_controller.value.isPlaying) {
        WakelockPlus.disable();
        Navigator.of(context).pop();
      }
    });

    fetchSubtitle();

    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _opacity = 0.0;
      });
    });

    _resetHideTimer();

      WakelockPlus.enable();
  }

  Future<void> fetchSubtitle() async {
    final token = await getFirebaseToken();
    final response = await http.get(
        Uri.parse(ApiRoutes.getSubtitles(widget.movieId)),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    log(response.body);
    print(widget.movieId);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final fileData = data['data'].isNotEmpty ? data['data'][0]['attributes']['file']['data']['attributes']['url'] : null;
      if (fileData != null) {
        setState(() {
          subtitleUrl = fileData;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () {
            _resetHideTimer(); // Reexibe e reinicia o temporizador ao tocar na tela
          },
          child: Stack(
            children: [
              Center(
                child: _controller.value.isInitialized
                    ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
                    : const CircularProgressIndicator(),
              ),
              if (_controller.value.isInitialized) _buildControls(),
            ],
          ),
        ),
      ),
    );
}

  Widget _buildControls() {
    return Positioned.fill(
      child: Visibility(
        visible: _visible,
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(seconds: 5),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Color((0xFFBB86FC))),
                      onPressed: (){
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                        ]);
                        WakelockPlus.disable();
                        Navigator.of(context).pop();
                      },),
                    Text(widget.movieTitle,
                        style: const TextStyle(color: Colors.white, fontSize: 18)),
                    Row(
                      children: [
                        const Icon(Icons.subtitles, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          subtitleUrl != null ? 'Subtitle or audio' : 'No subtitles',
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    )
                  ],
                ),

                // Middle controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon:
                      const Icon(Icons.replay_10, size: 32, color: Colors.white),
                      onPressed: () {
                        _controller.seekTo(
                            _controller.value.position - const Duration(seconds: 10));
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause_circle
                            : Icons.play_circle,
                        size: 48,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.forward_10,
                          size: 32, color: Colors.white),
                      onPressed: () {
                        _controller.seekTo(
                            _controller.value.position + const Duration(seconds: 10));
                      },
                    ),
                  ],
                ),

                // Bottom progress
                VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: Colors.purpleAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
