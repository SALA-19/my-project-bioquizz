//import 'dart:js';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_project_bioquizz/database/category_provider.dart';
import 'package:my_project_bioquizz/database/db_helper.dart';
import 'package:my_project_bioquizz/state/state_manager.dart';
import 'package:flutter_riverpod/all.dart';

class MyCategoryPage extends StatefulWidget {
  final String title;

  const MyCategoryPage({Key key, this.title}) : super(key: key);

  @override
  _MyCategoryPageState createState() => _MyCategoryPageState();
}

class _MyCategoryPageState extends State<MyCategoryPage> {
  @override
  Widget build(BuildContext context) {
    // print('usuarios ${context.read(userList).state.user.last}');
/*
    final tokin = context.read(authentication).state.token;
    final id = context.read(authentication).state.userId;
    context
        .read(userList)
        .state
        .addUser(context.read(userList).state.user.last, tokin, id);*/

    Future<List<Category>> getCategories() async {
      var db = await copyDB();
      var result = await CategoryProvider().getCategories(db);
      context.read(categoryListProvider).state = result;
      return result;
    }

    return Container(
      /*decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bag.png'),
          fit: BoxFit.fill,
        ),
      ),*/
      child: FutureBuilder<List<Category>>(
        future: getCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text('${snapshot.error}'),
            );
          else if (snapshot.hasData) {
            /*Category category = new Category();
            category.ID = -1;
            category.name = 'Exame';
            category.image =
                'https://www.lexiconn.in/wp-content/uploads/2016/07/quizzes.jpg';
            snapshot.data.add(category);*/
            return GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              padding: const EdgeInsets.all(8.0),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 15.0,
              children: snapshot.data.map((category) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GridTile(
                    child: GestureDetector(
                      onTap: () {
                        context.read(questionCategoryState).state = category;
                        if (category.ID != -1) {
                          context.read(isTestMode).state = true;
                          Navigator.pushNamed(context, "/readMode");
                        } else {
                          context.read(isTestMode).state = true;
                          Navigator.pushNamed(context, "/testMode");
                        }
                      },
                      child: Image.network(
                        category.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    footer: GridTileBar(
                      backgroundColor: Colors.black87,
                      title: Text(
                        category.name,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          } else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

/*
return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.PRODUCT_DETAIL,
              arguments: product,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavorite();
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Produto adicionado com sucesso!',
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'DESFAZER',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
              cart.addItem(product);
            },
          ),
        ),
      ),
    );
    
    Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 2,
                          color: category.ID == -1 ? Colors.green : Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                category.image,
                              ),
                              AutoSizeText(
                                '${category.name}',
                                style: TextStyle(
                                  color: category.ID == -1
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                //maxLines: 1,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
    
    
    
    */
