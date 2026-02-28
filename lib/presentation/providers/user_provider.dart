import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer' as developer;

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
  @override
  UserState build() {
    _init();
    return UserState();
  }

  Future<void> _init() async {
    print('DEBUG: UserNotifier _init()');
    try {
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();
      final account = await googleSignIn.attemptLightweightAuthentication();
      if (account != null) {
        print('DEBUG: Found lightweight account: ${account.email}');
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
      print('DEBUG: Calling authenticate()...');
      final account = await googleSignIn.authenticate();
      print('DEBUG: Sign in success: ${account?.email}');
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
      developer.log('Sign out error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final userProvider = NotifierProvider<UserNotifier, UserState>(() {
  return UserNotifier();
});
