import 'dart:convert';

import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/core/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@Riverpod(keepAlive: true)
// ignore: deprecated_member_use_from_same_package
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response =
          await http.post(Uri.parse('${ServerConstant.serverUrl}/auth/signup'),
              headers: {
                'Content-Type': 'application/json',
              },
              body: jsonEncode({
                'name': name,
                'email': email,
                'password': password,
              }));
      print(response.statusCode);
      if (response.statusCode != 201) {
        return Left(AppFailure(jsonDecode(response.body)['detail']));
      }

      final user = jsonDecode(response.body) as Map<String, dynamic>;

      return Right(UserModel.fromMap(user));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
          Uri.parse("${ServerConstant.serverUrl}/auth/login"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}));

      if (response.statusCode != 200) {
        return Left(AppFailure(jsonDecode(response.body)['detail']));
      }

      final user = jsonDecode(response.body) as Map<String, dynamic>;

      return Right(
          UserModel.fromMap(user['user']).copyWith(token: user['token']));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getCurrentUserData(
      {required String token}) async {
    try {
      final response = await http.get(
          Uri.parse("${ServerConstant.serverUrl}/auth/"),
          headers: {'Content-Type': 'application/json', 'x-auth-token': token});
      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      final user = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(user['detail']));
      }

      return Right(UserModel.fromMap(user).copyWith(token: token));
    } catch (e) {
      print("API Error: $e");
      return Left(AppFailure(e.toString()));
    }
  }
}
