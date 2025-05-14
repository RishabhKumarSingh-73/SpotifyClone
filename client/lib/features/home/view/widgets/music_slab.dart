import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);

    if (currentSong == null) {
      return Container();
    }
    return Container(
      height: 66,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: hexToRgb(currentSong.hex_code),
      ),
      padding: EdgeInsets.all(9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      currentSong.thumbnail_url,
                    ),
                    fit: BoxFit.cover,
                  ),
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
                onPressed: () {},
                icon: Icon(Icons.favorite_outline),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.play_arrow),
              )
            ],
          )
        ],
      ),
    );
  }
}
