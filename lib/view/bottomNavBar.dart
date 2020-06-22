import 'package:flutter/material.dart';

  //Importation du controlleur
import 'package:bflop/controller/masterCtrl.dart';

  //Importation du systeme persistent
import 'package:bflop/model/data/dataSave.dart';

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

  //ATTRIBUTES

    //Navigation
  int _selectedIndex = 0;
  AgendaPageMain agendaPage;
  WebetudPageMain webetudPage;
  RoomPageMain roomPage;
  ScorePageMain scorePage;
  AbsencePageMain absencePage;
  List<Widget> pages;
  Widget currentPage;

    //Controller
  MasterCtrl ctrl = new MasterCtrl();

    //Theme
  Brightness theme;
  List<Color> colorsTheme = [Colors.green, Colors.orange, Colors.pink, Colors.blue, Colors.purple];

    //Save page
  //final PageStorageBucket bucket = new PageStorageBucket();


  //METHODS / FUNCTIONS


  //Executed on runtime
  @override
  void initState() {
    this.initPage();
    super.initState();
  }

  //Initialize pages
  void initPage() async {
    var theme = await ctrl.switchTheme(this.theme, true);
    setState(() {
      this.theme = theme;


      DataSave dataSave = new DataSave(this.theme);

      this.agendaPage = new AgendaPageMain(dataSave);
      this.webetudPage = new WebetudPageMain(dataSave);
      this.roomPage = new RoomPageMain(dataSave);
      this.scorePage = new ScorePageMain(dataSave);
      this.absencePage = new AbsencePageMain(dataSave);

      _onItemTapped(0);

      currentPage = this.agendaPage;
      pages = [this.agendaPage, this.webetudPage, this.roomPage, this.scorePage, this.absencePage];
    });
  }

  //Switch between pages
  void _onItemTapped(int index) async {
    var theme = await ctrl.switchTheme(this.theme, true);
    setState(() {
      this.theme = theme;
      if(theme == Brightness.dark) {
        for(int i=0; i<this.colorsTheme.length; i++)
          this.colorsTheme[i] = Colors.black;
      } else {
        this.colorsTheme = [Colors.green, Colors.orange, Colors.pink, Colors.blue, Colors.purple];
      }

      _selectedIndex = index;
      currentPage = pages[index];
    });
  }

  //Update theme of all of pages
  void updateAllThemes(Brightness theme) {
    setState(() {
      this.agendaPage.dataSave.theme = theme;
      this.webetudPage.dataSave.theme = theme;
      this.roomPage.dataSave.theme = theme;
      this.scorePage.dataSave.theme = theme;
      this.absencePage.dataSave.theme = theme;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
        body: PageStorage(
          child: currentPage,
          bucket: this.bucket,
        ),
      */
        body: currentPage,
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              title: Text('Agenda'),
              backgroundColor: this.colorsTheme[0]
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.computer),
              title: Text('Webetud'),
              backgroundColor: this.colorsTheme[1]
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.import_contacts),
              title: Text('Salles libres'),
              backgroundColor: this.colorsTheme[2]
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              title: Text('Notes'),
              backgroundColor: this.colorsTheme[3]
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description),
              title: Text('Absences'),
              backgroundColor: this.colorsTheme[4]
            ),
          ],
          //type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          //selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      );
    
  }
}