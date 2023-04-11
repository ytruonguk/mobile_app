import 'dart:async';
import 'dart:math';

import 'package:blackhole/Blocs/Authentication/bloc.dart';
import 'package:blackhole/Blocs/Login/bloc.dart';
import 'package:blackhole/Domain/domain_layer.dart';
import 'package:blackhole/Utils/strings.util.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc authenticationBloc;
  late Login _login;

  LoginBloc({required UserRepository userRepository, required this.authenticationBloc}) : super(InitialLoginState()) {
    _login = Login(userRepository);
    on<EmailChanged>((event, emit) {
      _mapEmailChangedToState(event.email, emit);
    }, transformer: debounceSequential(const Duration(milliseconds: 100)),);

    on<PasswordChanged>((event, emit) {
      _mapPasswordChangedToState(event.password, emit);
    });

    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      try {
        final ResponseEntity? responseEntity = await _login!(LoginParams(email: event.username, password: event.password));
        if (responseEntity != null && responseEntity.token != null) {
          final String token = responseEntity.token ?? '';
          authenticationBloc.add(LoggedIn(token: token));
          emit(LoginSuccess());
        } else {
          emit(const LoginFailure(message: 'loi deo gi'));
        }
      } catch (error) {
        if (error.toString().isNotEmpty &&
            error.toString().contains('error_type')) {
          emit(LoginFailure(message: e.toString()));
        } else {
          emit(const LoginFailure(message: 'Unexpected error'));
        }
      }
    });
  }

  EventTransformer<LoginEvent> debounceSequential<LoginEvent>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).asyncExpand(mapper);
  }

  // @override
  // Stream<LoginState> mapEventToState(LoginEvent event) async* {
  //   if(event is EmailChanged) {
  //     yield* _mapEmailChangedToState(event.email);
  //   } else if(event is PasswordChanged) {
  //     yield* _mapPasswordChangedToState(event.password);
  //   } else if(event is LoginButtonPressed) {
  //     yield LoginLoading();
  //     try {
  //       final ResponseEntity? responseEntity = await _login!(LoginParams(email: event.username, password: event.password));
  //       if (responseEntity != null && responseEntity.token != null) {
  //         final String token = responseEntity.token ?? '';
  //         authenticationBloc.add(LoggedIn(token: token));
  //         yield LoginSuccess();
  //       } else {
  //         yield const LoginFailure(message: 'loi deo gi');
  //       }
  //     } catch (error) {
  //       if (error.toString().isNotEmpty &&
  //           error.toString().contains('error_type')) {
  //         yield LoginFailure(message: e.toString());
  //       } else {
  //         yield const LoginFailure(message: 'Unexpected error');
  //       }
  //     }
  //   }
  // }

  Stream<void> _mapEmailChangedToState(String email, Emitter emit) async* {
    if (state is LoginValid) {
      emit((state as LoginValid).update(
          isEmailValid: email.isNotEmpty &&
              StringUtil.isValidEmail(email),));
    } else {
      emit(LoginValid(
        isEmailValid:
        email.isNotEmpty && StringUtil.isValidEmail(email),
      ),);
    }
  }

  Stream<void> _mapPasswordChangedToState(String password, Emitter emit) async* {
    if (state is LoginValid) {
      emit((state as LoginValid).update(
          isPasswordValid: password.isNotEmpty &&
              password.trim().isNotEmpty,),);
    } else {
      emit(LoginValid(
        isPasswordValid: password.isNotEmpty &&
            password.trim().isNotEmpty,
      ),);
    }
  }

  // @override
  // Stream<LoginState>? transformEvents(Stream<LoginEvent> events,
  //     Stream<LoginState> Function(LoginEvent event) next) {
  //   final nonDebounceStream = events.where((event) {
  //     return (event is! EmailChanged && event is! PasswordChanged);
  //   });
  //   final debounceStream = events.where((event) {
  //     return event is EmailChanged || event is PasswordChanged;
  //   }).debounceTime(Duration(milliseconds: 100));
  //   return super
  //       .transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  // }

}