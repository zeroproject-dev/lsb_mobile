import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:lsb_translator/presentation/widgets/video/vide_page.dart';
import 'package:searchfield/searchfield.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = true;
  bool _isRecording = false;
  int _countdown = 3;
  late CameraController _cameraController;
  List<String> words = [
    "Hola",
    "Como estas",
    "Buenos dias",
    "Buenas tardes",
    "Buenas noches",
    "Te amo",
  ];
  String? _selectedWord;
  // late Timer _startRecordingTimer;

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(
      front,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  _startRecord() async {
    if (_selectedWord == null) return;

    setState(() {
      _countdown = 3;
    });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
      });

      if (_countdown < 1) {
        timer.cancel();
        _recordVideo();
      }
    });
  }

  _recordVideo() async {
    await _cameraController.prepareForVideoRecording();
    _cameraController.startVideoRecording().then((value) {
      Timer(const Duration(milliseconds: 100), () {});
      setState(() => _isRecording = true);
      Timer(const Duration(seconds: 3), () async {
        XFile file = await _cameraController.stopVideoRecording();
        _countdown = 3;
        setState(() => _isRecording = false);
        final route = MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => VideoPage(filePath: file.path, word: _selectedWord),
        );
        Navigator.push(context, route);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return SafeArea(
        child: Column(
          children: [
            SearchField(
              hint: 'Selecciona una palabra',
              suggestions:
                  words.map((e) => SearchFieldListItem(e, item: e)).toList(),
              onSuggestionTap: (item) {
                _selectedWord = item.item;
                setState(() {});
              },
              onSaved: (item) {
                if (item != null && words.contains(item.trim())) {
                  _selectedWord = item;
                } else {
                  _selectedWord = null;
                }
                setState(() {});
              },
              onSubmit: (item) {
                if (words.contains(item.trim())) {
                  _selectedWord = item;
                } else {
                  _selectedWord = null;
                }
                setState(() {});
              },
            ),
            CameraPreview(_cameraController),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Row(
                    children: [
                      Icon(_isRecording ? Icons.stop : Icons.circle),
                      Text(_isRecording
                          ? "Detener grabación"
                          : "Iniciar grabación"),
                    ],
                  ),
                  onPressed: () => _startRecord(),
                ),
              ],
            ),
            Text(_selectedWord != null
                ? "Palabra: $_selectedWord"
                : "Seleccione una palabra"),
            Text(
              _countdown == 3
                  ? ""
                  : !_isRecording
                      ? "${_countdown + 1}"
                      : "YA!",
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      );
    }
  }
}
