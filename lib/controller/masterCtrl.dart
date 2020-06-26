import 'package:flutter/material.dart';

import 'package:bflop/model/masterModel.dart';

class MasterCtrl {

  bool test;

  MasterModel masterModel = new MasterModel();

  MasterCtrl() {
    test = false;
  }

    //Switch theme
  switchTheme(Brightness theme, bool isStart) async {
    if(isStart) {
      bool res = await this.masterModel.getValue('darkTheme');
      if(res == null) return Brightness.light;
      else if(res) return Brightness.dark;
      else return Brightness.light;
    } else {
      if(theme == Brightness.dark) {
        this.masterModel.saveData('darkTheme', false);
        return Brightness.light;
      } else {
        this.masterModel.saveData('darkTheme', true);
        return Brightness.dark;
        /*
        this.masterModel.saveData('darkTheme', true);
        return await this.masterModel.getValue('darkTheme');
        */
      }
    }
  }


}