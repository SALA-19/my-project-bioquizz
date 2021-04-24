import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:my_project_bioquizz/database/auth.dart';
import 'package:my_project_bioquizz/screens/tab_screen.dart';
import 'package:my_project_bioquizz/state/state_manager.dart';
import './auth_screen.dart';
/*
class AuthOrHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Auth auth = context.read(authentication).state;
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(child: Text('Ocorreu um erro!'));
        } else {
          return auth.isAuth ? TabScreen(title: 'BioQuizZ') : AuthScreen();
        }
      },
    );
  }
}*/

class AuthOrHomeScreen extends StatefulWidget {
  @override
  _AuthOrHomeScreenState createState() => _AuthOrHomeScreenState();
}

class _AuthOrHomeScreenState extends State<AuthOrHomeScreen> {
  bool auth;
  @override
  void entrar() {
    if (context.read(authentication).state.isAuth) {
      setState(() {
        auth = true;
      });
    } else {
      auth = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    //var auth = context.read(authentication).state;
    return FutureBuilder(
      future: context.read(authentication).state.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(child: Text('Ocorreu um erro!'));
        } else {
          return context.read(authentication).state.isAuth
              ? TabScreen(title: 'BioQuizZ')
              : AuthScreen();
        }
      },
    );

    /*
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(child: Text('Ocorreu um erro!'));
        } else {
          return auth.isAuth ? TabScreen(title: 'BioQuizZ') : AuthScreen();
        }
      },
    );*/
  }
}
