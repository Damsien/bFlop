import 'package:flutter/material.dart';

  //Importation du controlleur
import '../controller/absencePageCtrl.dart';

  //Importation des données persistents de la page
import 'package:bflop/model/data/dataSave.dart';
import 'package:bflop/model/data/absenceData.dart';
import 'package:bflop/view/bottomNavBar.dart';

class AbsencePageMain extends StatelessWidget {

    //Données générales de la page + accès au reste
  BottomNavBar bottom;

  AbsencePageMain(BottomNavBar bot) {
    this.bottom = bot;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absences',
      debugShowCheckedModeBanner: false,
      home: new AbsencePage(bottom: bottom),
    );
  }
}

class AbsencePage extends StatefulWidget {
  final BottomNavBar bottom;
  
  AbsencePage({Key key, this.bottom}) : super(key: key);

  @override
  _AbsencePageState createState() => _AbsencePageState();
}

class _AbsencePageState extends State<AbsencePage> {
  
  //ATTRIBUTES

    //Controlleurs
  AbsencePageCtrl ctrl = new AbsencePageCtrl();

  //Interface
    //Theme
  Brightness theme;


  //METHODS / FUNCTIONS

  //Executed when the app run
  @override
  void initState() {
    super.initState();
    setState(() {
      this.theme = widget.bottom.dataPage.theme;
    });
  }

  //Set the state of the new theme
  void updateTheme(bool val) async {
    var theme = await ctrl.switchTheme(this.theme, val);
    setState(() {
      this.theme = theme;
    });
      widget.bottom.updateAllThemes(theme);
  }

  //Switch theme between light and dark
  void switchTheme() {
    this.updateTheme(false);
  }

  //Test function
  void test() {
  }


  @override
  Widget build(BuildContext context) {


      //UI

    return MaterialApp(
      title: "Absences",
      theme: ThemeData(
        brightness: this.theme,
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        appBar: AppBar(
          title: new Text("Absences"),
          //leading: new IconButton(icon: Icon(Icons.menu), onPressed: test),
          actions: <Widget>[
              new IconButton(icon: Icon(Icons.refresh), tooltip: 'Rafraichir', onPressed: test),
              new IconButton(icon: Icon(Icons.brightness_4), tooltip: 'Theme', onPressed: switchTheme),
              new IconButton(icon: Icon(Icons.more_vert), tooltip: 'Options', onPressed: test),],
        ),
/*
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
*/
      ),
    );
    
  }
}