import 'package:flutter/cupertino.dart';
import 'package:my_project_bioquizz/database/question_provider.dart';
import 'package:my_project_bioquizz/database/usuario.dart';
import 'package:my_project_bioquizz/model/user_answer_modal.dart';
import 'package:my_project_bioquizz/state/state_manager.dart';
import 'package:flutter_riverpod/all.dart';

void setUserAnswer(BuildContext context, MapEntry<int, Question> e, value) {
  context.read(userListAnswer).state[e.key] =
      context.read(userAnswerSelected).state = new UserAnswer(
    questionId: e.value.questionId,
    answered: value,
    isCorrect: value.toString().isNotEmpty
        ? value.toString().toLowerCase() == e.value.correctAnswer.toLowerCase()
        : false,
  );
}

void showAnswer(BuildContext context) {
  context.read(isEnableShowAnswer).state = true;
  final users = context.read(userList).state.user;
  final auth = context.read(authentication).state;
  final index = users.indexWhere((use) {
    return use.uid == auth.userId;
  });
  if (context.read(userAnswerSelected).state.isCorrect) {
    
    users[index].punctiation += 5;
    final utilizador = new User(
      id: users[index].id,
      uid: users[index].uid,
      name: users[index].name,
      punctiation: users[index].punctiation,
      userImage: users[index].userImage,
    );
    context.read(userList).state.updateUser(utilizador, auth.token);
  }
}

void isCompletedTheme(BuildContext context) {
  context.read(isCompleted).state = true;
}
