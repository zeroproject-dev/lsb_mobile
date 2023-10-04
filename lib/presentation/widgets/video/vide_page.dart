import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gallery_saver/files.dart';
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
              try {
                Dio dio = Dio();
                dio.options.followRedirects = true;
                dio.options.maxRedirects = 5;
                // dio.options.validateStatus = (status) => true;
                String url = 'http://lsb.zeroproject.dev/api/v1/videos/';
                FormData formData = FormData.fromMap({
                  'video': await MultipartFile.fromFile(widget.filePath),
                });

                dio.interceptors.add(InterceptorsWrapper(
                  onError: (DioException e, handler) {
                    return handler.next(e);
                  },
                ));

                Response response = await dio.post(url, data: formData);

                if (response.statusCode != 200) {
                  await GallerySaver.saveVideo(widget.filePath);
                }

                // final request = http.MultipartRequest("POST", Uri.parse(url));
                // final headers = {"Content-type": "multipart/form-data"};
                //
                // var file = File(widget.filePath);
                //
                // request.files.add(http.MultipartFile(
                //     'video', file.readAsBytes().asStream(), file.lengthSync(),
                //     filename: widget.word));
                //
                // request.headers.addAll(headers);
                // final response = await request.send();
                // http.Response res = await http.Response.fromStream(response);
                //
                // print(res.body);
              } catch (e) {
                print("ERROR:");
                print(e);
              }
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
