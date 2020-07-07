import 'package:flutter/material.dart';

import 'package:bflop/model/data/dataSave.dart';

class AgendaData extends DataSave {

  //ATTRIBUTES
    //Theme
  Brightness theme;

    //Calendar (agenda) list : all events
  var agList;
  //Month, Week, Day, Courses
  var teachList;
  //Promo, Teacher, Infos
  var groupList;
  //Promo, Group, Infos
  bool reloadLog;

  //Colors
  Map<String, List<String>> colors;

  Map<DateTime, String> notes;

    //Picker
  //Promo choosen  
  String pickPromo = 'Info';
  //Teacher or group choice choosen
  String pickTeachStudent = 'Elève';
  //Teacher or group list choosen
  String pickGroup = 'INFO1-1A';


    AgendaData.single() : super.single() {

      //List<String> day = new List<String>(6);
      var month = [[new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6)],
        [new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6)],
        [new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6)],
        [new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6)]];

      this.agList = month;

      this.teachList = new List<List<List<String>>>();
      this.groupList = new List<List<List<String>>>();

      this.notes = new Map<DateTime, String>();

      this.colors = new Map<String, List<String>>();
      colorInitializer();

    }

    AgendaData.theme(Brightness theme) : super.theme(theme) {
      
    }

    colorInitializer() {
      colors["MPA"] = ["#89CA57", Colors.black.toString()];
      colors["CPAN"] = ["#2C2C2C", Colors.white.toString()];
      colors["CP"] = ["#A31526", Colors.white.toString()];
      colors["BDA"] = ["#5D3676", Colors.white.toString()];
      colors["ANI"] = ["#FB71E0", Colors.black.toString()];
      colors["PPP3"] = ["#C697F4", Colors.black.toString()];
      colors["IAP"] = ["#8BE7F9", Colors.black.toString()];
      colors["GSI"] = ["#458612", Colors.white.toString()];
      colors["PRST"] = ["#8B500E", Colors.white.toString()];
      colors["ISI"] = ["#FE16F4", Colors.white.toString()];
      colors["AA"] = ["#0CC0AA", Colors.black.toString()];
      colors["PSE"] = ["#68AFFC", Colors.black.toString()];
      colors["PPP1"] = ["#104B6D", Colors.white.toString()];
      colors["FO"] = ["#6847FC", Colors.white.toString()];
      colors["SC"] = ["#21F0B6", Colors.white.toString()];
      colors["DTIC"] = ["#D547CA", Colors.black.toString()];
      colors["MM"] = ["#710C9E", Colors.white.toString()];
      colors["MPA"] = ["#89CA57", Colors.black.toString()];
      colors["EE"] = ["#C0E087", Colors.black.toString()];
      colors["MD"] = ["#F2C029", Colors.black.toString()];
      colors["PWS"] = ["#F76015", Colors.black.toString()];
      colors["APSIO"] = ["#DC58EA", Colors.black.toString()];
      colors["Comm"] = ["#40655E", Colors.white.toString()];
      colors["MNJa"] = ["#09F54C", Colors.black.toString()];
      colors["CDIN"] = ["#BF40BC", Colors.white.toString()];
      colors["LL"] = ["#862593", Colors.white.toString()];
      colors["MNLi"] = ["#E41A72", Colors.white.toString()];
      colors["MNBD"] = ["#E41A72", Colors.white.toString()];
      colors["IBD"] = ["#518413", Colors.white.toString()];
      colors["Droit"] = ["#40655E", Colors.white.toString()];
      colors["UML"] = ["#DC58EA", Colors.black.toString()];
      colors["EAD"] = ["#DC58EA", Colors.black.toString()];
      colors["FC"] = ["#DC58EA", Colors.white.toString()];
      colors["EFJ"] = ["#E41A72", Colors.white.toString()];
      colors["AL"] = ["#5BE13E", Colors.black.toString()];
      colors["CPOA"] = ["#FAA566", Colors.black.toString()];
      colors["SDA"] = ["#1F3CA6", Colors.white.toString()];
      colors[".NET"] = ["#19A71F", Colors.white.toString()];
      colors["Cryp"] = ["#9C4050", Colors.white.toString()];
      colors["SP"] = ["#5D3676", Colors.white.toString()];
      colors["JEE"] = ["#5D3676", Colors.black.toString()];
      colors["SR"] = ["#5D3676", Colors.white.toString()];
      colors["Angu"] = ["#862593", Colors.white.toString()];
      colors["Angl"] = ["#E41A72", Colors.white.toString()];
      colors["CWS"] = ["#9BEA30", Colors.black.toString()];
      colors["GP"] = ["#C0E087", Colors.black.toString()];
      colors["APR"] = ["#BF40BC", Colors.white.toString()];
      colors["ACE"] = ["#89CA57", Colors.black.toString()];
      colors["PABD"] = ["#1F3CA6", Colors.white.toString()];
      colors["C#"] = ["#09F54C", Colors.black.toString()];
      colors["TA"] = ["#2918C1", Colors.white.toString()];
      colors["Prog"] = ["#36EDD3", Colors.black.toString()];
      colors["EGD"] = ["#FE16F4", Colors.white.toString()];
      colors["IE"] = ["#214A65", Colors.white.toString()];
      colors["PPP"] = ["#104B6D", Colors.white.toString()];
      colors["IA"] = ["#FAA566", Colors.black.toString()];
      colors["GLA"] = ["#F2C029", Colors.black.toString()];
      colors["PR"] = ["#17F46F", Colors.black.toString()];
      colors["Gest"] = ["#9C4050", Colors.white.toString()];
      colors["CO"] = ["#A31526", Colors.white.toString()];
      colors["POO"] = ["#FB9046", Colors.black.toString()];
      colors["COO"] = ["#6847FC", Colors.white.toString()];
      colors["Ergo"] = ["#DC58EA", Colors.black.toString()];
      colors["CDAM"] = ["#8B500E", Colors.white.toString()];
      colors["PTUT"] = ["#FA718E", Colors.black.toString()];
      colors["GA"] = ["#5D3676", Colors.white.toString()];
      colors["FLOP"] = ["#89CA57", Colors.black.toString()];
      colors["Comport"] = ["#40655E", Colors.white.toString()];
      colors["Scrum"] = ["#09F54C", Colors.black.toString()];
      colors["IoT"] = ["#862593", Colors.white.toString()];
      colors["Crypt"] = ["#DC58EA", Colors.black.toString()];
      colors["CIA"] = ["#841E41", Colors.white.toString()];
      colors["CDAM"] = ["#8B500E", Colors.white.toString()];
      colors["AMN"] = ["#BF40BC", Colors.white.toString()];
      colors["RES"] = ["#F9B2D1", Colors.black.toString()];
      colors["IHM"] = ["#21F0B6", Colors.black.toString()];
      colors["FW"] = ["#F76015", Colors.black.toString()];
      colors["PR"] = ["#17F46F", Colors.black.toString()];
      colors["Cloud"] = ["#09F54C", Colors.black.toString()];
      colors["Andr"] = ["#862593", Colors.black.toString()];
      colors["Web"] = ["#36EDD3", Colors.black.toString()];
      colors["AJEE"] = ["#9BEA30", Colors.black.toString()];
      colors["C DW"] = ["#F34207", Colors.black.toString()];

    }

}