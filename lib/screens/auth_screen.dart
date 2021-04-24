import 'package:flutter/material.dart';
import 'package:my_project_bioquizz/widgets/auth_card.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
            /*
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 99, 71, 0.5),
                Color.fromRGBO(178, 34, 34, 0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),*/
            ),
        Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                /*padding: EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 40,
                ),*/
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  /* boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black26,
                      offset: Offset(0, 4),
                    ),
                  ],*/
                ),
                child: Image.asset(
                  'assets/images/Bioquizz.jpg',
                ),
              ),
              AuthCard(),
            ],
          ),
        ),
      ]),
    );
  }
}
