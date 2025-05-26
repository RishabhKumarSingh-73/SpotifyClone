import 'dart:io';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/model/fav_song_model.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repository/home_local_repository.dart';
import 'package:client/features/home/repository/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(GetAllSongsRef ref) async {
  final token = ref.watch(currentUserNotifierProvider)!.token;

  final res = await ref.watch(homeRepositoryProvider).getAllSong(
        token: token,
      );

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<SongModel>> getAllFavSongs(Ref ref) async {
  final token = ref.watch(currentUserNotifierProvider)!.token;

  final res = await ref.watch(homeRepositoryProvider).getAllFavSong(
        token: token,
      );

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;

  AsyncValue? build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    _homeRepository = ref.watch(homeRepositoryProvider);
    return null;
  }

  Future<void>? uploadSong({
    required File selectedAudio,
    required File selectedImage,
    required String artist,
    required String songName,
    required Color selectedColor,
  }) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.uploadSong(
        selectedAudio: selectedAudio,
        selectedImage: selectedImage,
        artist: artist,
        songName: songName,
        hexCode: rgbToHex(selectedColor),
        token: ref.read(currentUserNotifierProvider)!.token);

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r)
    };
    print(val);
  }

  List<SongModel> getRecentlyPlayedSongs() {
    return _homeLocalRepository.loadSong();
  }

  Future<void>? favSong({required String songId}) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.favSong(
        songId: songId, token: ref.read(currentUserNotifierProvider)!.token);

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => _favSongSuccess(r, songId)
    };
    print(val);
  }

  AsyncValue _favSongSuccess(bool isFav, String songId) {
    final userNotifier = ref.read(currentUserNotifierProvider.notifier);
    if (isFav) {
      userNotifier
          .addUser(ref.read(currentUserNotifierProvider)!.copyWith(favourites: [
        ...ref.read(currentUserNotifierProvider)!.favourites,
        FavSongModel(id: '', song_id: songId, user_id: '')
      ]));
    } else {
      userNotifier.addUser(ref.read(currentUserNotifierProvider)!.copyWith(
          favourites: ref
              .read(currentUserNotifierProvider)!
              .favourites
              .where(
                (fav) => fav.song_id != songId,
              )
              .toList()));
    }
    return state = AsyncValue.data(isFav);
  }
}
