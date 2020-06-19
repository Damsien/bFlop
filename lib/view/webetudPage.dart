import 'package:flutter/material.dart';

  //Importation du controlleur
import '../controller/webetudPageCtrl.dart';

import '../view/agendaPage.dart';

class WebetudPageMain extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Webtud',
      debugShowCheckedModeBanner: false,
      home: new WebetudPage(title: 'Webtud'),
    );
  }
}


class WebetudPage extends StatefulWidget {
  final String title;
  
  WebetudPage({Key key, this.title}) : super(key: key);

  @override
  _WebetudPageState createState() => _WebetudPageState();
}

class _WebetudPageState extends State<WebetudPage> {
  
    //Controlleur
  WebetudPageCtrl ctrl = new WebetudPageCtrl();


  //INTERFACE

    //Theme
  Brightness theme;

  void test() {

  }

  void switchTheme() {
    setState(() {
      this.theme = ctrl.switchTheme(this.theme, false);
    });
  }

  @override
  Widget build(BuildContext context) {


      //UI

    return MaterialApp(
      title: 'Webetud',
      theme: ThemeData(
        brightness: this.theme,
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