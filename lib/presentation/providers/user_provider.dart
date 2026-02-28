import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer' as developer;
import 'package:googleapis/drive/v3.dart' as drive;

class UserState {
  final GoogleSignInAccount? googleAccount;
  final bool isLoading;
  final String? error;

  UserState({this.googleAccount, this.isLoading = false, this.error});

  UserState copyWith({GoogleSignInAccount? googleAccount, bool? isLoading, String? error}) {
    return UserState(
      googleAccount: googleAccount ?? this.googleAccount,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class UserNotifier extends Notifier<UserState> {
  static const String _serverClientId =
      '495963136299-oi3l56pme12ensmet9rq4qis6u8r4eug.apps.googleusercontent.com';

  @override
  UserState build() {
    Future.microtask(() => _init());
    return UserState();
  }

  Future<void> _init() async {
    print('DEBUG: UserNotifier _init()');
    try {
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        serverClientId: _serverClientId,
      );
      final account = await googleSignIn.attemptLightweightAuthentication();
      if (account != null) {
        print('DEBUG: Found existing account: ${account.email}');
        state = state.copyWith(googleAccount: account);
      } else {
        print('DEBUG: No existing account found.');
      }
    } catch (e) {
      print('DEBUG: Initial auth error: $e');
    }
  }

  Future<void> signIn() async {
    print('DEBUG: signIn() triggered');
    state = state.copyWith(isLoading: true, error: null);
    try {
      final googleSignIn = GoogleSignIn.instance;
      // Ensure initialized
      await googleSignIn.initialize(
        serverClientId: _serverClientId,
      );

      final account = await googleSignIn.authenticate();
      print('DEBUG: Sign in success: ${account.email}');
      state = state.copyWith(googleAccount: account, isLoading: false);
    } catch (e) {
      print('DEBUG: Sign in error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await GoogleSignIn.instance.signOut();
      state = UserState();
    } catch (e) {
      print('DEBUG: Sign out error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final userProvider = NotifierProvider<UserNotifier, UserState>(() {
  return UserNotifier();
});
