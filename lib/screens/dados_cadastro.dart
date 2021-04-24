import 'package:flutter/material.dart';
import 'package:my_project_bioquizz/database/usuario.dart';
import '../state/state_manager.dart';
import 'package:flutter_riverpod/all.dart';

class Cadastrar extends StatefulWidget {
  @override
  _CadastrarState createState() => _CadastrarState();
}

class _CadastrarState extends State<Cadastrar> {
  final _nomeFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final user = ModalRoute.of(context).settings.arguments as User;

      if (user != null) {
        _formData['id'] = user.id;
        _formData['nome'] = user.name;
        _formData['imageUrl'] = user.userImage;

        _imageUrlController.text = _formData['imageUrl'];
      }
    }
  }

  void _updateImage() {
    if (isValidImageUrl(_imageUrlController.text)) {
      setState(() {});
    }
  }

  bool isValidImageUrl(String url) {
    bool startWithHttp = url.toLowerCase().startsWith('http://');
    bool startWithHttps = url.toLowerCase().startsWith('https://');
    return (startWithHttp || startWithHttps);
  }

  @override
  void dispose() {
    super.dispose();
    _nomeFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImage);
    _imageUrlFocusNode.dispose();
  }

  Future<void> _submit() async {
    context
        .read(userList)
        .state
        .loadUser(context.read(authentication).state.token);
    if (!_form.currentState.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();
    //print(_authData['email']);
    //print(_authData['password']);

    /* final utilizador = User(
        id: context.read(authentication).state.,
        name: _formData['name'],
        punctiation: 0,
        userImage: null);*/

    // Auth auth = context.read(authentication).state;
    final users = context.read(userList).state;
    final auth = context.read(authentication).state;
    try {
      if (_formData['id'] == null) {
        await users.addUser(
          User(
              uid: auth.userId,
              name: _formData['nome'],
              punctiation: 0,
              userImage: _formData['imageUrl']),
          auth.token,
        );
        Navigator.pushReplacementNamed(context, '/homePage');
        print('Modo Registrar');
      }
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro!'),
          content: Text('Verifique a conexão com a internet!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Fechar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 80,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(
              'assets/images/Bioquizz.jpg',
            ),
          ),
          Form(
            key: _form,
            child: new Column(
              children: <Widget>[
                new ListTile(
                  leading: const Icon(Icons.person),
                  title: new TextFormField(
                    initialValue: _formData['nome'],
                    decoration: new InputDecoration(
                      hintText: "Seu nome de usuário",
                    ),
                    onSaved: (value) => _formData['nome'] = value,
                    validator: (value) {
                      bool isEmpty = value.trim().isEmpty;
                      bool isInvalid = value.trim().length < 3;

                      if (isEmpty || isInvalid) {
                        return 'Informe um Nome válido com no mínimo 3 caracteres!';
                      }

                      return null;
                    },
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.image),
                  title: new TextFormField(
                    decoration: new InputDecoration(
                      hintText: "Cole aqui o Url da imagem que deseja usar",
                    ),
                    keyboardType: TextInputType.url,
                    controller: _imageUrlController,
                    onSaved: (value) => _formData['imageUrl'] = value,
                    validator: (value) {
                      bool isEmpty = value.trim().isEmpty;
                      bool isInvalid = !isValidImageUrl(value);

                      if (isEmpty || isInvalid) {
                        return 'Informe uma URL válida!';
                      }

                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 8.0,
                    ),
                    child: Text('REGISTRAR'),
                    onPressed: _submit,
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
