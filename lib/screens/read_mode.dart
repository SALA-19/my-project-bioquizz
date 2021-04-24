import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:my_project_bioquizz/database/category_provider.dart';
import 'package:my_project_bioquizz/database/db_helper.dart';
import 'package:my_project_bioquizz/database/question_provider.dart';
import 'package:my_project_bioquizz/model/user_answer_modal.dart';
import 'package:my_project_bioquizz/state/state_manager.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:my_project_bioquizz/utils/utils.dart';
import 'package:my_project_bioquizz/widgets/question_body.dart';
import 'package:my_project_bioquizz/widgets/question_normal_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyReadModePage extends StatefulWidget {
  final String title;

  MyReadModePage({Key key, this.title}) : super(key: key);

  @override
  _MyReadModePageState createState() => _MyReadModePageState();
}

class _MyReadModePageState extends State<MyReadModePage> {
  SharedPreferences prefs;
  int indexPage = 0;
  int longitude = 0;
  CarouselController buttonCarouselController = CarouselController();
  CarouselController carouselController = new CarouselController();
  List<UserAnswer> userAnswers = new List<UserAnswer>();

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        prefs = await SharedPreferences.getInstance();
        indexPage = await prefs.getInt(
                '${context.read(authentication).state.userId}_${context.read(questionCategoryState).state.name}_${context.read(questionCategoryState).state.ID}') ??
            0;
        longitude = await prefs.getInt(
                '${context.read(authentication).state.userId}_${context.read(questionCategoryState).state.name}_${context.read(questionCategoryState).state.ID}') ??
            0;
        print('prefs = ${context.read(authentication).state.userId}');

        if (indexPage != null) {
          Future.delayed(Duration(milliseconds: 500))
              .then((value) => carouselController.animateToPage(indexPage));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var questionModule = context.read(questionCategoryState).state;
    final users = context.read(userList).state.user;
    final auth = context.read(authentication).state;
    final index = users.indexWhere((use) {
      return use.uid == auth.userId;
    });
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            questionModule.name,
            textAlign: TextAlign.center,
          ),
          leading: GestureDetector(
            onTap: () => showCloseDialog(questionModule),
            child: Icon(Icons.arrow_back),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(top: 15, right: 15),
              child: Text(
                '${users[index].punctiation}Pts',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        body: Container(
          height: 700,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bag.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: FutureBuilder<List<Question>>(
            future: getQuestionByCategory(questionModule.ID),
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return Center(
                  child: Text('${snapshot.error}'),
                );
              else if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  return context.read(isCompleted).state
                      ? Center(
                          child: Column(
                            children: [
                              SizedBox(height: 50),
                              Center(
                                child: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 300,
                                        //height: 300,
                                        child: Image.asset(
                                          'assets/images/BLOG.png',
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(20.0),
                                        child: Text(
                                          'Parabéns o tema de "${questionModule.name}" foi concluido',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              TextButton(
                                child: Text('Reiniciar'),
                                onPressed: () {
                                  setState(() {
                                    context.read(isCompleted).state = false;
                                    context.read(currentReadPage).state = 0;
                                    prefs.setInt(
                                        '${context.read(authentication).state.userId}_${context.read(questionCategoryState).state.name}_${context.read(questionCategoryState).state.ID}',
                                        0);
                                  });
                                },
                              )
                            ],
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.all(10),
                          child: Card(
                            elevation: 8,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 4, right: 4, bottom: 4, top: 10),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text(
                                      '${longitude + 1}/${snapshot.data.length}',
                                      textAlign: TextAlign.center,
                                      // style: ,
                                    ),
                                    QuestionBodyNormal(
                                      context: context,
                                      carouselController: carouselController,
                                      questions: snapshot.data,
                                      userAnswer: userAnswers,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        context.read(isButton).state
                                            ? FloatingActionButton(
                                                child: //fazer add index no botao
                                                    new Icon(
                                                        Icons.navigate_next),
                                                onPressed: () {
                                                  carouselController.nextPage();
                                                  longitude++;
                                                  print('longe == $longitude');
                                                  setState(() {
                                                    context
                                                        .read(currentReadPage);

                                                    context
                                                        .read(isButton)
                                                        .state = false;
                                                  });
                                                  if (snapshot.data.length -
                                                          1 ==
                                                      context
                                                          .read(currentReadPage)
                                                          .state) {
                                                    setState(() {
                                                      isCompletedTheme(context);
                                                    });
                                                  }
                                                })
                                            : TextButton(
                                                onPressed: () {
                                                  showAnswer(context);
                                                  setState(() {
                                                    users[index].punctiation;
                                                    context
                                                        .read(isButton)
                                                        .state = true;
                                                  });
                                                  print(
                                                      'snap == ${snapshot.data.length} e current ==${longitude}');
                                                },
                                                child:
                                                    Text('Verificar Resposta'),
                                              ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                } else
                  return Center(
                    child: Text('Esta categoria não contem perguntas'),
                  );
              } else
                return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
      onWillPop: () async {
        showCloseDialog(questionModule);
      },
    );
  }

  showCloseDialog(Category questionModule) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: Text('Sair'),
              content: Text('Deseja abandonar o jogo?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Não'),
                ),
                TextButton(
                  onPressed: () {
                    prefs.setInt(
                        '${context.read(authentication).state.userId}_${context.read(questionCategoryState).state.name}_${context.read(questionCategoryState).state.ID}',
                        context.read(currentReadPage).state);
                    Navigator.of(context).pop(); //close dialog
                    Navigator.pop(context); //close screen
                  },
                  child: Text('Sim'),
                ),
              ],
            ));
  }

  Future<List<Question>> getQuestionByCategory(int id) async {
    var db = await copyDB();
    var result = await QuestionProvider().getQuestionByCategoryId(db, id);
    userAnswers.clear();
    result.forEach((element) {
      userAnswers.add(
        new UserAnswer(
            questionId: element.questionId, answered: '', isCorrect: false),
      );
    });
    context.read(userListAnswer).state = userAnswers;
    return result;
  }
}
