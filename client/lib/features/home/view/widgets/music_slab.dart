import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/view/widgets/music_player.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);
    final userFav = ref
        .watch(currentUserNotifierProvider.select((data) => data!.favourites));
    if (currentSong == null) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MusicPlayer()));
      },
      child: Stack(children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: 66,
          width: MediaQuery.of(context).size.width - 16,
          decoration: BoxDecoration(
              color: hexToRgb(currentSong.hex_code),
              borderRadius: BorderRadius.circular(7)),
          padding: EdgeInsets.all(9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Hero(
                    tag: 'music-image',
                    child: Container(
                      width: 48,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              currentSong.thumbnail_url,
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(7)),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentSong.song_name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        currentSong.song_name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Pallete.subtitleText,
                        ),
                      )
                    ],
                  )
                ],
              ),
              Row(
                children: [
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
                        : Icons.favorite),
                  ),
                  IconButton(
                    onPressed: songNotifier.playPause,
                    icon: Icon(songNotifier.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow),
                  )
                ],
              )
            ],
          ),
        ),
        StreamBuilder(
            stream: songNotifier.audioPlayer?.positionStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox();
              }
              final position = snapshot.data;
              final duration = songNotifier.audioPlayer!.duration;
              double slidervalue = 0.0;
              if (position != null && duration != null) {
                slidervalue = position.inMilliseconds / duration.inMilliseconds;
              }

              return Positioned(
                  bottom: 0,
                  left: 8,
                  child: Container(
                    height: 2,
                    width:
                        slidervalue * (MediaQuery.of(context).size.width - 32),
                    decoration: BoxDecoration(
                        color: Pallete.whiteColor,
                        borderRadius: BorderRadius.circular(7)),
                  ));
            }),
        Positioned(
            bottom: 0,
            left: 8,
            child: Container(
              height: 2,
              width: MediaQuery.of(context).size.width - 32,
              decoration: BoxDecoration(
                  color: Pallete.inactiveSeekColor,
                  borderRadius: BorderRadius.circular(7)),
            )),
      ]),
    );
  }
}
