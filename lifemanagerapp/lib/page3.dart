import 'package:flutter/material.dart';
import 'course_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  List<CourseItem> courseItems = [];
  List<CourseItem> favoriteItems = [];
  List<Map<String, dynamic>> categories = [];
  String? selectedCategoryId;
  String? selectedCategoryIdToAdd;
  int? selectedQuantity;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchArticles();
    fetchArticlesFav();
  }

  Future<void> fetchCategories() async {
    final response =
        await http.get(Uri.parse('http://localhost:8000/courses/categorie'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        categories = data
            .map<Map<String, dynamic>>((category) => {
                  'id': category['Id'].toString(),
                  'name': category['Categorie_Name'].toString(),
                })
            .toList();
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> fetchArticles() async {
    final response =
        await http.get(Uri.parse('http://localhost:8000/courses/get'));

    if (response.statusCode == 200) {
      if (json.decode(response.body) != null) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        courseItems = data
            .map<CourseItem>((item) => CourseItem(
                  id: item['Id'].toString(),
                  name: item['Article'].toString(),
                  price:
                      item['Prix'] != null && item['Prix'].toString().isNotEmpty
                          ? double.parse(item['Prix'].toString())
                          : 0.0,
                  category: item['Categorie_Name'].toString(),
                  categorie_id: item['Categorie_Id'].toString(),
                  quantite: int.parse(item['Quantite'].toString()),
                  isFavorite: item['favorie'] == 'true',
                ))
            .toList();
      });
      } else {
        courseItems = [];
      }
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<void> fetchArticlesFav() async {
    final response =
        await http.get(Uri.parse('http://localhost:8000/courses/favorie/get'));

    if (response.statusCode == 200) {
      if (json.decode(response.body) != null) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          favoriteItems = data
              .map<CourseItem>((item) => CourseItem(
                    id: item['Id'].toString(),
                    name: item['Article'].toString(),
                    price: item['Prix'] != null &&
                            item['Prix'].toString().isNotEmpty
                        ? double.parse(item['Prix'].toString())
                        : 0.0,
                    category: item['Categorie_Name'].toString(),
                    categorie_id: item['Categorie_Id'].toString(),
                    quantite: int.parse(item['Quantite'].toString()),
                    isFavorite: item['favorie'] == 'true',
                  ))
              .toList();
        });
      } else {
        favoriteItems = [];
      }
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<void> SuppItem(String id) async {
    final urlNormal = Uri.parse('http://localhost:8000/courses/delete').replace(
      queryParameters: {
        'id': id,
      },
    );

    final responseNormal = await http.delete(urlNormal);

    if (responseNormal.statusCode == 200) {
      fetchArticles();
    } else {
      throw Exception('Failed to delete item');
    }
  }

  Future<void> addItem(String name, double price, String categoryId,
      int quantity, bool isFavorite) async {
    final url = Uri.parse('http://localhost:8000/courses/create').replace(
      queryParameters: {
        'categorie_id': categoryId,
        'article': name,
        'prix': price.toString(),
        'quantite': quantity.toString(),
        'favorie': isFavorite.toString(),
      },
    );

    final response = await http.post(url);
    if (response.statusCode == 200) {
      fetchArticles();
    } else {
      throw Exception('Failed to add item');
    }
  }

  Future<void> updateFavoriteItem(String id, String name, double price,
      String categoryId, int quantity, bool isFavorite) async {
    final url = Uri.parse('http://localhost:8000/courses/update').replace(
      queryParameters: {
        'id': id,
        'categorie_id': categoryId,
        'article': name,
        'prix': price.toString(),
        'quantite': quantity.toString(),
        'favorie': isFavorite.toString(),
      },
    );

    final response = await http.put(url);
    if (response.statusCode == 200) {
      fetchArticles();
      fetchArticlesFav();
    } else {
      throw Exception('Failed to update favorite item');
    }
  }

  Future<void> removeFavoriteItem(String id, String name, double price,
      String categoryId, int quantity) async {
    final url = Uri.parse('http://localhost:8000/courses/update').replace(
      queryParameters: {
        'id': id,
        'categorie_id': categoryId,
        'article': name,
        'prix': price.toString(),
        'quantite': quantity.toString(),
        'favorie': 'false',
      },
    );
    final response = await http.put(url);

    if (response.statusCode == 200) {
      fetchArticles();
      fetchArticlesFav();
    } else {
      throw Exception('Failed to remove item from favorites');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<CourseItem> filteredItems = selectedCategoryId != null
        ? courseItems
            .where((item) => item.categorie_id == selectedCategoryId)
            .toList()
        : courseItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      value: selectedCategoryId,
                      onChanged: (String? value) {
                        setState(() {
                          selectedCategoryId = value;
                        });
                      },
                      items:
                          categories.map<DropdownMenuItem<String>>((category) {
                        return DropdownMenuItem<String>(
                          value: category['id'],
                          child: Text(
                            category['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.7,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: ListView.builder(
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: UniqueKey(),
                              onDismissed: (direction) {
                                setState(() {
                                  SuppItem(filteredItems[index].id);
                                });
                              },
                              child: ListTile(
                                title: Text(
                                  filteredItems[index].category,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nom: ${filteredItems[index].name}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      'Prix: ${filteredItems[index].price.toString()} €',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      'Quantite: ${filteredItems[index].quantite.toString()}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        setState(() {
                                          SuppItem(filteredItems[index].id);
                                        });
                                      },
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          updateFavoriteItem(
                                              filteredItems[index].id,
                                              filteredItems[index].name,
                                              filteredItems[index].price,
                                              filteredItems[index].categorie_id,
                                              filteredItems[index].quantite,
                                              !filteredItems[index].isFavorite);
                                        });
                                      },
                                      child: Icon(
                                        filteredItems[index].isFavorite
                                            ? Icons.star
                                            : Icons.star_border,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1,
                vertical: MediaQuery.of(context).size.height * 0.1,
              ),
              child: Column(
                children: [
                  Text(
                    'Favoris',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListView.builder(
                        itemCount: favoriteItems.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              favoriteItems[index].category,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nom: ${favoriteItems[index].name}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Prix: ${favoriteItems[index].price.toString()} €',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Quantite: ${favoriteItems[index].quantite}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  removeFavoriteItem(
                                    filteredItems[index].id,
                                    filteredItems[index].name,
                                    filteredItems[index].price,
                                    filteredItems[index].categorie_id,
                                    filteredItems[index].quantite,
                                  );
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String newName = '';
              double newPrice = 0.0;
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: Text('Ajouter un élément à la liste de courses'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton<String>(
                          hint: selectedCategoryIdToAdd == null
                              ? Text('Sélectionner une catégorie')
                              : null,
                          value: selectedCategoryIdToAdd,
                          onChanged: (String? value) {
                            setState(() {
                              selectedCategoryIdToAdd = value;
                            });
                          },
                          items: categories.map<DropdownMenuItem<String>>(
                            (Map<String, dynamic> category) {
                              return DropdownMenuItem<String>(
                                value: category['id'],
                                child: Text(
                                  category['name'],
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Quantité',
                              labelStyle: TextStyle(fontSize: 14)),
                          onChanged: (value) {
                            selectedQuantity = int.tryParse(value);
                          },
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: false),
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Nom de l\'élément',
                              labelStyle: TextStyle(fontSize: 14)),
                          onChanged: (value) {
                            newName = value;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Prix de l\'élément (€)',
                              labelStyle: TextStyle(fontSize: 14)),
                          onChanged: (value) {
                            newPrice = double.tryParse(value) ?? 0.0;
                          },
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (selectedCategoryIdToAdd != null) {
                            if (selectedQuantity != null) {
                              addItem(
                                newName,
                                newPrice,
                                selectedCategoryIdToAdd!,
                                selectedQuantity!,
                                false,
                              );
                              Navigator.pop(context);
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Erreur'),
                                    content:
                                        Text('Veuillez entrer une quantité.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Erreur'),
                                  content: Text(
                                      'Veuillez sélectionner une catégorie.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Text('Ajouter'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
