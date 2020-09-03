import 'package:flutter/material.dart';

  //Importation du controlleur
import '../controller/paramPageCtrl.dart';

  //Importation des données persistents de la page
import 'package:bflop/model/data/dataSave.dart';
import 'package:bflop/model/data/paramData.dart';
import 'package:bflop/view/bottomNavBar.dart';

class ParamPageMain extends StatelessWidget {

    //Données générales de la page + accès au reste
  BottomNavBar bottom;
  
    //Theme
  Brightness theme;

  ParamPageMain(BottomNavBar bot) {
    this.bottom = bot;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paramètres',
      debugShowCheckedModeBanner: false,
      home: new ParamPage(bottom: bottom),
    );
  }
}

class ParamPage extends StatefulWidget {
  final BottomNavBar bottom;
  
  ParamPage({Key key, this.bottom}) : super(key: key);

  @override
  _ParamPageState createState() => _ParamPageState();
}

class _ParamPageState extends State<ParamPage> {
  
  //ATTRIBUTES

    //Controlleurs
  ParamPageCtrl ctrl = new ParamPageCtrl();

  //Interface

    //TextField
  TextEditingController textFieldCtrlLog;
  TextEditingController textFieldCtrlMdp;

  //METHODS / FUNCTIONS

  //Executed when the app run
  @override
  void initState() {
    super.initState();
    setState(() {
    });
    this.textFieldCtrlLog = TextEditingController();
    this.textFieldCtrlMdp = TextEditingController();
  }

  //Test function
  void test() {
  }


  @override
  Widget build(BuildContext context) {


      //UI

    return MaterialApp(
      title: "Paramètres",
      theme: ThemeData(
        brightness: widget.bottom.dataPage.theme,
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        appBar: AppBar(
          leading: new IconButton(icon: Icon(Icons.arrow_back), tooltip: 'Retour', onPressed: () {widget.bottom.switchBack(widget.bottom.currentParamPage.toString());}),
          title: new Text("Paramètres"),
        ),
        body: Container(
          height: (this.ctrl.paData.isConnected ? 80 : 170),
          alignment: Alignment.topCenter,
          child: Column(
            children: [
            Text('Connexion au réseau IUT', style: TextStyle(fontSize: 20)),
            
            Container(
            margin:  new EdgeInsets.only(bottom: 10, top: 10),
            child: (this.ctrl.paData.isConnected ?
              Text("Bonjour Logged", style: TextStyle(fontSize: 17))
              :
              TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Identifiant',
              ),
              controller: this.textFieldCtrlLog,
              )
              )
            ),
            Visibility(
              visible: (this.ctrl.paData.isConnected ? false: true),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mot de passe',
                ),
                controller: this.textFieldCtrlMdp,
                )
              ),
          ])
        )
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