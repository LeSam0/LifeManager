import 'package:flutter/material.dart';

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

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
            // Espace au-dessus des boîtes
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            // Row pour aligner les boîtes côte à côte
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Aligner les boîtes au début
              children: [
                // Boîte sur le côté
                Container(
                  width: MediaQuery.of(context).size.width *
                      0.15, // Ajuster la largeur de la boîte sur le côté
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
                      Text('je sais pas il y a rien sur figma'),
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
                    child: Text('les menus'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
