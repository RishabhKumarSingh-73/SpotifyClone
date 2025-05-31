import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongPage extends ConsumerWidget {
  const SongPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyPlayedSongs =
        ref.watch(homeViewModelProvider.notifier).getRecentlyPlayedSongs();
    final currentSong = ref.watch(currentSongNotifierProvider);
    final authViewModel = ref.watch(authViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.transparentColor,
        actions: [
          IconButton(
              onPressed: () => authViewModel.logout(), icon: Icon(Icons.logout))
        ],
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: currentSong == null
            ? null
            : BoxDecoration(
                gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  hexToRgb(currentSong.hex_code),
                  Pallete.transparentColor
                ],
                stops: const [0.0, 0.3],
              )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 36),
              child: SizedBox(
                height: 280,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: recentlyPlayedSongs.length,
                    itemBuilder: (context, index) {
                      final song = recentlyPlayedSongs[index];
                      return GestureDetector(
                        onTap: () {
                          ref
                              .watch(currentSongNotifierProvider.notifier)
                              .updateSong(song);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Pallete.borderColor,
                              borderRadius: BorderRadius.circular(6)),
                          padding: EdgeInsets.only(right: 20),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(song.thumbnail_url),
                                      fit: BoxFit.fill,
                                    ),
                                    borderRadius: BorderRadius.circular(4)),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Flexible(
                                  child: Text(
                                song.song_name,
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w700),
                                overflow: TextOverflow.ellipsis,
                              ))
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Latest Today",
                style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            ref.watch(getAllSongsProvider).when(
                  data: (songs) {
                    return SizedBox(
                      height: 260,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: songs.length,
                          itemBuilder: (context, index) {
                            final song = songs[index];
                            return GestureDetector(
                              onTap: () {
                                ref
                                    .watch(currentSongNotifierProvider.notifier)
                                    .updateSong(song);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 180,
                                      height: 180,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  song.thumbnail_url),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    SizedBox(
                                      width: 180,
                                      child: Text(
                                        song.song_name,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            overflow: TextOverflow.ellipsis),
                                        maxLines: 1,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 180,
                                      child: Text(
                                        song.artist,
                                        style: TextStyle(
                                            color: Pallete.subtitleText,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            overflow: TextOverflow.ellipsis),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    );
                  },
                  error: (error, st) {
                    return Center(
                      child: Text(
                        error.toString(),
                      ),
                    );
                  },
                  loading: () => const Loader(),
                )
          ],
        ),
      ),
    );
  }
}
