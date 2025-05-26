import 'dart:convert';
import 'dart:io';

import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong(
      {required File selectedAudio,
      required File selectedImage,
      required String artist,
      required String songName,
      required String hexCode,
      required String token}) async {
    try {
      final request = await http.MultipartRequest(
          'POST', Uri.parse("${ServerConstant.serverUrl}/song/upload"));

      request
        ..files.addAll([
          await http.MultipartFile.fromPath('song', selectedAudio.path),
          await http.MultipartFile.fromPath('thumbnail', selectedImage.path),
        ])
        ..fields.addAll(
            {'artist': artist, 'song_name': songName, 'hex_code': hexCode})
        ..headers.addAll({'x-auth-token': token});

      final res = await request.send();

      if (res.statusCode != 201) {
        return Left(AppFailure(await res.stream.bytesToString()));
      }

      return Right(await res.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllSong({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse("${ServerConstant.serverUrl}/song/list"),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      var resBodyMap = jsonDecode(res.body);

      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap['detail']));
      }

      resBodyMap = resBodyMap as List;
      List<SongModel> songs = [];

      for (final map in resBodyMap) {
        songs.add(SongModel.fromMap(map));
      }

      return Right(songs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> favSong({
    required String token,
    required String songId,
  }) async {
    try {
      final res = await http.post(
          Uri.parse("${ServerConstant.serverUrl}/song/favourite"),
          headers: {'Content-Type': 'application/json', 'x-auth-token': token},
          body: jsonEncode({
            'song_id': songId,
          }));

      var resBodyMap = jsonDecode(res.body);

      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap['message']));
      }

      return Right(resBodyMap['message']);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllFavSong({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse("${ServerConstant.serverUrl}/song/list/favourites"),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      var resBodyMap = jsonDecode(res.body);

      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap['detail']));
      }

      resBodyMap = resBodyMap as List;
      List<SongModel> songs = [];

      for (final map in resBodyMap) {
        songs.add(SongModel.fromMap(map['song']));
      }

      return Right(songs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
