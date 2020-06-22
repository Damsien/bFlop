import 'package:flutter/material.dart';

  //Importation du controlleur
import '../controller/agendaPageCtrl.dart';

import 'package:bflop/model/dataSave.dart';

  //Importation des pages
import 'package:bflop/view/webetudPage.dart';
import 'package:bflop/view/roomPage.dart';
import 'package:bflop/view/scorePage.dart';
import 'package:bflop/view/absencePage.dart';

class AgendaPageMain extends StatelessWidget {

  DataSave dataSave;

  AgendaPageMain(DataSave dataSave) {
    this.dataSave = dataSave;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda',
      debugShowCheckedModeBanner: false,
      home: new AgendaPage(dataSave: dataSave),
    );
  }
}

class AgendaPage extends StatefulWidget {
  final DataSave dataSave;
  
  AgendaPage({Key key, this.dataSave}) : super(key: key);

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


  //METHODS / FUNCTIONS

  //Executed when the app run
  @override
  void initState() {
    super.initState();
    setState(() {
      this.theme = widget.dataSave.theme;
      //this.updateTheme(true);
    });
  }

  //Set the state of the new theme
  void updateTheme(bool val) async {
    var theme = await ctrl.switchTheme(this.theme, val);
    setState(() {
      this.theme = theme;
      widget.dataSave.theme = theme;
    });
  }

  //Switch theme between light and dark
  void switchTheme() {
    this.updateTheme(false);
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
      title: widget.dataSave.title,
      theme: ThemeData(
        brightness: this.theme,
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        appBar: AppBar(
          title: new Text(widget.dataSave.title),
          actions: <Widget>[
              new IconButton(icon: Icon(Icons.refresh), tooltip: 'Rafraichir', onPressed: test),
              new IconButton(icon: Icon(Icons.brightness_4), tooltip: 'Theme', onPressed: switchTheme),
              new IconButton(icon: Icon(Icons.more_vert), tooltip: 'Options', onPressed: test),],
        ),

        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return ExpansionTile(
              title: Text(widget.dataSave.title),
              onExpansionChanged: (b) => setState(() {
                widget.dataSave.listIndex[index] = b;
              }),
              initiallyExpanded: widget.dataSave.listIndex[index],
              children: <Widget>[
                Container(
                  color: index % 2 == 0 ? Colors.green : Colors.blue,
                  height: 100.0,
                )
              ],
            );
          }
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