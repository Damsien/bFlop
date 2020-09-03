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

    //Progress Bar
  var progressBarVisible = false;
  bool loadFinish = false;
  
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

    //TextField
  TextEditingController textFieldCtrl;

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
      if(widget.bottom.dataPage.theme == Brightness.dark) this.tabLabelColor = Colors.white;
      else this.tabLabelColor = Colors.black;
    });
    this.textFieldCtrl = TextEditingController();

    updateAllDatas(true);
  }

  //Set the state of the new theme
  void updateTheme(bool val) async {
    var theme = await ctrl.switchTheme(widget.bottom.dataPage.theme, val);
    widget.bottom.dataPage.theme = theme;
    setState(() {
      if(widget.bottom.dataPage.theme == Brightness.dark) this.tabLabelColor = Colors.white;
      else this.tabLabelColor = Colors.black;
    });
      widget.bottom.updateAllThemes(theme, "AgendaPageMain");
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
        //print(all[1]);

        this.pickPromo = all[2][0];
        this.pickTeachStudent = all[2][1];
        this.pickTeachGroup = all[2][2];
        //this.teachers = this.ctrl.dynamicToTeachers(all[2], 0);
        //print(this.teachers);
        //print(all[2]);
        //this.teachersGroups = this.teachers;
        this.progressBarVisible = false;
        this.loadFinish = true;
      });
    }
  }
  

  void swipeSlide(DragDownDetails e) {
    if(this.daysSelection == 4) {
      if(e.localPosition.dx > 320) {
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
      if(e.localPosition.dx < 320) {
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
    //updatePickers();
  }

  void updatePickers(bool isLoadFinish) async {
    //print(this.ctrl.agData.pickTeachStudent);
    //print(this.ctrl.agData.pickGroup);
    //print(this.ctrl.agData.pickPromo);
    if(isLoadFinish) {
      await new Future.delayed(const Duration(milliseconds: 10));
      /*var pickersSelect = await this.ctrl.getPickersSelect();
      print(pickersSelect);*/
      if(this.ctrl.agData.pickGroup != null) {
        setState(() {
          this.pickPromo = this.ctrl.agData.pickPromo;
          this.pickTeachStudent = this.ctrl.agData.pickTeachStudent;
          this.pickTeachGroup = this.ctrl.agData.pickGroup;
        });
      }
    }
  }


  getDaysNCourses(int sem) {
    List<int> days = [0,1,2,3,4];
    List<int> courses = [0,1,2,3,4,5];
    List<Container> cont = new List<Container>();
    for(int course in courses) {
      for(int day in days) {
        cont.add(new Container(
          alignment: Alignment.center,
          margin: new EdgeInsets.all(0),
          child: Card(
            color: (this.ctrl.listToString(this.agenda, this.semSelection, day, course).length == 0 ? (widget.bottom.dataPage.theme == Brightness.dark ? Colors.grey[800] : Colors.white) :
            HexColor.fromHex(this.ctrl.listToString(this.agenda, this.semSelection, day, course).split("\\n")[4].split(" ")[1].split("#")[1])),
            child: ListTile(
              title: Center(child: Text(
                (this.ctrl.listToString(this.agenda, this.semSelection, day, course).length == 0 ? "" :
                this.ctrl.listToString(this.agenda, this.semSelection, day, course).split("\\n")[0].split(" ")[2])
                + "  " +
                (this.ctrl.listToString(this.agenda, this.semSelection, day, course).length == 0 ? "" :
                this.ctrl.listToString(this.agenda, this.semSelection, day, course).split("\\n")[2].split(" ")[2])
                + "  " +
                (this.ctrl.listToString(this.agenda, this.semSelection, day, course).length == 0 ? "" :
                (this.ctrl.listToString(this.agenda, this.semSelection, day, course).split("\\n")[3].split(" : ")[1].split('')[0] != ":" ?
                this.ctrl.listToString(this.agenda, this.semSelection, day, course).split("\\n")[3].split(" : ")[1] :
                this.ctrl.listToString(this.agenda, this.semSelection, day, course).split("\\n")[3].split(" : ")[1].split(": ")[1]))
                ,textAlign: TextAlign.center,
                  style: TextStyle(color: (this.ctrl.listToString(this.agenda, this.semSelection, day, course).length == 0 ? Colors.white :
                  HexColor.fromHex(HexColor.stringToHex(this.ctrl.listToString(this.agenda, this.semSelection, day, course)
                  .split("\\n")[4].split(" ")[3])))
                  ),
                ),
              ),
              onTap: () async {
                if(this.ctrl.listToString(this.agenda, this.semSelection, day, course).length != 0) {
                DateTime currentCourse = new DateTime(
                  int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, course).split("\\n")[5].split(" ")[0]),
                  int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, course).split("\\n")[5].split(" ")[1]),
                  int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, course).split("\\n")[5].split(" ")[2]),
                  int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, course).split("\\n")[5].split(" ")[3]),
                  int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, course).split("\\n")[5].split(" ")[4]),
                );
                String note = await this.ctrl.getNote(currentCourse);
                String value = this.textFieldCtrl.text;
                return showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Informations sur le cours', style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                      backgroundColor: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.grey[800] : Colors.white),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text("Cours : " + this.ctrl.listToString(this.agenda, this.semSelection, day, course)
                            .split("\\n")[0].split(" ")[2], style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                            Text("Professeur : " + this.ctrl.getNameFirstName(this.ctrl.listToString(this.agenda, this.semSelection, day, course)
                            .split("\\n")[2].split(" ")[2]), style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                            Text("Salle : " + 
                              (this.ctrl.listToString(this.agenda, this.semSelection, day, course).split("\\n")[3].split(" : ")[1].split('')[0] != ":" ?
                              this.ctrl.listToString(this.agenda, this.semSelection, day, course).split("\\n")[3].split(" : ")[1] :
                              this.ctrl.listToString(this.agenda, this.semSelection, day, course).split("\\n")[3].split(" : ")[1].split(": ")[1])
                            +"\n"
                            , style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                            TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Note',
                            ),
                            controller: this.textFieldCtrl = TextEditingController(text: note),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Ok'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            if(this.textFieldCtrl.text != value)
                              this.ctrl.setNote(currentCourse, this.textFieldCtrl.text);},
                        ),
                      ],
                    );
                  },
                );
                }
              },
            )
          )
        ));
      }
    }
    return cont;
  }


  //Test function
  void test() {
    setState(() {
    });
  }




  @override
  Widget build(BuildContext context) {

      //Portrait page
    Widget portrait() {
      return Scaffold(

        appBar: AppBar(
          title: new Text("Agenda"),
          actions: <Widget>[
            new IconButton(icon: Icon(Icons.refresh), tooltip: 'Rafraichir', onPressed: () {updateAllDatas(false);}),
            new IconButton(icon: Icon(Icons.brightness_4), tooltip: 'Theme', onPressed: switchTheme),
            PopupMenuButton(
              onSelected: (result) { setState(() { popMenuSelection = result; widget.bottom.switchParam();}); },
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
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
                  }); updatePickers(true);},
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
                        updatePickers(this.loadFinish);
                        final String label = tab.text;
                        var day = this.dayTabs.indexOf(tab);
                        return Row(

                          children: [
                            SingleChildScrollView(
                              child: Container(
                                alignment: Alignment.center,
                                margin: new EdgeInsets.only(left: 20.0, right: 10.0),
                                child: Column(children: [
                                  Container(child: Text("8h00"), margin: new EdgeInsets.only(top: 5)),
                                  Container(child: Text("9h25"), margin: new EdgeInsets.only(top: 40)),
                                  Container(child: Text("9h30"), margin: new EdgeInsets.only(top: 15)),
                                  Container(child: Text("10h55"), margin: new EdgeInsets.only(top: 40)),
                                  Container(child: Text("11h00"), margin: new EdgeInsets.only(top: 13)),
                                  Container(child: Text("12h25"), margin: new EdgeInsets.only(top: 40)),
                                  Container(child: Text("14h15"), margin: new EdgeInsets.only(top: 13)),
                                  Container(child: Text("15h40"), margin: new EdgeInsets.only(top: 40)),
                                  Container(child: Text("15h45"), margin: new EdgeInsets.only(top: 13)),
                                  Container(child: Text("16h25"), margin: new EdgeInsets.only(top: 40)),
                                  Container(child: Text("16h30"), margin: new EdgeInsets.only(top: 13)),
                                  Container(child: Text("17h40"), margin: new EdgeInsets.only(top: 40)),
                                ])
                              ),
                            ),
                            Expanded(
                            child: ListView(
                              children: <Widget>[
                                Container(
                                  height: 85,
                                  margin: new EdgeInsets.only(right: 20),
                                  child: (this.ctrl.listToString(this.agenda, this.semSelection, day, 0) == "" ? Card() : Card(
                                    color: (this.agenda.length == 0 ? Colors.grey[800] : 
                                    HexColor.fromHex(this.ctrl.listToString(this.agenda, this.semSelection, day, 0).split("\\n")[4].split(" ")[1].split("#")[1])),
                                    child: ListTile(
                                      title: Center(child: Text(
                                        (this.agenda.length == 0 ? "" :
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 0).split("\\n")[0].split(" ")[2]) +
                                        "\n" +
                                        (this.agenda.length == 0 ? "" :
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 0).split("\\n")[2].split(" ")[2]) +
                                        "\n" +
                                        (this.agenda.length == 0 ? "" :
                                        (this.ctrl.listToString(this.agenda, this.semSelection, day, 0).split("\\n")[3].split(" : ")[1].split('')[0] != ":" ?
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 0).split("\\n")[3].split(" : ")[1] :
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 0).split("\\n")[3].split(" : ")[1].split(": ")[1]))
                                        ,textAlign: TextAlign.center,
                                          style: TextStyle(color: (this.agenda.length == 0 ? Colors.white :
                                          HexColor.fromHex(HexColor.stringToHex(this.ctrl.listToString(this.agenda, this.semSelection, day, 0)
                                          .split("\\n")[4].split(" ")[3])))),
                                        )
                                      ),
                                      onTap: () async {
                                        if(this.agenda.length != 0) {
                                        DateTime currentCourse = new DateTime(
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 0).split("\\n")[5].split(" ")[0]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 0).split("\\n")[5].split(" ")[1]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 0).split("\\n")[5].split(" ")[2]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 0).split("\\n")[5].split(" ")[3]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 0).split("\\n")[5].split(" ")[4]),
                                        );
                                        String note = await this.ctrl.getNote(currentCourse);
                                        String value = this.textFieldCtrl.text;
                                        return showDialog<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Informations sur le cours', style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                              backgroundColor: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.grey[800] : Colors.white),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    Text("Cours : " + this.ctrl.listToString(this.agenda, this.semSelection, day, 0)
                                                    .split("\\n")[0].split(" ")[2], style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                                    Text("Professeur : " + this.ctrl.getNameFirstName(this.ctrl.listToString(this.agenda, this.semSelection, day, 0)
                                                    .split("\\n")[2].split(" ")[2]), style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                                    Text("Salle : " + 
                                                      (this.ctrl.listToString(this.agenda, this.semSelection, day, 0).split("\\n")[3].split(" : ")[1].split('')[0] != ":" ?
                                                      this.ctrl.listToString(this.agenda, this.semSelection, day, 0).split("\\n")[3].split(" : ")[1] :
                                                      this.ctrl.listToString(this.agenda, this.semSelection, day, 0).split("\\n")[3].split(" : ")[1].split(": ")[1])
                                                    +"\n"
                                                    , style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                                    TextField(
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      labelText: 'Note',
                                                    ),
                                                    controller: this.textFieldCtrl = TextEditingController(text: note),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('Ok'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    if(this.textFieldCtrl.text != value)
                                                      this.ctrl.setNote(currentCourse, this.textFieldCtrl.text);},
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        }
                                      },
                                    )
                                  )),
                                ),
                                Container(
                                  height: 85,
                                  margin: new EdgeInsets.only(right: 20),
                                  child: (this.ctrl.listToString(this.agenda, this.semSelection, day, 1) == "" ? Card() : Card(
                                    color: (this.agenda.length == 0 ? Colors.grey[800] : 
                                    HexColor.fromHex(this.ctrl.listToString(this.agenda, this.semSelection, day, 1).split("\\n")[4].split(" ")[1].split("#")[1])),
                                    child: ListTile(
                                      title: Center(child: Text(
                                        (this.agenda.length == 0 ? "" :
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 1).split("\\n")[0].split(" ")[2]) +
                                        "\n" +
                                        (this.agenda.length == 0 ? "" :
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 1).split("\\n")[2].split(" ")[2]) +
                                        "\n" +
                                        (this.agenda.length == 0 ? "" :
                                        (this.ctrl.listToString(this.agenda, this.semSelection, day, 1).split("\\n")[3].split(" : ")[1].split('')[0] != ":" ?
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 1).split("\\n")[3].split(" : ")[1] :
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 1).split("\\n")[3].split(" : ")[1].split(": ")[1]))
                                        ,textAlign: TextAlign.center,
                                          style: TextStyle(color: (this.agenda.length == 0 ? Colors.white :
                                          HexColor.fromHex(HexColor.stringToHex(this.ctrl.listToString(this.agenda, this.semSelection, day, 1)
                                          .split("\\n")[4].split(" ")[3])))),
                                        )
                                      ),
                                      onTap: () async {
                                        if(this.agenda.length != 0) {
                                        DateTime currentCourse = new DateTime(
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 1).split("\\n")[5].split(" ")[0]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 1).split("\\n")[5].split(" ")[1]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 1).split("\\n")[5].split(" ")[2]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 1).split("\\n")[5].split(" ")[3]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 1).split("\\n")[5].split(" ")[4]),
                                        );
                                        String note = await this.ctrl.getNote(currentCourse);
                                        String value = this.textFieldCtrl.text;
                                        return showDialog<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Informations sur le cours', style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                              backgroundColor: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.grey[800] : Colors.white),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    Text("Cours : " + this.ctrl.listToString(this.agenda, this.semSelection, day, 1)
                                                    .split("\\n")[0].split(" ")[2], style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                                    Text("Professeur : " + this.ctrl.getNameFirstName(this.ctrl.listToString(this.agenda, this.semSelection, day, 1)
                                                    .split("\\n")[2].split(" ")[2]), style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                                    Text("Salle : " + 
                                                      (this.ctrl.listToString(this.agenda, this.semSelection, day, 1).split("\\n")[3].split(" : ")[1].split('')[0] != ":" ?
                                                      this.ctrl.listToString(this.agenda, this.semSelection, day, 1).split("\\n")[3].split(" : ")[1] :
                                                      this.ctrl.listToString(this.agenda, this.semSelection, day, 1).split("\\n")[3].split(" : ")[1].split(": ")[1])
                                                    +"\n"
                                                    , style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                                    TextField(
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      labelText: 'Note',
                                                    ),
                                                    controller: this.textFieldCtrl = TextEditingController(text: note),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('Ok'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    if(this.textFieldCtrl.text != value)
                                                      this.ctrl.setNote(currentCourse, this.textFieldCtrl.text);},
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        }
                                      },
                                    )
                                  )),
                                ),
                                Container(
                                  height: 85,
                                  margin: new EdgeInsets.only(right: 20),
                                  child: (this.ctrl.listToString(this.agenda, this.semSelection, day, 2) == "" ? Card() : Card(
                                    color: (this.agenda.length == 0 ? Colors.grey[800] : 
                                    HexColor.fromHex(this.ctrl.listToString(this.agenda, this.semSelection, day, 2).split("\\n")[4].split(" ")[1].split("#")[1])),
                                    child: ListTile(
                                      title: Center(child: Text(
                                        (this.agenda.length == 0 ? "" :
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 2).split("\\n")[0].split(" ")[2]) +
                                        "\n" +
                                        (this.agenda.length == 0 ? "" :
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 2).split("\\n")[2].split(" ")[2]) +
                                        "\n" +
                                        (this.agenda.length == 0 ? "" :
                                        (this.ctrl.listToString(this.agenda, this.semSelection, day, 2).split("\\n")[3].split(" : ")[1].split('')[0] != ":" ?
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 2).split("\\n")[3].split(" : ")[1] :
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 2).split("\\n")[3].split(" : ")[1].split(": ")[1]))
                                        ,textAlign: TextAlign.center,
                                          style: TextStyle(color: (this.agenda.length == 0 ? Colors.white :
                                          HexColor.fromHex(HexColor.stringToHex(this.ctrl.listToString(this.agenda, this.semSelection, day, 2)
                                          .split("\\n")[4].split(" ")[3])))),
                                        )
                                      ),
                                      onTap: () async {
                                        if(this.agenda.length != 0) {
                                        DateTime currentCourse = new DateTime(
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 2).split("\\n")[5].split(" ")[0]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 2).split("\\n")[5].split(" ")[1]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 2).split("\\n")[5].split(" ")[2]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 2).split("\\n")[5].split(" ")[3]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 2).split("\\n")[5].split(" ")[4]),
                                        );
                                        String note = await this.ctrl.getNote(currentCourse);
                                        String value = this.textFieldCtrl.text;
                                        return showDialog<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Informations sur le cours', style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                              backgroundColor: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.grey[800] : Colors.white),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    Text("Cours : " + this.ctrl.listToString(this.agenda, this.semSelection, day, 2)
                                                    .split("\\n")[0].split(" ")[2], style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                                    Text("Professeur : " + this.ctrl.getNameFirstName(this.ctrl.listToString(this.agenda, this.semSelection, day, 2)
                                                    .split("\\n")[2].split(" ")[2]), style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                                    Text("Salle : " +
                                                      (this.ctrl.listToString(this.agenda, this.semSelection, day, 2).split("\\n")[3].split(" : ")[1].split('')[0] != ":" ?
                                                      this.ctrl.listToString(this.agenda, this.semSelection, day, 2).split("\\n")[3].split(" : ")[1] :
                                                      this.ctrl.listToString(this.agenda, this.semSelection, day, 2).split("\\n")[3].split(" : ")[1].split(": ")[1])
                                                    +"\n"
                                                    , style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                                    TextField(
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      labelText: 'Note',
                                                    ),
                                                    controller: this.textFieldCtrl = TextEditingController(text: note),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('Ok'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    if(this.textFieldCtrl.text != value)
                                                      this.ctrl.setNote(currentCourse, this.textFieldCtrl.text);},
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        }
                                      },
                                    )
                                  )),
                                ),
                                Container(
                                  height: 85,
                                  margin: new EdgeInsets.only(right: 20),
                                  child: (this.ctrl.listToString(this.agenda, this.semSelection, day, 3) == "" ? Card() : Card(
                                    color: (this.agenda.length == 0 ? Colors.grey[800] : 
                                    HexColor.fromHex(this.ctrl.listToString(this.agenda, this.semSelection, day, 3).split("\\n")[4].split(" ")[1].split("#")[1])),
                                    child: ListTile(
                                      title: Center(child: Text(
                                        (this.agenda.length == 0 ? "" :
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 3).split("\\n")[0].split(" ")[2]) +
                                        "\n" +
                                        (this.agenda.length == 0 ? "" :
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 3).split("\\n")[2].split(" ")[2]) +
                                        "\n" +
                                        (this.agenda.length == 0 ? "" :
                                        (this.ctrl.listToString(this.agenda, this.semSelection, day, 3).split("\\n")[3].split(" : ")[1].split('')[0] != ":" ?
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 3).split("\\n")[3].split(" : ")[1] :
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 3).split("\\n")[3].split(" : ")[1].split(": ")[1]))
                                        ,textAlign: TextAlign.center,
                                          style: TextStyle(color: (this.agenda.length == 0 ? Colors.white :
                                          HexColor.fromHex(HexColor.stringToHex(this.ctrl.listToString(this.agenda, this.semSelection, day, 3)
                                          .split("\\n")[4].split(" ")[3])))),
                                        )
                                      ),
                                      onTap: () async {
                                        if(this.agenda.length != 0) {
                                        DateTime currentCourse = new DateTime(
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 3).split("\\n")[5].split(" ")[0]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 3).split("\\n")[5].split(" ")[1]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 3).split("\\n")[5].split(" ")[2]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 3).split("\\n")[5].split(" ")[3]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 3).split("\\n")[5].split(" ")[4]),
                                        );
                                        String note = await this.ctrl.getNote(currentCourse);
                                        String value = this.textFieldCtrl.text;
                                        return showDialog<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Informations sur le cours', style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                              backgroundColor: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.grey[800] : Colors.white),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    Text("Cours : " + this.ctrl.listToString(this.agenda, this.semSelection, day, 3)
                                                    .split("\\n")[0].split(" ")[2], style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                                    Text("Professeur : " + this.ctrl.getNameFirstName(this.ctrl.listToString(this.agenda, this.semSelection, day, 3)
                                                    .split("\\n")[2].split(" ")[2]), style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                                    Text("Salle : " +
                                                      (this.ctrl.listToString(this.agenda, this.semSelection, day, 3).split("\\n")[3].split(" : ")[1].split('')[0] != ":" ?
                                                      this.ctrl.listToString(this.agenda, this.semSelection, day, 3).split("\\n")[3].split(" : ")[1] :
                                                      this.ctrl.listToString(this.agenda, this.semSelection, day, 3).split("\\n")[3].split(" : ")[1].split(": ")[1])
                                                    +"\n"
                                                    , style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                                    TextField(
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      labelText: 'Note',
                                                    ),
                                                    controller: this.textFieldCtrl = TextEditingController(text: note),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('Ok'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    if(this.textFieldCtrl.text != value)
                                                      this.ctrl.setNote(currentCourse, this.textFieldCtrl.text);},
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        }
                                      },
                                    )
                                  )),
                                ),
                                Container(
                                  height: 85,
                                  margin: new EdgeInsets.only(right: 20),
                                  child: (this.ctrl.listToString(this.agenda, this.semSelection, day, 4) == "" ? Card() : Card(
                                    color: (this.agenda.length == 0 ? Colors.grey[800] : 
                                    HexColor.fromHex(this.ctrl.listToString(this.agenda, this.semSelection, day, 4).split("\\n")[4].split(" ")[1].split("#")[1])),
                                    child: ListTile(
                                      title: Center(child: Text(
                                        (this.agenda.length == 0 ? "" :
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 4).split("\\n")[0].split(" ")[2]) +
                                        "\n" +
                                        (this.agenda.length == 0 ? "" :
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 4).split("\\n")[2].split(" ")[2]) +
                                        "\n" +
                                        (this.agenda.length == 0 ? "" :
                                        (this.ctrl.listToString(this.agenda, this.semSelection, day, 4).split("\\n")[3].split(" : ")[1].split('')[0] != ":" ?
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 4).split("\\n")[3].split(" : ")[1] :
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 4).split("\\n")[3].split(" : ")[1].split(": ")[1]))
                                        ,textAlign: TextAlign.center,
                                          style: TextStyle(color: (this.agenda.length == 0 ? Colors.white :
                                          HexColor.fromHex(HexColor.stringToHex(this.ctrl.listToString(this.agenda, this.semSelection, day, 3)
                                          .split("\\n")[4].split(" ")[3])))),
                                        )
                                      ),
                                      onTap: () async {
                                        if(this.agenda.length != 0) {
                                        DateTime currentCourse = new DateTime(
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 4).split("\\n")[5].split(" ")[0]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 4).split("\\n")[5].split(" ")[1]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 4).split("\\n")[5].split(" ")[2]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 4).split("\\n")[5].split(" ")[3]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 4).split("\\n")[5].split(" ")[4]),
                                        );
                                        String note = await this.ctrl.getNote(currentCourse);
                                        String value = this.textFieldCtrl.text;
                                        return showDialog<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Informations sur le cours', style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                              backgroundColor: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.grey[800] : Colors.white),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    Text("Cours : " + this.ctrl.listToString(this.agenda, this.semSelection, day, 4)
                                                    .split("\\n")[0].split(" ")[2], style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                                    Text("Professeur : " + this.ctrl.getNameFirstName(this.ctrl.listToString(this.agenda, this.semSelection, day, 4)
                                                    .split("\\n")[2].split(" ")[2]), style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                                    Text("Salle : " +
                                                      (this.ctrl.listToString(this.agenda, this.semSelection, day, 4).split("\\n")[3].split(" : ")[1].split('')[0] != ":" ?
                                                      this.ctrl.listToString(this.agenda, this.semSelection, day, 4).split("\\n")[3].split(" : ")[1] :
                                                      this.ctrl.listToString(this.agenda, this.semSelection, day, 4).split("\\n")[3].split(" : ")[1].split(": ")[1])
                                                    +"\n"
                                                    , style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                                    TextField(
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      labelText: 'Note',
                                                    ),
                                                    controller: this.textFieldCtrl = TextEditingController(text: note),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('Ok'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    if(this.textFieldCtrl.text != value)
                                                      this.ctrl.setNote(currentCourse, this.textFieldCtrl.text);},
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        }
                                      },
                                    )
                                  )),
                                ),
                                Container(
                                  height: 85,
                                  margin: new EdgeInsets.only(right: 20),
                                  child: (this.ctrl.listToString(this.agenda, this.semSelection, day, 5) == "" ? Card() : Card(
                                    color: (this.agenda.length == 0 ? Colors.grey[800] : 
                                    HexColor.fromHex(this.ctrl.listToString(this.agenda, this.semSelection, day, 5).split("\\n")[4].split(" ")[1].split("#")[1])),
                                    child: ListTile(
                                      title: Center(child: Text(
                                        (this.agenda.length == 0 ? "" :
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 5).split("\\n")[0].split(" ")[2]) +
                                        "\n" +
                                        (this.agenda.length == 0 ? "" :
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 5).split("\\n")[2].split(" ")[2]) +
                                        "\n" +
                                        (this.agenda.length == 0 ? "" :
                                        (this.ctrl.listToString(this.agenda, this.semSelection, day, 5).split("\\n")[3].split(" : ")[1].split('')[0] != ":" ?
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 5).split("\\n")[3].split(" : ")[1] :
                                        this.ctrl.listToString(this.agenda, this.semSelection, day, 5).split("\\n")[3].split(" : ")[1].split(": ")[1]))
                                        ,textAlign: TextAlign.center,
                                          style: TextStyle(color: (this.agenda.length == 0 ? Colors.white :
                                          HexColor.fromHex(HexColor.stringToHex(this.ctrl.listToString(this.agenda, this.semSelection, day, 1)
                                          .split("\\n")[4].split(" ")[3])))),
                                        )
                                      ),
                                      onTap: () async {
                                        if(this.agenda.length != 0) {
                                        DateTime currentCourse = new DateTime(
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 5).split("\\n")[5].split(" ")[0]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 5).split("\\n")[5].split(" ")[1]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 5).split("\\n")[5].split(" ")[2]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 5).split("\\n")[5].split(" ")[3]),
                                          int.parse(this.ctrl.listToString(this.agenda, this.semSelection, day, 5).split("\\n")[5].split(" ")[4]),
                                        );
                                        String note = await this.ctrl.getNote(currentCourse);
                                        String value = this.textFieldCtrl.text;
                                        return showDialog<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Informations sur le cours', style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                              backgroundColor: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.grey[800] : Colors.white),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    Text("Cours : " + this.ctrl.listToString(this.agenda, this.semSelection, day, 5)
                                                    .split("\\n")[0].split(" ")[2], style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                                    Text("Professeur : " + this.ctrl.getNameFirstName(this.ctrl.listToString(this.agenda, this.semSelection, day, 5)
                                                    .split("\\n")[2].split(" ")[2]), style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                                    Text("Salle : " +
                                                      (this.ctrl.listToString(this.agenda, this.semSelection, day, 5).split("\\n")[3].split(" : ")[1].split('')[0] != ":" ?
                                                      this.ctrl.listToString(this.agenda, this.semSelection, day, 5).split("\\n")[3].split(" : ")[1] :
                                                      this.ctrl.listToString(this.agenda, this.semSelection, day, 5).split("\\n")[3].split(" : ")[1].split(": ")[1])
                                                    +"\n"
                                                    , style: TextStyle(color: (widget.bottom.dataPage.theme == Brightness.dark ? Colors.white : Colors.black))),
                                                    TextField(
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      labelText: 'Note',
                                                    ),
                                                    controller: this.textFieldCtrl = TextEditingController(text: note),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('Ok'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    if(this.textFieldCtrl.text != value)
                                                      this.ctrl.setNote(currentCourse, this.textFieldCtrl.text);},
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        }
                                      },
                                    )
                                  )),
                                ),

                              ],
                            )
                            /*child: Text(
                              'This is the $label tab' + day.toString() + this.semSelection.toString(),
                              style: const TextStyle(fontSize: 36),
                            ),*/
                          )
                          ]
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
                          if(newValue != this.pickPromo) {
                            this.ctrl.savePickers(newValue, null, null);
                            this.teachersGroups = await this.ctrl.switchChanged();
                            this.pickTeachGroup = this.teachersGroups[0];
                            var pickersSelect = await this.ctrl.getPickersSelect();
                            setState(() {
                              this.pickPromo = newValue;
                              this.pickTeachStudent = pickersSelect[1];
                              //print(pickersSelect[2]);
                            });
                          }
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
                          if(newValue != this.pickTeachGroup) {
                            this.ctrl.savePickers(null, newValue, null);
                            this.teachersGroups = await this.ctrl.switchChanged();
                            this.pickTeachGroup = this.teachersGroups[0];
                            var pickersSelect = await this.ctrl.getPickersSelect();
                            setState(() {
                              //print(this.ctrl.agData.pickTeachStudent);
                              //this.loadFinish = false;
                              //this.ctrl.agData.pickTeachStudent = newValue;
                              this.pickPromo = pickersSelect[0];
                              this.pickTeachStudent = newValue;
                              //this.pickTeachGroup = pickersSelect[2];
                            });
                          }
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
                          if(newValue != this.pickTeachGroup) {
                            this.ctrl.savePickers(null, null, newValue);
                            updateAllDatas(false);
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
                          }
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
      );
    }


      //Landscape Page
    Widget landscape() {
      return  Scaffold(
        appBar: AppBar(
            title: TabBar(
            onTap: (index) {setState(() {
              this.semSelection = index;
            });},
            controller: this.semTabController,
            tabs: this.semTabs,
            labelColor: this.tabLabelColor,
          )
        ),
        body: TabBarView(
          controller: this.semTabController,
          children: <Widget>[
            GridView.count(
              //physics: new NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10.0,
              crossAxisCount: 5,
              childAspectRatio: (34 / 10),
              children: getDaysNCourses(0)
            ),
            GridView.count(
              //physics: new NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10.0,
              crossAxisCount: 5,
              childAspectRatio: (34 / 10),
              children: getDaysNCourses(1)
            ),
            GridView.count(
              //physics: new NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10.0,
              crossAxisCount: 5,
              childAspectRatio: (34 / 10),
              children: getDaysNCourses(2)
            ),
            GridView.count(
              //physics: new NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10.0,
              crossAxisCount: 5,
              childAspectRatio: (34 / 10),
              children: getDaysNCourses(3)
            ),
          ],
        )
      );
    }

    /*
    TabBarView(
          controller: this.semTabController,
          children: sems.map((sem) { 
              GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 5,
                children: days.map((day) {
                  for(int course in courses) {
                    new Text(days.toString() + "  " + course.toString());
                  }
                }).toList(),
                );
              }).toList()
            
            )*/


      //Final page

    return MaterialApp(
      title:"Agenda",
      theme: ThemeData(
        brightness: widget.bottom.dataPage.theme,
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: portrait() /*OrientationBuilder(
          builder: (context, orientation) {
            if(orientation == Orientation.portrait) {
              return portrait();
            } else {
              return landscape();
            }
          }
        )*/

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
    );
    
  }
}