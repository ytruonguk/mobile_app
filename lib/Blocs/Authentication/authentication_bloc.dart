import 'dart:async';

import 'package:blackhole/Blocs/Authentication/authentication_event.dart';
import 'package:blackhole/Blocs/Authentication/authentication_state.dart';
import 'package:blackhole/Domain/domain_layer.dart' as domain;
import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';
import './bloc.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticateState> {
  late domain.GetUser _getUser;
  late domain.CheckToken _checkToken;
  AuthenticationBloc({required domain.UserRepository userDomainRepository}) : super(InitialAuthenticationState()) {
    _getUser = domain.GetUser(userDomainRepository);
    _checkToken = domain.CheckToken(userDomainRepository);
    on<AppStarted>((event, emit) async {
      final bool hasToken = await _checkToken(domain.NoParams());
      Logger.root.info('get hasToken info', hasToken);
      if (hasToken) {
        final domain.ResponseEntity<domain.UserEntity> responseEntity =
        await _getUser(domain.NoParams());
        if (responseEntity.result != null) {
          emit(AuthenticationAuthenticated(user: responseEntity.result));
        }
      } else {
        emit(const AuthenticationUnauthenticated());
      }
    });
  }

  // @override
  // AuthenticateState get initialState => InitialAuthenticationState();
  //
  // @override
  // Stream<AuthenticateState> mapEventToState(AuthenticationEvent event) async* {
  //   final currentState = state;
  //   Logger.root.info('get hasToken info', event);
  //   if(currentState is InitialAuthenticationState) {
  //     final bool hasToken = await _checkToken(domain.NoParams()) ?? false;
  //     if(hasToken) {
  //       try {
  //         final domain.ResponseEntity<domain.UserEntity> responseEntity = await _getUser!(domain.NoParams());
  //         yield AuthenticationAuthenticated(user: responseEntity.result);
  //       } catch (error) {}
  //     } else {
  //       yield const AuthenticationUnauthenticated();
  //     }
  //   }
  //   if (event is AppStarted) {
  //     final bool hasToken = await _checkToken(domain.NoParams());
  //     Logger.root.info('get hasToken info', hasToken);
  //     if (hasToken) {
  //       final domain.ResponseEntity<domain.UserEntity> responseEntity =
  //       await _getUser(domain.NoParams());
  //       if (responseEntity.result != null) {
  //         yield AuthenticationAuthenticated(user: responseEntity.result);
  //       }
  //     } else {
  //       yield const AuthenticationUnauthenticated();
  //     }
  //   }
  // }
}