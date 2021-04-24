import 'package:flutter_riverpod/all.dart';
import 'package:my_project_bioquizz/const/const.dart';
import 'package:sqflite/sqflite.dart';

class Question {
  int questionId, categoryId, isImageQuestion;
  String questionText,
      questionImage,
      answerA,
      answerB,
      answerC,
      answerD,
      correctAnswer;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnQuestionId: questionId,
      columnQuestionImage: questionImage,
      columnQuestionText: questionText,
      columnQuestionAnswerA: answerA,
      columnQuestionAnswerB: answerB,
      columnQuestionAnswerC: answerC,
      columnQuestionAnswerD: answerD,
      columnQuestionCorretAnswer: correctAnswer,
      columnQuestionIsImage: isImageQuestion,
      columnQuestionCategoryId: categoryId
    };
  }

  Question();
  Question.fromMap(Map<String, dynamic> map) {
    questionId = map[columnQuestionId];
    questionImage = map[columnQuestionImage];
    questionText = map[columnQuestionText];
    answerA = map[columnQuestionAnswerA];
    answerB = map[columnQuestionAnswerB];
    answerC = map[columnQuestionAnswerC];
    answerD = map[columnQuestionAnswerD];
    correctAnswer = map[columnQuestionCorretAnswer];
    isImageQuestion = map[columnQuestionIsImage];
    categoryId = map[columnQuestionCategoryId];
  }
}

class QuestionProvider {
  Future<Question> getQuestionById(Database db, int id) async {
    var maps = await db.query(tableQuestionName,
        columns: [
          columnQuestionId,
          columnQuestionImage,
          columnQuestionText,
          columnQuestionAnswerA,
          columnQuestionAnswerB,
          columnQuestionAnswerC,
          columnQuestionAnswerD,
          columnQuestionCorretAnswer,
          columnQuestionIsImage,
          columnQuestionCategoryId,
        ],
        where: '$columnQuestionId=?',
        whereArgs: [id]);
    if (maps.length > 0) return Question.fromMap(maps.first);
    return null;
  }

  Future<List<Question>> getQuestionByCategoryId(Database db, int id) async {
    var maps = await db.query(tableQuestionName,
        columns: [
          columnQuestionId,
          columnQuestionImage,
          columnQuestionText,
          columnQuestionAnswerA,
          columnQuestionAnswerB,
          columnQuestionAnswerC,
          columnQuestionAnswerD,
          columnQuestionCorretAnswer,
          columnQuestionIsImage,
          columnQuestionCategoryId,
        ],
        where: '$columnQuestionCategoryId=?',
        whereArgs: [id]);
    if (maps.length > 0)
      return maps.map((question) => Question.fromMap(question)).toList();
    return null;
  }

  Future<List<Question>> getQuestions(Database db) async {
    var maps = await db.query(tableQuestionName,
        columns: [
          columnQuestionId,
          columnQuestionImage,
          columnQuestionText,
          columnQuestionAnswerA,
          columnQuestionAnswerB,
          columnQuestionAnswerC,
          columnQuestionAnswerD,
          columnQuestionCorretAnswer,
          columnQuestionIsImage,
          columnQuestionCategoryId,
        ],
        orderBy: "Random()");
    if (maps.length > 0)
      return maps.map((question) => Question.fromMap(question)).toList();
    return null;
  }
}
