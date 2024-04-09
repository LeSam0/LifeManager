import 'package:flutter/material.dart';
import 'depense_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  List<DepenseItem> depensesItems = [];
  List<Map<String, dynamic>> depensesCategories = [];
  List<Map<String, dynamic>> sousDepensesCategories = [];
  String? selectedCategoryId;
  String? selectedCategoryIdToAdd;
  int? selectedQuantity;

  @override
  void initState() {
    super.initState();
    fetchDepensesCategories();
  }

  Future<void> fetchDepensesCategories() async {
    final response =
        await http.get(Uri.parse('http://localhost:8000/depense/categorie'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print(data);
      setState(() {
        depensesCategories = data
            .map<Map<String, dynamic>>((item) => {
                  'id': item['Id'].toString(),
                  'type': item['Categorie_Name'],
                })
            .toList();
        print(depensesCategories);
      });
    } else {
      throw Exception('Failed to load articles');
    }
  }

  // Future<void> fetchDepensesItems() async {
  //   final response =
  //       await http.get(Uri.parse('http://localhost:8000/depense/get/all'));
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     setState(() {
  //       depensesItems = data
  //           .map<DepenseItem>((item) => DepenseItem(
  //                 name: item['name'].toString(),
  //                 montant: item['montant'].toString(),
  //                 date: item['date'].toString(),
  //                 description: item['description'].toString(),
  //                 sousCategorieId: item['sousCategorieId'].toString(),
  //               ))
  //           .toList();
  //     });
  //     print(depensesItems);
  //   } else {
  //     throw Exception('Failed to load articles');
  //   }
  // }

  // Future<void> addDepenseItem(String name, String montant, String date,
  //     String description, String sousCategorieId) async {
  //   final response = await http.post(
  //     Uri.parse('http://localhost:8000/depense/create'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'name': name,
  //       'montant': montant,
  //       'date': date,
  //       'description': description,
  //       'sousCategorieId': sousCategorieId,
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     fetchDepensesItems();
  //   } else {
  //     throw Exception('Failed to add article');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dépenses'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.height * 0.5,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Contenu de la boîte sur le côté
                      Text('Goals'),
                    ],
                  ),
                ),
                SizedBox(width: 90), // Espace entre les boîtes
                // Boîte au milieu
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text('les dépenses'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Ajouter un élément à mes dépenses'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton<String>(
                        hint: Text('Sélectionner une catégorie'),
                        value: selectedCategoryIdToAdd,
                        onChanged: (String? value) {
                          setState(() {
                            selectedCategoryIdToAdd = value;
                          });
                        },
                        items: depensesCategories.map<DropdownMenuItem<String>>(
                          (Map<String, dynamic> category) {
                            return DropdownMenuItem<String>(
                              value: category['id'],
                              child: Text(category[
                                  'type']), // Utiliser 'type' au lieu de 'name'
                            );
                          },
                        ).toList(),
                      ),
                      TextField(
                          decoration: InputDecoration(
                              labelText: 'Quantité'),
                          onChanged: (value) {
                            selectedQuantity = int.tryParse(value);
                          },
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: false),
                        ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
