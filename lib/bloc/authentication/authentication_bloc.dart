import 'dart:html';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero_let_pack_game/repositories/userRepository.dart';
part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  AuthenticationBloc(this._userRepository);
  @override
  AuthenticationState get initialState => AuthenticationInitial();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStared) {
      yield* _mapAppStaredToSate();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStaredToSate() async* {
    try {
      final isSigneIn = await _userRepository.isSigneIn();
      if (isSigneIn) {
        final uid = await _userRepository.getuser();
        final isFirstTime = await _userRepository.isFirstTime(uid);
        if (!isFirstTime) {
          yield AuthenticatedButNotSet(uid);
        } else {
          yield Authenticated(uid);
        }
      } else {
        yield AuthenticationInitial();
      }
    } catch (_) {
      yield AuthenticationInitial();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    final isFirstTime =
        await _userRepository.isFirstTime(await _userRepository.getuser());
    if (!isFirstTime) {
      yield AuthenticatedButNotSet(await _userRepository.getuser());
    } else {
      yield Authenticated(await _userRepository.getuser());
    }
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield AuthenticationInitial();
    _userRepository.signOut();
  }
}
