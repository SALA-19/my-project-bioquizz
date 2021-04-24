import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:my_project_bioquizz/const/const.dart';
import 'package:my_project_bioquizz/database/db_helper.dart';
import 'package:my_project_bioquizz/database/question_provider.dart';
import 'package:my_project_bioquizz/model/user_answer_modal.dart';
import 'package:my_project_bioquizz/state/state_manager.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:my_project_bioquizz/widgets/count_down.dart';
import 'package:my_project_bioquizz/widgets/question_body.dart';

class MyTestModePage extends StatefulWidget {
  final String title;

  MyTestModePage({Key key, this.title}) : super(key: key);
  @override
  _MyTestModePageState createState() => _MyTestModePageState();
}

class _MyTestModePageState extends State<MyTestModePage>
    with SingleTickerProviderStateMixin {
  CarouselController carouselController = new CarouselController();
  List<UserAnswer> userAnswers = new List<UserAnswer>();
  AnimationController _controller;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_controller.isAnimating || _controller.isCompleted) _controller.dispose;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: limitTime));
    _controller.addListener(() {
      if (_controller.isCompleted) {
        Navigator.pop(context);
        Navigator.pushNamed(context, "/showResult"); //show result
      }
    });
    _controller.forward(); //start
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Exame'),
          leading: GestureDetector(
            onTap: () => showCloseExamDialog(),
            child: Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //folha de respostas
                  TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => new AlertDialog(
                                title: Text('Suas Respostas'),
                                content: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: GridView.count(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1.0,
                                    padding: const EdgeInsets.all(4.0),
                                    mainAxisSpacing: 4.0,
                                    crossAxisSpacing: 4.0,
                                    children: context
                                        .read(userListAnswer)
                                        .state
                                        .asMap()
                                        .entries
                                        .map((e) {
                                      return GestureDetector(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: AutoSizeText(
                                            'Nº ${e.key + 1}:${e.value.answered == null || e.value.answered.isEmpty ? '' : e.value.answered}',
                                            style: TextStyle(
                                              fontWeight: (e.value.answered !=
                                                          null &&
                                                      !e.value.answered.isEmpty)
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          carouselController
                                              .animateToPage(e.key);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      //close dialog
                                    },
                                    child: Text('Fechar'),
                                  ),
                                ],
                              ));
                    },
                    child: Column(
                      children: [Icon(Icons.note), Text('Folha de respostas')],
                    ),
                  ),
                  Countdown(
                    animation: StepTween(begin: limitTime, end: 0)
                        .animate(_controller),
                  ),
                  TextButton(
                    onPressed: () {
                      showfinishDialog();
                    },
                    child: Column(
                      children: [Icon(Icons.done), Text('Terminar')],
                    ),
                  ),
                ],
              ),
              FutureBuilder(
                future: getQuestion(),
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    return Center(
                      child: Text('${snapshot.error}'),
                    );
                  else if (snapshot.hasData) {
                    return Container(
                      margin: const EdgeInsets.all(0.4),
                      child: Card(
                        elevation: 8,
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 4, right: 4, bottom: 4, top: 10),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                QuestionBody(
                                  context: context,
                                  carouselController: carouselController,
                                  questions: snapshot.data,
                                  userAnswer: userAnswers,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                },
              )
            ],
          ),
        ),
      ),
      onWillPop: () async {
        showCloseExamDialog();
        return true;
      },
    );
  }

  void showCloseExamDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: Text('Sair'),
              content: Text('Você dejesa sair do modo exame ?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); //close dialog
                  },
                  child: Text('Não'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pop(context);
                  },
                  child: Text('Sim'),
                ),
              ],
            ));
  }

//prestar atenção
  Future<List<Question>> getQuestion() async {
    var db = await copyDB();
    var result = await QuestionProvider().getQuestions(db);
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

  void showfinishDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: Text('Terminar'),
              content: Text('Você dejesa terminar o Exame ?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); //close dialog
                  },
                  child: Text('Não'),
                ),
                TextButton(
                  onPressed: () {
                    context.read(userListAnswer).state = userAnswers;
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed("/showResult");
                    _controller.dispose;
                  },
                  child: Text('Sim'),
                ),
              ],
            ));
  }
}
