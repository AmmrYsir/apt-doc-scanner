import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../data/sources/google_drive_service.dart';

final googleDriveServiceProvider = Provider<GoogleDriveService>((ref) {
  return GoogleDriveService();
});

class UserState {
  final GoogleSignInAccount? googleAccount;
  final bool isLoading;
  final String? error;

  UserState({this.googleAccount, this.isLoading = false, this.error});

  UserState copyWith({
    GoogleSignInAccount? googleAccount,
    bool? isLoading,
    String? error,
  }) {
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
    return UserState();
  }

  Future<void> signIn() async {
    state = state.copyWith(isLoading: true);
    try {
      final googleSignIn = GoogleSignIn.instance;
      final account = await googleSignIn.authenticate();
      state = state.copyWith(googleAccount: account, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await GoogleSignIn.instance.signOut();
      state = UserState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final userProvider = NotifierProvider<UserNotifier, UserState>(() {
  return UserNotifier();
});
