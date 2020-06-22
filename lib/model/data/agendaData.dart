import 'package:flutter/material.dart';

import 'package:bflop/model/data/dataSave.dart';

class AgendaData extends DataSave {

  Brightness theme;
  List<List> agList;

    AgendaData.single() : super.single() {
      this.agList = new List<List>();
    }

    AgendaData.theme(Brightness theme) : super.theme(theme) {
      
    }

}