import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  AudioPlayerWidget({required this.audioUrl});

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.playing) {
        setState(() {
          isPlaying = true;
        });
      } else if (state == PlayerState.paused || state == PlayerState.stopped) {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () {
            if (isPlaying) {
              _audioPlayer.pause();
            } else {
              _audioPlayer.play(UrlSource(widget.audioUrl));
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
