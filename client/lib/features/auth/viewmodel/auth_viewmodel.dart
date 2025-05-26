import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/models/user_model.dart';
import 'package:client/features/auth/repository/auth_local_repository.dart';
import 'package:client/features/auth/repository/auth_remote_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    print("AuthViewModel Initialized");
    return null;
  }

  Future<void> initSharedPreferences() async {
    await _authLocalRepository.init();
    print("Shared Preferences Initialized");
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = AsyncValue.loading();
    final res = await _authRemoteRepository.signUp(
        name: name, email: email, password: password);

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r)
    };

    print(val);
  }

  Future<void> signInUser({
    required String email,
    required String password,
  }) async {
    state = AsyncValue.loading();
    final res =
        await _authRemoteRepository.login(email: email, password: password);

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => _loginSuccess(r)
    };

    print(val);
  }

  Future<AsyncValue<UserModel>?> _loginSuccess(UserModel user) async {
    await _authLocalRepository.setToken(user.token);
    print(user.toString());
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

  Future<UserModel?> getData() async {
    state = AsyncValue.loading();
    final token = await _authLocalRepository.getToken();
    print("Token: $token");
    if (token != null) {
      final res = await _authRemoteRepository.getCurrentUserData(token: token);
      print("API Response: $res");

      final val = switch (res) {
        Left(value: final l) => state =
            AsyncValue.error(l.message, StackTrace.current),
        Right(value: final r) => getDataSuccess(r),
      };

      return val.value;
    }
    state = AsyncValue.error("no user logged in", StackTrace.current);
    return null;
  }

  AsyncValue<UserModel> getDataSuccess(UserModel user) {
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }
}
