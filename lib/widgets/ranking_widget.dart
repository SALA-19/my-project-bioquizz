import 'package:flutter/material.dart';
import 'package:my_project_bioquizz/database/usuario.dart';
import 'package:my_project_bioquizz/database/usuarios.dart';

class RankingUsers extends StatelessWidget {
  final User user;

  RankingUsers(this.user);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.userImage),
      ),
      title: Text(user.name),
      trailing: Container(
        width: 60,
        child: Row(
          children: <Widget>[
            Text(user.punctiation.toString()),
          ],
        ),
      ),
    );
  }
}
