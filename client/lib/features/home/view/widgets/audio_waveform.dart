import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

class AudioWave extends StatefulWidget {
  final String path;
  const AudioWave({super.key, required this.path});

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  final playerController = PlayerController();

  @override
  void initState() {
    super.initState();
    playerControllerInit();
  }

  Future<void> playAndPause() async {
    if (!playerController.playerState.isPlaying) {
      await playerController.startPlayer();
    } else if (!playerController.playerState.isPaused) {
      await playerController.pausePlayer();
    }
    setState(() {});
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  void playerControllerInit() async {
    await playerController.preparePlayer(path: widget.path);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        playerController.playerState.isPlaying
            ? IconButton(onPressed: playAndPause, icon: Icon(Icons.pause))
            : IconButton(
                onPressed: playAndPause, icon: Icon(Icons.play_arrow_outlined)),
        Expanded(
          child: AudioFileWaveforms(
              size: const Size(double.infinity, 100),
              playerController: playerController),
        ),
      ],
    );
  }
}
