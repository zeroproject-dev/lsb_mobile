import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({super.key});

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  final IO.Socket _socket = IO.io("http://192.168.0.114:3300",
      IO.OptionBuilder().setTransports(["websocket"]).build());
  bool _isLoading = true;

  late CameraController _cameraController;
  final dio = Dio();
  // String url = 'http://192.168.0.114:3300/api/v1/translate/';
  final _text = "";
  var _images = <Uint8List>[];
  var f = true;

  ImageSender imageSender = ImageSender();

  // Isolate? _isolate;
  // SendPort? _sendPort;
  // ReceivePort _receivePort = ReceivePort();

  // void startStream() { }

  // void _startIsolate(List<Uint8List> images) {
  //   Isolate.spawn(imageSender.send, images);
  // }

  // final imageStream = StreamController<CameraImage>();

  void _processImage(CameraImage img) {
    print("Process image");
    _images.add(img.planes[0].bytes);

    if (_images.length == 30) {
      print("sending to sendport");
      compute(imageSender.send, _images);
      // _receivePort.sendPort.send(_images);
      _images.clear();
    }
  }

  _connectSocket() {
    _socket.onConnect((data) => print('Connection Established'));
    _socket.onConnectError((data) => print('Connect Error: $data'));
    _socket.onDisconnect((data) => print('Disconnect'));
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(
      front,
      ResolutionPreset.low,
      enableAudio: false,
    );
    await _cameraController.initialize();

    setState(() => _isLoading = false);

    // dio.options.followRedirects = true;
    // dio.options.maxRedirects = 5;

    _cameraController.startImageStream((image) {
      if (!f) _processImage(image);
    });
  }

  // _initIsolate() async {
  //   _isolate = await Isolate.spawn(imageSender.listen, _receivePort.sendPort);
  // }

  @override
  void initState() {
    super.initState();
    _initCamera();
    _connectSocket();
    // _initIsolate();
  }

  @override
  void dispose() {
    // _isolate?.kill();

    _cameraController.stopImageStream();
    _cameraController.dispose();
    _socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: size.width,
              height: size.height * 0.7,
              child: CameraPreview(_cameraController),
            ),
            Text(
              _text,
              style: const TextStyle(fontSize: 32),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {});
                print("urmom");
                if (f) {
                  //_startSendingImages();
                  // startStream();
                } else {
                  // _cameraController.stopImageStream();
                  // _isolate?.kill();
                  // _isolate = null;
                }

                f = !f;
                // if (f)
                //   _cameraController.startImageStream((image) {
                //     _processImages(image);
                //   });
                // else
                //   _cameraController.stopImageStream();
              },
              child: f ? const Text("Empezar") : const Text("Detener"),
            )
          ],
        ),
      ),
    );
  }
}

class ImageSender {
  List<Uint8List> images = [];
  final socket = IO.io("http://192.168.0.114:3300");

  void listen(SendPort sendPort) {
    print("listen");
    // Recibe el SendPort del StreamController
    SendPort mainIsolateSendPort = await _receivePort.first;
    
    // Utiliza el streamController para agregar imágenes al stream
    mainIsolateSendPort.send({
      'type': 'stream',
      'streamSink': streamController.sink,
    });

    // Escucha las imágenes y realiza la lógica necesaria
    streamController.stream.listen((image) {
      images.add(image.planes[0].bytes);

      if (images.length == 30) {
        print("sending to sendport");
        // Envía las imágenes al socket o realiza la lógica necesaria
        // socket.emit("image", {"data": images});
        images.clear();
      }
    });
  }
}
