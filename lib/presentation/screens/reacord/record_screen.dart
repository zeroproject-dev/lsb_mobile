import 'package:flutter/material.dart';
import 'package:lsb_translator/presentation/widgets/video/camera_page.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CameraPage(),
    );
  }
}
