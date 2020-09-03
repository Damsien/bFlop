import 'package:flutter/material.dart';

import 'package:bflop/model/data/dataSave.dart';

class ParamData extends DataSave {

  Brightness theme;
  bool isConnected = false;

  ParamData(Brightness theme) : super.theme(theme) {
    
  }

  ParamData.single() : super.single() {
    
  }

}