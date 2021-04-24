import 'package:flutter/material.dart';
import 'package:my_project_bioquizz/database/dummy.dart';
import 'package:my_project_bioquizz/database/usuario.dart';
import 'package:my_project_bioquizz/database/usuarios.dart';
import 'package:my_project_bioquizz/state/state_manager.dart';
import 'package:my_project_bioquizz/widgets/ranking_widget.dart';
import 'package:flutter_riverpod/all.dart';

class Ranking extends StatefulWidget {
  final String title;

  const Ranking({Key key, this.title}) : super(key: key);
  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  Future<void> _refreshUsers() {
    return context
        .read(userList)
        .state
        .loadUser(context.read(authentication).state.token);
  }

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    context
        .read(userList)
        .state
        .loadUser(context.read(authentication).state.token)
        .then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final usu = context.read(userList).state.user;
    usu.sort((a, b) => b.punctiation.compareTo(a.punctiation));
    //context.read(userList).state[] = DUMMY_USER[];
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 0),
                  padding: EdgeInsets.only(top: 0),
                  alignment: Alignment.topLeft,
                  height: 30,
                  child: ListTile(
                    onTap: null,
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Container(
                          child: Expanded(
                              child: Text('Pos.',
                                  style: TextStyle(color: Colors.grey)))),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(children: <Widget>[
                        Expanded(
                          child: Text("       #Nome",
                              style: TextStyle(color: Colors.grey)),
                        ),
                      ]),
                    ),
                    trailing: Container(
                      width: 80,
                      child: Row(
                        children: <Widget>[
                          Text('#Pontos', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.red,
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshUsers,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: ListView.builder(
                        itemCount: context.read(userList).state.usersCount,
                        itemBuilder: (ctx, i) => Column(
                          children: <Widget>[
                            /* Container(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  child: CircleAvatar(
                                      child: Text('${i + 1}',
                                          textAlign: TextAlign.left)),
                                )),*/
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 3),
                                  width: 20,
                                  height: 20,
                                  child: i == 0
                                      ? Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        )
                                      : Text('${i + 1}º'),
                                ),
                                Expanded(child: RankingUsers(usu[i])),
                              ],
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
