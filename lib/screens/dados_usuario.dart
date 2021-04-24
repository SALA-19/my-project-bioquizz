import 'package:flutter/material.dart';
import 'package:my_project_bioquizz/database/usuario.dart';
import 'package:my_project_bioquizz/database/usuarios.dart';
import '../state/state_manager.dart';
import 'package:flutter_riverpod/all.dart';

class DadosUsuario extends StatefulWidget {
  @override
  _DadosUsuarioState createState() => _DadosUsuarioState();
}

class _DadosUsuarioState extends State<DadosUsuario> {
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
      final users = context.read(userList).state.user;
      final auth = context.read(authentication).state;
      print(users.first.uid);
      final index = users.indexWhere((use) {
        return use.uid == auth.userId;
      });

      if (users != null) {
        _formData['nome'] = users[index].name;
        _formData['imageUrl'] = users[index].userImage;
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
    // bool endsWithPng = url.toLowerCase().endsWith('.png');
    // bool endsWithJpg = url.toLowerCase().endsWith('.jpg');
    //bool endsWithJpeg = url.toLowerCase().endsWith('.jpeg');
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
    //final user = ModalRoute.of(context).settings.arguments as Usuarios;
    final users = context.read(userList).state.user;
    final auth = context.read(authentication).state;
    final index = users.indexWhere((use) {
      return use.uid == auth.userId;
    });
    if (!_form.currentState.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();

    final utilizador = User(
      id: users[index].id,
      uid: users[index].uid,
      name: _formData['nome'],
      punctiation: users[index].punctiation,
      userImage: _formData['imageUrl'],
    );

    // Auth auth = context.read(authentication).state;

    print('id usuario ${auth.userId}');

    print(_formData['nome']);
    try {
      await context.read(userList).state.updateUser(utilizador, auth.token);

      print('Modo Atualizar');
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro!'),
          content: Text('Ocorreu um erro pra salvar o produto!'),
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
    showDialog<Null>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Feito'),
        content: Text('Alterações feitas com sucesso'),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Form(
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
                initialValue: _formData['imageUrl'],
                decoration: new InputDecoration(
                  hintText: "Cole aqui o Url da imagem que deseja usar",
                ),
                keyboardType: TextInputType.url,
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
                child: Text('ACTUALIZAR DADOS'),
                onPressed: _submit,
              ),
          ],
        ),
      ),
    );
  }
}

/*
  Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _formData['Nome'],
                decoration:
                    InputDecoration(labelText: 'Insira um nome de usuário'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_nomeFocusNode);
                },
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Insira o Url da imagem para perfil'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _imageUrlFocusNode,
                      controller: _imageUrlController,
                      onFieldSubmitted: (_) {
                        // _saveForm();
                      },
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
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? Text('Informe a URL')
                        : Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
  
  
  */
