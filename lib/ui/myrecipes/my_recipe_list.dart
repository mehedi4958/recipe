import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:recipe/data/models/models.dart';
import 'package:recipe/data/repository.dart';

class MyRecipeList extends StatefulWidget {
  const MyRecipeList({Key? key}) : super(key: key);

  @override
  State<MyRecipeList> createState() => _MyRecipeListState();
}

class _MyRecipeListState extends State<MyRecipeList> {
  List<Recipe> recipes = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildRecipeList(context),
    );
  }

  Widget _buildRecipeList(BuildContext context) {
    final repository = Provider.of<Repository>(context, listen: false);
    return StreamBuilder<List<Recipe>>(
      stream: repository.watchAllRecipes(),
      builder: (context, AsyncSnapshot<List<Recipe>> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final recipes = snapshot.data ?? [];
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (BuildContext context, int index) {
              final recipe = recipes[index];
              return SizedBox(
                height: 100,
                child: Slidable(
                  endActionPane: ActionPane(
                    extentRatio: 0.25,
                    motion: const DrawerMotion(),
                    children: <Widget>[
                      SlidableAction(
                        label: 'Delete',
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.black,
                        icon: Icons.delete,
                        onPressed: (context) =>
                            deleteRecipe(repository, recipe),
                      ),
                      SlidableAction(
                        label: 'Delete',
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.black,
                        onPressed: (context) =>
                            deleteRecipe(repository, recipe),
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 1.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: recipe.image ?? '',
                            height: 120,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(recipe.label ?? ''),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  void deleteRecipe(Repository repository, Recipe recipe) async {
    if (recipe.id != null) {
      repository.deleteRecipeIngredients(recipe.id!);
      repository.deleteRecipe(recipe);
      setState(() {});
    } else {
      print("Recipe id is null");
    }
  }
}
