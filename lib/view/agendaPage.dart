import 'package:flutter/material.dart';

class AgendaPage extends StatefulWidget {
  final String title;
  
  AgendaPage({Key key, this.title}) : super(key: key);

  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  
  Brightness darkMode;
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void test() {

  }

  void switchDarkMode() {
    setState(() {
      if(this.darkMode == Brightness.dark) {
        this.darkMode = Brightness.light;
      } else {
        this.darkMode = Brightness.dark;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda',
      theme: ThemeData(
        brightness: this.darkMode,
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: new Text(widget.title),
          leading: new IconButton(icon: Icon(Icons.menu), onPressed: test),
          actions: <Widget>[new IconButton(icon: Icon(Icons.refresh), onPressed: test),
              new IconButton(icon: Icon(Icons.brightness_4), onPressed: switchDarkMode),
              new IconButton(icon: Icon(Icons.more_vert), onPressed: test),],
        ),
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
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
    
  }
}