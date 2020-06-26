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

    AgendaData.single() : super.single() {

      //List<String> day = new List<String>(6);
      var month = [[new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6)],
        [new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6)],
        [new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6)],
        [new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6)]];

      this.agList = month;

      this.teachList = new List<List<List>>();
      this.groupList = new List<List<List>>();
    }

    AgendaData.theme(Brightness theme) : super.theme(theme) {
      
    }

}