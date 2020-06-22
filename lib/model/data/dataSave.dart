import 'package:flutter/material.dart';

import 'package:bflop/controller/masterCtrl.dart';

class DataSave {

  Brightness theme;

    DataSave.single() {
      
    }

    DataSave.theme(Brightness theme) {
      this.theme = theme;
    }

}