import 'package:flutter/material.dart';

  //Importation du controlleur
import '../controller/agendaPageCtrl.dart';

  //Importation des données persistents de la page
import 'package:bflop/model/data/dataSave.dart';
import 'package:bflop/model/data/agendaData.dart';
import 'package:bflop/view/bottomNavBar.dart';


class AgendaPageMain extends StatelessWidget {

    //Données générales de la page + accès au reste
  BottomNavBar bottom;

  AgendaPageMain(BottomNavBar bot) {
    this.bottom = bot;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda',
      debugShowCheckedModeBanner: false,
      home: new AgendaPage(bottom: bottom),
    );
  }
}

class AgendaPage extends StatefulWidget {
  final BottomNavBar bottom;
  
  AgendaPage({Key key, this.bottom}) : super(key: key);

  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  
  //ATTRIBUTES

    //Controllers
  AgendaPageCtrl ctrl = new AgendaPageCtrl();

  //Interface
    //Theme
  Brightness theme;

  //AgendaData agendaData = new AgendaData(widget.bottom.dataPage.theme);

  //METHODS / FUNCTIONS

  //Executed when page is loading
  @override
  void initState() {
    super.initState();
    setState(() {
      this.theme = widget.bottom.dataPage.theme;
      //this.updateTheme(true);
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

  //Calendar informations
  void updateAgenda() async {
    this.ctrl.fetchTest();
  }

  //Test function
  void test() {
    setState(() {
    });
  }




  @override
  Widget build(BuildContext context) {


      //UI

    return MaterialApp(
      title:"Agenda",
      theme: ThemeData(
        brightness: this.theme,
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        appBar: AppBar(
          title: new Text("Agenda"),
          actions: <Widget>[
              new IconButton(icon: Icon(Icons.refresh), tooltip: 'Rafraichir', onPressed: updateAgenda),
              new IconButton(icon: Icon(Icons.brightness_4), tooltip: 'Theme', onPressed: switchTheme),
              new IconButton(icon: Icon(Icons.more_vert), tooltip: 'Options', onPressed: test),],
        ),


/*
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return ExpansionTile(
              title: Text(widget.dataPage.title),
              onExpansionChanged: (b) => setState(() {
                widget.dataPage.listIndex[index] = b;
              }),
              initiallyExpanded: widget.dataPage.listIndex[index],
              children: <Widget>[
                Container(
                  color: index % 2 == 0 ? Colors.green : Colors.blue,
                  height: 100.0,
                )
              ],
            );
          }
        ),
*/
/*
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                'oui',
                //'$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(
          //onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
*/
      ),
    );
    
  }
}