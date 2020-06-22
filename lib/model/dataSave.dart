import 'package:flutter/material.dart';

import 'package:bflop/controller/masterCtrl.dart';

class DataSave {

  String title;
  Brightness theme;
  List<bool> listIndex;
  int index;


    DataSave(String title, Brightness theme, List<bool> list) {
      this.title = title;
      this.theme = theme;
      this.listIndex = list;
    }

}