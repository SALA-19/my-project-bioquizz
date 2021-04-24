import 'dart:convert';
import 'package:flutter_riverpod/all.dart';
import 'package:my_project_bioquizz/database/auth.dart';
import 'package:my_project_bioquizz/database/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:my_project_bioquizz/state/state_manager.dart';

class Usuarios {
  final String _baseUrl =
      'https://bioquizz-a92d7-default-rtdb.firebaseio.com/usuario';
  List<User> _users = [];
  List<User> get user => [..._users];

  int get usersCount {
    return _users.length;
  }

  Future<void> loadUser(String _token) async {
    //print('token do usuario $_token');
    final response = await http.get('$_baseUrl.json?auth=$_token');
    // print(json.decode(response.body));

    Map<String, dynamic> data = json.decode(response.body);
    _users.clear();
    data.forEach((userId, userData) {
      _users.add(User(
        id: userId,
        uid: userData['uid'],
        name: userData['name'],
        punctiation: userData['punctiation'],
        userImage: userData['userImage'],
      ));
    });
    return Future.value();
  }

  Future<void> addUser(User user, String _token) async {
    final response = await http.post(
      '$_baseUrl.json?auth=$_token',
      body: json.encode({
        'uid': user.uid,
        'name': user.name,
        'punctiation': user.punctiation,
        'userImage': user.userImage,
      }),
    );
    print('foi adicionado');
    _users.add(User(
      id: json.decode(response.body)['name'],
      uid: user.uid,
      name: user.name,
      punctiation: user.punctiation,
      userImage: user.userImage,
    ));
  }

  Future<void> updateUser(User user, String _token) async {
    if (user == null || user.id == null) {
      return;
    }

    final index = _users.indexWhere((use) => use.id == user.id);
    if (index >= 0) {
      await http.patch(
        "$_baseUrl/${user.id}.json?auth=$_token",
        body: json.encode({
          'name': user.name,
          'punctiation': user.punctiation,
          'userImage': user.userImage,
        }),
      );
      _users[index] = user;
    }
  }

  Future<void> updatePoints(String id, int points) async {
    final url = '$_baseUrl/$id.json';
    await http.patch(
      url,
      body: json.encode({
        'punctiation': points,
      }),
    );
  }
}
