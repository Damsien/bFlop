import 'package:bflop/model/data/webetudData.dart';
import 'package:flutter/material.dart';

  //Importation du controlleur
import '../controller/webetudPageCtrl.dart';

  //Importation des données persistents de la page
import 'package:bflop/model/data/dataSave.dart';
import 'package:bflop/model/data/webetudData.dart';
import 'package:bflop/view/bottomNavBar.dart';

class WebetudPageMain extends StatelessWidget {

    //Données générales de la page + accès au reste
  BottomNavBar bottom;
  
    //Theme
  Brightness theme;

  WebetudPageMain(BottomNavBar bot) {
    this.bottom = bot;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Webtud',
      debugShowCheckedModeBanner: false,
      home: new WebetudPage(bottom: bottom),
    );
  }
}


class WebetudPage extends StatefulWidget {
  final BottomNavBar bottom;
  
  WebetudPage({Key key, this.bottom}) : super(key: key);

  @override
  _WebetudPageState createState() => _WebetudPageState();
}

class _WebetudPageState extends State<WebetudPage> {

  //ATTRIBUTES

    //Controller
  WebetudPageCtrl ctrl = new WebetudPageCtrl();

  //Interface


  //METHODS / FUNCTIONS

  //Executed when the app run
  @override
  void initState() {
    super.initState();
    setState(() {
    });
  }

  //Set the state of the new theme
  void updateTheme(bool val) async {
    var theme = await ctrl.switchTheme(widget.bottom.dataPage.theme, val);
    setState(() {
      widget.bottom.dataPage.theme = theme;
    });
      widget.bottom.updateAllThemes(theme, "AbsencePageMain");
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
      title: 'Webetud',
      theme: ThemeData(
        brightness: widget.bottom.dataPage.theme,
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        appBar: AppBar(
          title: new Text('Webetud'),
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