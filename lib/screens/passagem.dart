import 'package:flutter/material.dart';

class Passagem extends StatefulWidget {
  @override
  _PassagemState createState() => _PassagemState();
}

class _PassagemState extends State<Passagem> {
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, "/homePage");
    });
  }

  @override
  Widget build(BuildContext context) {
    print('passei');
    return Scaffold(
      appBar: AppBar(
        title: Text('Aguarde'),
      ),
    );
  }
}
