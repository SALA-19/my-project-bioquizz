import 'package:flutter/material.dart';
import 'package:my_project_bioquizz/state/state_manager.dart';
import 'package:flutter_riverpod/all.dart';

class MyExamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bag.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            Center(
              child: Container(
                height: 200,
                child: Card(
                  child: Image.network(
                    'https://super.abril.com.br/wp-content/uploads/2011/03/quais-sacc83o-e-como-funcionam-os-testes-psicolocc81gicos-usados-nas-entrevistas-de-emprego.jpeg?quality=70&strip=info&w=1024',
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              color: Colors.red,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.white),
              ),
              child: Text('Começar Exame'),
              textColor: Colors.white,
              onPressed: () {
                context.read(isTestMode).state = true;
                Navigator.pushNamed(context, "/testMode");
              },
            )
          ],
        ),
      ),
    );
  }
}
