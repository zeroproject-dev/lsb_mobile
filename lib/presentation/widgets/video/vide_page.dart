import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final String filePath;
  final String word;

  const VideoPage({Key? key, required this.filePath, required this.word})
      : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previsualización'),
        elevation: 0,
        backgroundColor: Colors.black26,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              await GallerySaver.saveVideo(widget.filePath);
              () {
                Navigator.pop(context);
              }();
            },
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: _initVideoPlayer(),
        builder: (context, state) {
          if (state.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return VideoPlayer(_videoPlayerController);
          }
        },
      ),
    );
  }
}
