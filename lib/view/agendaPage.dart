import 'package:flutter/material.dart';

  //Plugins
import 'package:flutter/cupertino.dart';

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

class _AgendaPageState extends State<AgendaPage> with TickerProviderStateMixin {
  
  //ATTRIBUTES

    //Controllers
  AgendaPageCtrl ctrl = new AgendaPageCtrl();

  //Interface
    //Theme
  Brightness theme;

    //Progress Bar
  var progressBarVisible = false;
  
    //TabBar1
  List<Tab> semTabs = <Tab>[
    Tab(text: '1'),
    Tab(text: '2'),
    Tab(text: '3'),
    Tab(text: '4')
  ];
  TabController semTabController;
  int moreDays = 0;
  var semTabView = <Widget>[
    Text("1"),
    Text("2"),
    Text("3"),
    Text("4")
  ];

    //TabBar2
  List<Tab> dayTabs = <Tab>[
    Tab(text: 'Lundi'),
    Tab(text: 'Mardi'),
    Tab(text: 'Mercredi'),
    Tab(text: 'Jeudi'),
    Tab(text: 'Vendredi')
  ];
  TabController dayTabController;
  Color tabLabelColor = Colors.black;

  //Data
    //Agenda
  List<List<List<String>>> agenda = new List<List<List<String>>>();
    //Teachers or groups
  List<String> teachersGroups = ['INFO1-1A'];
    //Teachers
  var teachers;
    //Groups
  var groups;
    //Promos
  List<String> promos = ["Info", "RT", "GIM", "CS"];
  List<String> teachOrGroup = ["Elève", "Prof"];
    //Dates
  List<String> days = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi"];
  List<String> months = ["Janvier", "Fevrier", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"];
  var lun = DateTime.now();
  var mar = DateTime.now();
  var mer = DateTime.now();
  var jeu = DateTime.now();
  var ven = DateTime.now();
  List<DateTime> daysDate = new List<DateTime>(5);


  //Items selections
    //PopMenu
  var popMenuSelection;
    //Tabs
  var daysSelection = DateTime.now().weekday-1;
  var semSelection = 0;
    //Pickers
  String pickPromo = "Info";
  String pickTeachStudent = "Elève";
  String pickTeachGroup = "INFO1-1A";

  //METHODS / FUNCTIONS

  //Executed when page is loading
  @override
  void initState() {
    super.initState();
     
    //Init current day
    this.daysSelection = this.ctrl.initDay(DateTime.now()).weekday-1;

    //Dates
    this.lun = this.ctrl.getMonday(DateTime.now());
    this.mar = this.ctrl.getNextDay(this.lun);
    this.mer = this.ctrl.getNextDay(this.mar);
    this.jeu = this.ctrl.getNextDay(this.mer);
    this.ven = this.ctrl.getNextDay(this.jeu);
    this.daysDate = [this.lun, this.mar, this.mer, this.jeu, this.ven];

    //Tabs
    var fisrtWeek = this.ctrl.getFirstWeek(DateTime.now());
    this.semTabs = <Tab>[
      Tab(text: fisrtWeek.toString()),
      Tab(text: (fisrtWeek+1).toString()),
      Tab(text: (fisrtWeek+2).toString()),
      Tab(text: (fisrtWeek+3).toString()),
    ];
    this.semTabController = TabController(initialIndex: 0, vsync: this, length: this.semTabs.length);
    this.semTabView = <Widget>[
        Center(child: Text("Semaine " + this.ctrl.getFirstWeek(this.ctrl.getMonday(DateTime.now())).toString(),
         style: TextStyle(fontSize: 20))),
        Center(child: Text("Semaine " + (this.ctrl.getFirstWeek(this.ctrl.getMonday(DateTime.now()))+1).toString(),
         style: TextStyle(fontSize: 20))),
        Center(child: Text("Semaine " + (this.ctrl.getFirstWeek(this.ctrl.getMonday(DateTime.now()))+2).toString(),
         style: TextStyle(fontSize: 20))),
        Center(child: Text("Semaine " + (this.ctrl.getFirstWeek(this.ctrl.getMonday(DateTime.now()))+3).toString(),
         style: TextStyle(fontSize: 20)))
      ];
    semSelectionFunc() {
      setState(() {
        this.semSelection = this.semTabController.index;
        this.moreDays = 7*this.semTabController.index;
        this.dayTabs = <Tab>[
          Tab(text: this.ctrl.getSomeDays(this.lun,this.moreDays).day.toString() + "/" + this.ctrl.getSomeDays(this.lun,this.moreDays).month.toString()),
          Tab(text: this.ctrl.getSomeDays(this.mar,this.moreDays).day.toString() + "/" + this.ctrl.getSomeDays(this.mar,this.moreDays).month.toString()),
          Tab(text: this.ctrl.getSomeDays(this.mer,this.moreDays).day.toString() + "/" + this.ctrl.getSomeDays(this.mer,this.moreDays).month.toString()),
          Tab(text: this.ctrl.getSomeDays(this.jeu,this.moreDays).day.toString() + "/" + this.ctrl.getSomeDays(this.jeu,this.moreDays).month.toString()),
          Tab(text: this.ctrl.getSomeDays(this.ven,this.moreDays).day.toString() + "/" + this.ctrl.getSomeDays(this.ven,this.moreDays).month.toString())
        ];
      });
    }
    this.semTabController.addListener(semSelectionFunc);
    
    this.dayTabs = <Tab>[
      Tab(text: this.lun.day.toString() + "/" + this.lun.month.toString()),
      Tab(text: this.mar.day.toString() + "/" + this.mar.month.toString()),
      Tab(text: this.mer.day.toString() + "/" + this.mer.month.toString()),
      Tab(text: this.jeu.day.toString() + "/" + this.jeu.month.toString()),
      Tab(text: this.ven.day.toString() + "/" + this.ven.month.toString())
    ];
    this.dayTabController = TabController(initialIndex:this.ctrl.initDay(DateTime.now()).weekday-1, vsync: this, length: this.dayTabs.length);
    daysSelectionFunc() {
      setState(() {
        this.daysSelection = this.dayTabController.index;
      });
    }
    this.dayTabController.addListener(daysSelectionFunc);

    setState(() {
      this.theme = widget.bottom.dataPage.theme;
      if(this.theme == Brightness.dark) this.tabLabelColor = Colors.white;
      else this.tabLabelColor = Colors.black;
    });
    
    updateAllDatas(true);
  }

  //Set the state of the new theme
  void updateTheme(bool val) async {
    var theme = await ctrl.switchTheme(this.theme, val);
    setState(() {
      this.theme = theme;
      if(this.theme == Brightness.dark) this.tabLabelColor = Colors.white;
      else this.tabLabelColor = Colors.black;
    });
      widget.bottom.updateAllThemes(theme);
  }

  //Switch theme between light and dark
  void switchTheme() {
    this.updateTheme(false);
  }


  //Calendar, student and teacher informations
  void updateAllDatas(bool isRuntime) async {
    setState(() {
      this.progressBarVisible = true;
    });
    var all = await this.ctrl.getAll(isRuntime);
    if(all != null) {
      setState(() {
        this.agenda = this.ctrl.dynamicToAgenda(all[0]);
        //this.teachersGroups = all[1];
        //this.groups = all[2];
        this.teachersGroups = all[1];

        this.pickPromo = all[2][0];
        this.pickTeachStudent = all[2][1];
        this.pickTeachGroup = all[2][2];
        //this.teachers = this.ctrl.dynamicToTeachers(all[2], 0);
        //print(this.teachers);
        //print(all[2]);
        //this.teachersGroups = this.teachers;
        this.progressBarVisible = false;
      });
    }
  }
  

  void swipeSlide(DragDownDetails e) {
    if(this.daysSelection == 4) {
      if(e.localPosition.dx > 240) {
        switch (this.semTabController.index) {
          case 0:
            this.semTabController.animateTo(1);
            this.dayTabController.animateTo(0);
            break;
          case 1:
            this.semTabController.animateTo(2);
            this.dayTabController.animateTo(0);
            break;
          case 2:
            this.semTabController.animateTo(3);
            this.dayTabController.animateTo(0);
            break;    
        }
      }
    }
    if(this.daysSelection == 0) {
      if(e.localPosition.dx < 240) {
        switch (this.semTabController.index) {
        case 1:
          this.semTabController.animateTo(0);
          this.dayTabController.animateTo(4);
          break;
        case 2:
          this.semTabController.animateTo(1);
          this.dayTabController.animateTo(4);
          break;
        case 3:
          this.semTabController.animateTo(2);
          this.dayTabController.animateTo(4);
          break;    
        }
      }
    }
    updatePickers();
  }

  void updatePickers() async {
    await new Future.delayed(const Duration(seconds: 1));
    var pickersSelect = await this.ctrl.getPickersSelect();
    print(pickersSelect);
    if(pickersSelect != null) {
    setState(() {
      this.pickPromo = pickersSelect[0];
      this.pickTeachStudent = pickersSelect[1];
      this.pickTeachGroup = pickersSelect[2];
    });
    }
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
              new IconButton(icon: Icon(Icons.refresh), tooltip: 'Rafraichir', onPressed: () {updateAllDatas(false);}),
              new IconButton(icon: Icon(Icons.brightness_4), tooltip: 'Theme', onPressed: switchTheme),
              PopupMenuButton(
                onSelected: (result) { setState(() { popMenuSelection = result; }); },
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem(
                    value: 0,
                    child: Text('Paramètres'),
                  ),
                ],
                tooltip: "Options",
              )
              ]
        ),
        
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Visibility(
                visible: this.progressBarVisible,
                child: LinearProgressIndicator(),
              ),
              Container(
                alignment: Alignment.center,
                height: 50,
                child: TabBarView(
                  controller: this.semTabController,
                  children: this.semTabView
                )
              ),
              LinearProgressIndicator(
                value: this.semSelection.toDouble()/3,
              ),
              Container(
                height: 50,
                child: TabBar(
                  onTap: (index) {setState(() {
                    this.daysSelection = index;
                  }); updatePickers();},
                  controller: this.dayTabController,
                  tabs: this.dayTabs,
                  labelColor: this.tabLabelColor,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onHorizontalDragDown: (e) {swipeSlide(e);},
                  child: TabBarView(
                      //physics: NeverScrollableScrollPhysics(),
                      controller: this.dayTabController,
                      children: this.dayTabs.map((Tab tab) {
                        final String label = tab.text;
                        var day = this.dayTabs.indexOf(tab);
                        return Center(
                          child: ListView(
                            children: <Widget>[
                              Card(
                                child: ListTile(title: Text(this.ctrl.listToString(this.agenda, 0, 0, day) + day.toString()))
                                
                              ),
                              Card(
                                child: ListTile(
                                  leading: FlutterLogo(),
                                  title: Text('One-line with leading widget'),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  title: Text('One-line with trailing widget'),
                                  trailing: Icon(Icons.more_vert),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  leading: FlutterLogo(),
                                  title: Text('One-line with both widgets'),
                                  trailing: Icon(Icons.more_vert),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  title: Text('One-line dense ListTile'),
                                  dense: true,
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  leading: FlutterLogo(size: 56.0),
                                  title: Text('Two-line ListTile'),
                                  subtitle: Text('Here is a second line'),
                                  trailing: Icon(Icons.more_vert),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  leading: FlutterLogo(size: 72.0),
                                  title: Text('Three-line ListTile'),
                                  subtitle: Text(
                                    'A sufficiently long subtitle warrants three lines.'
                                  ),
                                  trailing: Icon(Icons.more_vert),
                                  isThreeLine: true,
                                ),
                              ),
                            ],
                          )
                          /*child: Text(
                            'This is the $label tab' + day.toString() + this.semSelection.toString(),
                            style: const TextStyle(fontSize: 36),
                          ),*/
                        );
                      }).toList(),
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(children: [
                    Icon(Icons.group),
                    IgnorePointer(
                      ignoring: this.progressBarVisible,
                      child: DropdownButton<String>(
                        value: this.pickPromo,
                        onChanged: (String newValue) async {
                          this.ctrl.savePickers(newValue, null, null);
                          this.teachersGroups = await this.ctrl.switchChanged();
                          this.pickTeachGroup = this.teachersGroups[0];
                          var pickersSelect = await this.ctrl.getPickersSelect();
                          setState(() {
                            this.pickPromo = newValue;
                            this.pickTeachStudent = pickersSelect[1];
                            //print(pickersSelect[2]);
                          });
                        },
                        items: this.promos
                            .map<DropdownMenuItem<String>>((String value) {
                          this.pickPromo = value;
                          return DropdownMenuItem<String>(
                            value: this.pickPromo,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    )
                    ],
                  ),
                  Row(children: [
                    Icon(Icons.mood),
                    IgnorePointer(
                      ignoring: this.progressBarVisible,
                      child : DropdownButton<String>(
                        value: this.pickTeachStudent,
                        onChanged: (String newValue) async {
                          this.ctrl.savePickers(null, newValue, null);
                          this.teachersGroups = await this.ctrl.switchChanged();
                          this.pickTeachGroup = this.teachersGroups[0];
                          var pickersSelect = await this.ctrl.getPickersSelect();
                          setState(() {
                            this.pickPromo = pickersSelect[0];
                            this.pickTeachStudent = newValue;
                            //this.pickTeachGroup = pickersSelect[2];
                          });
                        },
                        items: this.teachOrGroup
                            .map<DropdownMenuItem<String>>((String value) {
                          this.pickTeachStudent = value;
                          return DropdownMenuItem<String>(
                            value: this.pickTeachStudent,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    )
                    ],
                  ),
                  Row(children: [
                    Icon(Icons.assignment),
                    IgnorePointer(
                      ignoring: this.progressBarVisible,
                      child: DropdownButton<String>(
                        value: this.pickTeachGroup,
                        onChanged: (String newValue) async {
                          this.ctrl.savePickers(null, null, newValue);
                          this.ctrl.getAll(false);
                          var pickersSelect = await this.ctrl.getPickersSelect();
                          setState(() {
                            this.progressBarVisible = true;
                          });
                          await new Future.delayed(const Duration(seconds : 15));
                          setState(() {
                            this.progressBarVisible = false;
                            this.pickPromo = pickersSelect[0];
                            this.pickTeachStudent = pickersSelect[1];
                            this.pickTeachGroup = newValue;
                          });
                        },
                        items: this.teachersGroups
                            .map<DropdownMenuItem<String>>((String value) {
                          this.pickTeachGroup = value;
                          return DropdownMenuItem<String>(
                            value: this.pickTeachGroup,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    )
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: new EdgeInsets.symmetric(horizontal: 20.0),
                    height: 75,
                    child: Text(
                      this.days[this.daysSelection] + " " 
                      + this.ctrl.getSomeDays(this.daysDate[this.daysSelection],this.moreDays).day.toString() + " "
                      + this.months[this.ctrl.getSomeDays(this.daysDate[this.daysSelection],this.moreDays).month-1].toString() + " "
                      + this.ctrl.getSomeDays(this.daysDate[this.daysSelection],this.moreDays).year.toString(),
                      style: TextStyle(fontSize: 20)
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: new EdgeInsets.symmetric(horizontal: 20.0),
                    height: 75,
                    child: Text(
                      this.ctrl.getSomeDays(this.daysDate[this.daysSelection],this.moreDays).day.toString() + "/"
                      + this.ctrl.getSomeDays(this.daysDate[this.daysSelection],this.moreDays).month.toString(),
                      style: TextStyle(fontSize: 20)
                    ),
                  )
                ],
              )
            ]
          ),
        )

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