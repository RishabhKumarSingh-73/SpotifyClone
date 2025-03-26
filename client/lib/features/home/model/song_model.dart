// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class SongModel {
  final String artist;
  final String id;
  final String hex_code;
  final String song_name;
  final String song_url;
  final String thumbnail_url;
  SongModel({
    required this.artist,
    required this.id,
    required this.hex_code,
    required this.song_name,
    required this.song_url,
    required this.thumbnail_url,
  });

  SongModel copyWith({
    String? artist,
    String? id,
    String? hex_code,
    String? song_name,
    String? song_url,
    String? thumbnail_url,
  }) {
    return SongModel(
      artist: artist ?? this.artist,
      id: id ?? this.id,
      hex_code: hex_code ?? this.hex_code,
      song_name: song_name ?? this.song_name,
      song_url: song_url ?? this.song_url,
      thumbnail_url: thumbnail_url ?? this.thumbnail_url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'artist': artist,
      'id': id,
      'hex_code': hex_code,
      'song_name': song_name,
      'song_url': song_url,
      'thumbnail_url': thumbnail_url,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      artist: map['artist'] ?? '',
      id: map['id'] ?? '',
      hex_code: map['hex_code'] ?? '',
      song_name: map['song_name'] ?? '',
      song_url: map['song_url'] ?? '',
      thumbnail_url: map['thumbnail_url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SongModel.fromJson(String source) =>
      SongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SongModel(artist: $artist, id: $id, hex_code: $hex_code, song_name: $song_name, song_url: $song_url, thumbnail_url: $thumbnail_url)';
  }

  @override
  bool operator ==(covariant SongModel other) {
    if (identical(this, other)) return true;

    return other.artist == artist &&
        other.id == id &&
        other.hex_code == hex_code &&
        other.song_name == song_name &&
        other.song_url == song_url &&
        other.thumbnail_url == thumbnail_url;
  }

  @override
  int get hashCode {
    return artist.hashCode ^
        id.hashCode ^
        hex_code.hashCode ^
        song_name.hashCode ^
        song_url.hashCode ^
        thumbnail_url.hashCode;
  }
}
