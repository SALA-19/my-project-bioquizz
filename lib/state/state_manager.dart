import 'package:flutter_riverpod/all.dart';
import 'package:my_project_bioquizz/database/auth.dart';
import 'package:my_project_bioquizz/database/category_provider.dart';
import 'package:my_project_bioquizz/database/question_provider.dart';
import 'package:my_project_bioquizz/database/usuario.dart';
import 'package:my_project_bioquizz/database/usuarios.dart';

import 'package:my_project_bioquizz/model/user_answer_modal.dart';

final categoryListProvider =
    StateNotifierProvider((ref) => new CategoryList([]));
final questionCategoryState = StateProvider((ref) => new Category());
final isTestMode = StateProvider((ref) => false);
final currentReadPage = StateProvider((ref) => 0);
final userAnswerSelected = StateProvider((ref) => new UserAnswer());
final isEnableShowAnswer = StateProvider((ref) => false);
final userListAnswer = StateProvider((ref) => List<UserAnswer>());
final userViewQuestionState = StateProvider((ref) => new Question());
final authentication = StateProvider((ref) => new Auth());
final userList = StateProvider((ref) => new Usuarios());
final isButton = StateProvider((ref) => false);
final isAuten = StateProvider((ref) => false);
final isCompleted = StateProvider((ref) => false);
final nCorretAnswer = StateProvider((ref) => 0);
