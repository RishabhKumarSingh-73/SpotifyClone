import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);
    final userFav = ref
        .watch(currentUserNotifierProvider.select((data) => data!.favourites));
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [hexToRgb(currentSong!.hex_code), const Color(0xff121212)],
      )),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Scaffold(
        backgroundColor: Pallete.transparentColor,
        appBar: AppBar(
          backgroundColor: Pallete.transparentColor,
          leading: Transform.translate(
            offset: Offset(-15, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/pull-down-arrow.png',
                  color: Pallete.whiteColor,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Hero(
                  tag: 'music-image',
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(currentSong.thumbnail_url),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.song_name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Pallete.whiteColor,
                            ),
                          ),
                          Text(
                            currentSong.artist,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Pallete.whiteColor,
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      IconButton(
                          onPressed: () async {
                            await ref
                                .read(homeViewModelProvider.notifier)
                                .favSong(songId: currentSong.id);
                          },
                          icon: Icon(userFav
                                  .where((fav) => fav.song_id == currentSong.id)
                                  .toList()
                                  .isEmpty
                              ? Icons.favorite_outline
                              : Icons.favorite))
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  StreamBuilder(
                    stream: songNotifier.audioPlayer!.positionStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox();
                      }
                      final position = snapshot.data;
                      final duration = songNotifier.audioPlayer!.duration;
                      double slidervalue = 0.0;
                      if (position != null && duration != null) {
                        slidervalue =
                            position.inMilliseconds / duration.inMilliseconds;
                      }
                      return Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Pallete.whiteColor,
                              inactiveTrackColor:
                                  Pallete.whiteColor.withOpacity(0.117),
                              thumbColor: Pallete.whiteColor,
                              trackHeight: 4,
                              overlayShape: SliderComponentShape.noOverlay,
                            ),
                            child: Slider(
                              value: slidervalue,
                              min: 0,
                              max: 1,
                              onChanged: (val) {
                                slidervalue = val;
                              },
                              onChangeEnd: songNotifier.seek,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${position?.inMinutes}:${position!.inSeconds < 10 ? '0${position.inSeconds}' : '${position.inSeconds}'}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13,
                                    color: Pallete.whiteColor),
                              ),
                              Expanded(child: SizedBox()),
                              Text(
                                '${duration?.inMinutes}:${duration!.inSeconds < 10 ? '0${duration.inSeconds}' : '${duration.inSeconds}'}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13,
                                    color: Pallete.whiteColor),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/images/shuffle.png',
                                  color: Pallete.whiteColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/images/previus-song.png',
                                  color: Pallete.whiteColor,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  songNotifier.playPause();
                                },
                                icon: Icon(
                                  songNotifier.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
                                iconSize: 50,
                                color: Pallete.whiteColor,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/images/next-song.png',
                                  color: Pallete.whiteColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/images/repeat.png',
                                  color: Pallete.whiteColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/images/connect-device.png',
                                  color: Pallete.whiteColor,
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/images/playlist.png',
                                  color: Pallete.whiteColor,
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
