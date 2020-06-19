import 'package:flutter/material.dart';

  //Importation du controlleur
import '../controller/agendaPageCtrl.dart';

  //Importation des pages
import './agendaPage.dart';
import './webetudPage.dart';
import './roomPage.dart';
import './scorePage.dart';
import './absencePage.dart';

class BottomNavBarMain extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda',
      debugShowCheckedModeBanner: false,
      home: new BottomNavBar(title: 'Agenda'),  //Ouverture de la page agenda lors de l'ouverture de l'app
    );
  }
}

class BottomNavBar extends StatefulWidget {

  final String title;
  
  BottomNavBar({Key key, this.title}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

    //Navigation
  int _selectedIndex = 0;
  AgendaPageMain agendaPage;
  WebetudPageMain webetudPage;
  RoomPageMain roomPage;
  ScorePageMain scorePage;
  AbsencePageMain absencePage;
  List<Widget> pages;
  Widget currentPage;
  final PageStorageBucket _bucket = new PageStorageBucket();


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      currentPage = pages[index];
    });
  }


  @override
  void initState() {
    this.agendaPage = new AgendaPageMain();
    this.webetudPage = new WebetudPageMain();
    this.roomPage = new RoomPageMain();
    this.scorePage = new ScorePageMain();
    this.absencePage = new AbsencePageMain();

    currentPage = this.agendaPage;
    pages = [this.agendaPage, this.webetudPage, this.roomPage, this.scorePage, this.absencePage];
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: currentPage,
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              title: Text('Agenda'),
              backgroundColor: Colors.green
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.computer),
              title: Text('Webetud'),
              backgroundColor: Colors.orange
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.import_contacts),
              title: Text('Salles libres'),
              backgroundColor: Colors.pink
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              title: Text('Notes'),
              backgroundColor: Colors.blue
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description),
              title: Text('Absences'),
              backgroundColor: Colors.purple
            ),
          ],
          //type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          //selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
    
  }
}