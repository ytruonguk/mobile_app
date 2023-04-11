import 'package:blackhole/Blocs/Login/bloc.dart';
import 'package:blackhole/Screens/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _textPasswordFocusNode = FocusNode();
  final _textEmailFocusNode = FocusNode();
  late LoginBloc _loginBloc;

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _loginBloc.close();
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _usernameController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  void _onEmailChanged() {
    _loginBloc.add(
      EmailChanged(email: _usernameController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  Widget formBuilder() {
    void onLoginButtonPressed() {
      _loginBloc.add(LoginButtonPressed(
        username: _usernameController.text,
        password: _passwordController.text,
      ));
    }
    return BlocBuilder<LoginBloc, LoginState>(
        bloc: _loginBloc,
        builder: (context, state) {
          return Form(
              child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 5,
                  bottom: 5,
                  left: 10,
                  right: 10,
                ),
                height: 57.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[900],
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5.0,
                      offset: Offset(0.0, 3.0),
                    )
                  ],
                ),
                child: TextFormField(
                  controller: _usernameController,
                  textAlignVertical: TextAlignVertical.center,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.emailAddress,
                  onFieldSubmitted: (String value) {
                    FocusScope.of(context)
                        .requestFocus(_textPasswordFocusNode);
                  },
                  // autovalidateMode: AutovalidateMode.always,
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Colors.transparent,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    border: InputBorder.none,
                    hintText: AppLocalizations.of(context)!.enterName,
                    hintStyle: const TextStyle(
                      color: Colors.white60,
                    ),
                  ),
                  focusNode: _textEmailFocusNode,
                  validator: (value) {
                    final bool emailValid = RegExp(
                        r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                        .hasMatch(value!);
                    if (value.isEmpty) {
//                                return S.of(context).error_empty_value;
                      return null;
                    } else if (!emailValid) {
                      return 'Email is invalid';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                padding: const EdgeInsets.only(
                  top: 5,
                  bottom: 5,
                  left: 10,
                  right: 10,
                ),
                height: 57.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[900],
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5.0,
                      offset: Offset(0.0, 3.0),
                    )
                  ],
                ),
                child: TextField(
                  controller: _passwordController,
                  textAlignVertical: TextAlignVertical.center,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Colors.transparent,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.password,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    border: InputBorder.none,
                    hintText: 'Enter your password',
                    hintStyle: const TextStyle(
                      color: Colors.white60,
                    ),
                  ),
                  onSubmitted: (String value) async {},
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final emailValid = RegExp(
                      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',);
                  if (_usernameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Email is empty',),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (!emailValid
                      .hasMatch(_usernameController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                        Text('Email is invalid'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (state is! LoginLoading) {
                    onLoginButtonPressed();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  height: 55.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Theme.of(context).colorScheme.secondary,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5.0,
                        offset: Offset(0.0, 3.0),
                      )
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Log-in',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      bloc: _loginBloc,
      listener: (context, state) {
        if (state is LoginFailure) {
          final Route route = MaterialPageRoute(builder: (context) => HomePage());
          Navigator.pushReplacement(context, route);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(
          //         state.toString(),),
          //     backgroundColor: Colors.red,
          //   ),
          // );
        }
        if (state is LoginSuccess) {
          final Route route = MaterialPageRoute(builder: (context) => HomePage());
          Navigator.pushReplacement(context, route);
          // Navigator.pop(context);
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
            ),
            child: Column(
              children: [
                formBuilder(),
                SocialLoginButton(
                  buttonType: SocialLoginButtonType.apple,
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                SocialLoginButton(
                  buttonType: SocialLoginButtonType.facebook,
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                SocialLoginButton(
                  buttonType: SocialLoginButtonType.google,
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                SocialLoginButton(
                  buttonType: SocialLoginButtonType.microsoft,
                  onPressed: () {},
                ),
                GestureDetector(
                  onTap: () async {},
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    height: 55.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Theme.of(context).colorScheme.secondary,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5.0,
                          offset: Offset(0.0, 3.0),
                        )
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
