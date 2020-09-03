import 'package:flutter/material.dart';

  //Importation du controlleur
import '../controller/scorePageCtrl.dart';

  //Importation des données persistents de la page
import 'package:bflop/model/data/dataSave.dart';
import 'package:bflop/model/data/scoreData.dart';
import 'package:bflop/view/bottomNavBar.dart';

class ScorePageMain extends StatelessWidget {

    //Données générales de la page + accès au reste
  BottomNavBar bottom;

    //StatefulWidget
  ScorePage scorePage;
  
    //Theme
  Brightness theme;

  ScorePageMain(BottomNavBar bot) {
    
    
    /*print("build de la page theme : " + bot.dataPage.theme.toString());
    this.bottom = bot;
    this.theme = bot.dataPage.theme;
    print("build de la page them : " + this.theme.toString());

    this.scorePage = new ScorePage(bottom: bottom);
    this.scorePage.initTheme(this.theme);
    */

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      home: this.scorePage,
    );
  }
}

class ScorePage extends StatefulWidget {
  final BottomNavBar bottom;
  Brightness theme;
  
  ScorePage({Key key, this.bottom}) : super(key: key);

  void initTheme(Brightness theme) {
    this.theme = theme;
    createState();
    print("le theme : " + theme.toString());
  }

  @override
  _ScorePageState createState() => _ScorePageState();

  /*
  @override
  _ScorePageState createState() {
    print("createState");
    _ScorePageState state = new _ScorePageState();
    state.initTheme(theme);
    return state;
  }*/
}

class _ScorePageState extends State<ScorePage> {
  
  //ATTRIBUTES

    //Controlleurs
  ScorePageCtrl ctrl = new ScorePageCtrl();

  //Interface
  Brightness theme;

  //METHODS / FUNCTIONS

  //Executed when the app run
  @override
  void initState() {
    super.initState();
    setState(() {
      //this.theme = widget.theme;
    });
  }

  void initTheme(Brightness theme) {
    this.theme = theme;
      print(widget.theme);
      print(this.theme);
    print( "theme " + this.theme.toString() + " theme : " + theme.toString());
  }

  //Set the state of the new theme
  void updateTheme(bool val) async {
    var theme = await ctrl.switchTheme(widget.bottom.dataPage.theme, val);
    setState(() {
      widget.bottom.dataPage.theme = theme;
    });
      widget.bottom.updateAllThemes(theme, "ScorePageMain");
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
      title: "Notes",
      theme: ThemeData(
        brightness: widget.bottom.dataPage.theme,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        appBar: AppBar(
          title: new Text("Notes"),
          //leading: new IconButton(icon: Icon(Icons.menu), onPressed: test),
          actions: <Widget>[
              new IconButton(icon: Icon(Icons.refresh), tooltip: 'Rafraichir', onPressed: test),
              new IconButton(icon: Icon(Icons.brightness_4), tooltip: 'Theme', onPressed: switchTheme),
              PopupMenuButton(
              onSelected: (result) { setState(() { var popMenuSelection = result; widget.bottom.switchParam();}); },
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  value: 0,
                  child: Text('Paramètres'),
                ),
              ],
                tooltip: "Options",
              )
              ],
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