import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:my_project_bioquizz/screens/auth_home_screen.dart';
import 'package:my_project_bioquizz/screens/dados_cadastro.dart';
import 'package:my_project_bioquizz/screens/exame_screen.dart';
import 'package:my_project_bioquizz/screens/passagem.dart';
import 'package:my_project_bioquizz/screens/question_detail.dart';
import 'package:my_project_bioquizz/screens/ranking.dart';
import 'package:my_project_bioquizz/screens/show_result.dart';
import 'package:my_project_bioquizz/screens/tab_screen.dart';
import 'package:my_project_bioquizz/screens/test_mode.dart';
import 'package:my_project_bioquizz/utils/app_routes.dart';

import 'screens/home_page.dart';
import 'screens/read_mode.dart';
import 'screens/auth_screen.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bio-QuizZ',
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.deepOrange,
        fontFamily: 'Lato',
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'BioQuizz'),
      routes: <String, WidgetBuilder>{
        //'/': (context) => AuthOrHomeScreen(),
        "/homePage": (context) => TabScreen(title: 'BioQuizZ'),
        "/Auth": (context) => AuthScreen(),
        "/dadosCadastro": (context) => Cadastrar(),
        "/tabScreen": (context) => TabScreen(
              title: 'BioQuizz',
            ),
        "/Category": (context) => MyCategoryPage(title: 'Temas'),
        "/Exame": (context) => MyExamePage(),
        "/Ranking": (context) => Ranking(title: 'Ranking'),
        "/readMode": (context) => MyReadModePage(),
        "/testMode": (context) => MyTestModePage(),
        "/showResult": (context) => MyResultPage(),
        "/questionDetail": (context) => MyQuestionDetailPage(),
        "/passagem": (context) => Passagem(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, "/Auth");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
    );
  }
}
