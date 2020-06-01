import 'package:flutter/material.dart';

  //Importation des pages
import 'view/agendaPage.dart';

void main() {
  runApp(new BFlop());
}

class BFlop extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda',
      debugShowCheckedModeBanner: false,
      home: new AgendaPage(title: 'Agenda'),  //Ouverture de la page agenda lors de l'ouverture de l'app
    );
  }
}