import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:my_project_bioquizz/screens/auth_screen.dart';
import 'package:my_project_bioquizz/screens/tab_screen.dart';
import 'package:my_project_bioquizz/state/state_manager.dart';

class Atualiza extends StatefulWidget {
  @override
  _AtualizaState createState() => _AtualizaState();
}

class _AtualizaState extends State<Atualiza> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      var isAuthState = watch(authentication).state.isAuth;
      return isAuthState
          ? TabScreen(
              title: 'Bio',
            )
          : AuthScreen;
    });
  }
}
