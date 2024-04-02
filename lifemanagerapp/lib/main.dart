import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const LifeManager());
}

class LifeManager extends StatelessWidget {
  const LifeManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/page1': (context) => const Page1(),
        '/page2': (context) => const Page2(),
        '/page3': (context) => const Page3(),
        '/page4': (context) => const Page4(),
        '/page5': (context) => const Page5(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LifeManager'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/page1');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text('Calendrier'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/page2');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text('Dépenses'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/page3');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text('Courses'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/page4');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text('Menu'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/page5');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text('Coffre fort'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendrier'),
      ),
      body: Center(
        child: const Text('This is Page 1'),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dépenses'),
      ),
      body: Center(
        child: const Text('This is Page 2'),
      ),
    );
  }
}

class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  List<CourseItem> courseItems = [];
  List<Map<String, dynamic>> categories =
      []; // Liste pour stocker les catégories (avec ID et nom)
  String?
      selectedCategoryId; // Utilisé pour stocker l'ID de la catégorie sélectionnée

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Appel de la fonction pour récupérer les catégories
  }

  Future<void> addItem(String name, double price, String categoryId) async {
     // URL de l'API pour ajouter un élément
      final url = Uri.parse('http://localhost:8000/courses/create').replace(
      queryParameters: {
        'categorie_id': categoryId,
        'article': name,
        'prix': price.toString(),
        'quantite': '10', // Notez que j'ai mis '10' entre guillemets pour le garder comme une chaîne
      },
    );

final response = await http.post(url);
    if (response.statusCode == 200) {
      // Si la requête réussit
      // Vous pouvez ajouter une logique supplémentaire ici si nécessaire
    } else {
      // Si la requête échoue
      throw Exception('Failed to add item');
    }
  }

  // Fonction pour récupérer les catégories depuis l'API
  Future<void> fetchCategories() async {
    final response =
        await http.get(Uri.parse('http://localhost:8000/courses/categorie'));

    if (response.statusCode == 200) {
      // Si la requête réussit
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        categories = data
            .map<Map<String, dynamic>>((category) => {
                  'id': category['Id']
                      .toString(), // Convertit l'ID en chaîne de caractères
                  'name': category['Categorie_Name']
                      .toString(), // Convertit le nom en chaîne de caractères
                })
            .toList();
      });
    } else {
      // Si la requête échoue
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
              itemCount: courseItems.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    setState(() {
                      courseItems.removeAt(index);
                    });
                  },
                  child: ListTile(
                    title: Text(courseItems[index].name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${courseItems[index].price.toString()} €'),
                        Text('Catégorie: ${courseItems[index].category}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          courseItems.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
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
                          hint: selectedCategoryId == null
                              ? Text('Sélectionner une catégorie')
                              : null,
                          value: selectedCategoryId,
                          onChanged: (String? value) {
                            setState(() {
                              selectedCategoryId = value;
                            });
                          },
                          items: categories.map<DropdownMenuItem<String>>(
                            (Map<String, dynamic> category) {
                              return DropdownMenuItem<String>(
                                value: category['id']
                                    .toString(), // Utilise l'ID comme valeur
                                child: Text(category['name']
                                    .toString()), // Affiche le nom
                              );
                            },
                          ).toList(),
                        ),
                        TextField(
                          decoration:
                              InputDecoration(labelText: 'Nom de l\'élément'),
                          onChanged: (value) {
                            newName = value;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Prix de l\'élément (€)'),
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
                          if (selectedCategoryId != null) {
                            addItem(newName, newPrice, selectedCategoryId!);
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

class CourseItem {
  final String name;
  final double price;
  final String category;

  CourseItem({required this.name, required this.price, required this.category});
}

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: Center(
        child: const Text('This is Page 4'),
      ),
    );
  }
}

class Page5 extends StatelessWidget {
  const Page5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffre fort'),
      ),
      body: Center(
        child: const Text('This is Page 5'),
      ),
    );
  }
}
