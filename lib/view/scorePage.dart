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

  ScorePageMain(BottomNavBar bot) {
    this.bottom = bot;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      home: new ScorePage(bottom: bottom),
    );
  }
}

class ScorePage extends StatefulWidget {
  final BottomNavBar bottom;
  
  ScorePage({Key key, this.bottom}) : super(key: key);

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  
  //ATTRIBUTES

    //Controlleurs
  ScorePageCtrl ctrl = new ScorePageCtrl();

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
      title: "Notes",
      theme: ThemeData(
        brightness: this.theme,
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