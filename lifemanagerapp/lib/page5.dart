import 'package:flutter/material.dart';
import 'login_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Page5 extends StatefulWidget {
  const Page5({Key? key}) : super(key: key);

  @override
  _Page5State createState() => _Page5State();
}

class _Page5State extends State<Page5> {
  List<LoginItem> loginItems = [];
  TextEditingController nomappController = TextEditingController();
  TextEditingController identifiantController = TextEditingController();
  TextEditingController motdepasseController = TextEditingController();
  TextEditingController generatedPasswordController =
      TextEditingController(); // Ajout du contrôleur pour le mot de passe généré

  @override
  void initState() {
    super.initState();
    fetchLogins();
    fetchRandomPassword();
  }

  Future<void> addItem(
      String nomapp, String identifiant, String motdepasse) async {
    final url = Uri.parse('http://localhost:8000/login/create').replace(
      queryParameters: {
        'nomapp': nomapp,
        'identifiant': identifiant,
        'motdepasse': motdepasse,
      },
    );

    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        fetchLogins();
      } else {
        throw Exception('Failed to add item: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding item: $error');
      throw Exception('Failed to add item: $error');
    }
  }

  Future<void> fetchLogins() async {
    final response =
        await http.get(Uri.parse('http://localhost:8000/login/get'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        loginItems = data
            .map<LoginItem>((item) => LoginItem(
                  id: item['Id'].toString(),
                  nomapp: item['NomApp'].toString(),
                  identifiant: item['Identifiant'].toString(),
                  motdepasse: item['MotDePasse'].toString(),
                ))
            .toList();
      });
    } else {
      throw Exception('Failed to load logins');
    }
  }

  Future<void> SuppItem(String id) async {
    final url = Uri.parse('http://localhost:8000/login/delete').replace(
      queryParameters: {
        'id': id,
      },
    );

    final response = await http.delete(url);
    if (response.statusCode == 200) {
      fetchLogins();
    } else {
      throw Exception('Failed to delete item');
    }
  }

  Future<String> fetchRandomPassword() async {
    final response =
        await http.get(Uri.parse('http://localhost:8000/login/motdepasse'));

    if (response.statusCode == 200) {
      return response.body;
    } else {

      throw Exception('Failed to load random password');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identifiants et Mots de passe'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nomappController,
                    decoration:
                        InputDecoration(labelText: 'Nom de l\'application'),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: identifiantController,
                    decoration: InputDecoration(labelText: 'Identifiant'),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: motdepasseController,
                    decoration: InputDecoration(labelText: 'Mot de passe'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    final String nomapp = nomappController.text;
                    final String identifiant = identifiantController.text;
                    final String motdepasse = motdepasseController.text;
                    if (nomapp.isNotEmpty &&
                        identifiant.isNotEmpty &&
                        motdepasse.isNotEmpty) {
                      addItem(nomapp, identifiant, motdepasse);
                      nomappController.clear();
                      identifiantController.clear();
                      motdepasseController.clear();
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () async {
                    final String randomPassword = await fetchRandomPassword();
                    setState(() {
                      motdepasseController.text = randomPassword;
                    });
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: loginItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(loginItems[index].nomapp),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Identifiant: ${loginItems[index].identifiant}'),
                      Text('Mot de passe: ${loginItems[index].motdepasse}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        SuppItem(loginItems[index].id);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
