import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:my_project_bioquizz/main.dart';
import 'package:my_project_bioquizz/screens/dados_usuario.dart';
import 'package:my_project_bioquizz/screens/ranking.dart';
import 'exame_screen.dart';
import 'home_page.dart';
import 'package:riverpod/all.dart';
import '../state/state_manager.dart';

class TabScreen extends StatefulWidget {
  final String title;

  const TabScreen({Key key, this.title}) : super(key: key);
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _currentIndex = 0;
  List<Widget> _screen = [
    MyCategoryPage(
      title: 'Temas',
    ),
    MyExamePage(),
    Ranking(),
    DadosUsuario(),
  ];

  @override
  Widget build(BuildContext context) {
    context
        .read(userList)
        .state
        .loadUser(context.read(authentication).state.token);
    final users = context.read(userList).state.user;
    final auth = context.read(authentication).state;
    final index = users.indexWhere((use) {
      return use.uid == auth.userId;
    });
    print(index);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(users[index].userImage),
              ),
            ),
          ],
        ),
        title: Center(
          child: Text(
            widget.title,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Text(
              '${users[index].punctiation}Pts',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Consumer(
            builder: (context, watch, _) {
              var logout = watch(authentication).state;
              var aut = watch(authentication).state;
              return IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => new AlertDialog(
                              title: Text('Sair'),
                              content: Text('Deseja Sair?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); //close dialog
                                  },
                                  child: Text('Não'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    logout.logout();
                                    print('isAut do logout ${aut.isAuth}');
                                    if (aut.isAuth == false) {
                                      Navigator.pushReplacementNamed(
                                          context, '/Auth');
                                    }
                                  },
                                  child: Text('Sim'),
                                ),
                              ],
                            ));
                  });
            },
          ),
        ],
      ),
      body: _screen[_currentIndex],
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: (index) => setState(() => _currentIndex = index),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.apps),
            title: Text('Temas'),
            activeColor: Colors.red,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.border_color), //article
            title: Text('Exame'),
            activeColor: Colors.red,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.people),
            title: Text(
              'Ranking',
            ),
            activeColor: Colors.red,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.settings),
            title: Text('Configurações'),
            activeColor: Colors.red,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
