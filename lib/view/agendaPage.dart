import 'package:flutter/material.dart';

  //Importation du controlleur
import '../controller/agendaPageCtrl.dart';

  //Importation des pages
import 'package:bflop/view/webetudPage.dart';
import 'package:bflop/view/roomPage.dart';
import 'package:bflop/view/scorePage.dart';
import 'package:bflop/view/absencePage.dart';

class AgendaPageMain extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda',
      debugShowCheckedModeBanner: false,
      home: new AgendaPage(title: 'Agenda'),
    );
  }
}

class AgendaPage extends StatefulWidget {
  final String title;
  
  AgendaPage({Key key, this.title}) : super(key: key);

  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  
    //Controlleurs
  AgendaPageCtrl ctrl = new AgendaPageCtrl();


  //INTERFACE

    //Theme
  Brightness theme;

  
  @override
  void initState() {
    super.initState();
    setState(() {
      this.updateTheme(true);
    });
  }

  void updateTheme(bool val) async {
    var theme = await ctrl.switchTheme(this.theme, val);
    setState(() {
      this.theme = theme;
    });
  }
  
  void switchTheme() {
    this.updateTheme(false);
  }


  void test() {
    setState(() {
    });
  }




  @override
  Widget build(BuildContext context) {


      //UI

    return MaterialApp(
      title: widget.title,
      theme: ThemeData(
        brightness: this.theme,
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        appBar: AppBar(
          title: new Text(widget.title),
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