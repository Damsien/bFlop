import 'package:bflop/model/data/agendaData.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:html/parser.dart';

import './masterCtrl.dart';
import 'package:bflop/model/agendaPageModel.dart';

class AgendaPageCtrl extends MasterCtrl {

  AgendaPageModel agendaPageMod = new AgendaPageModel();
  AgendaData agData = new AgendaData.single();

  AgendaPageCtrl() {
    
  }

  void fetchTest() async {
    
    var doc = await this.agendaPageMod.fetchTest();
    var docS = json.encode(utf8.decode(doc.bodyBytes));
    var finalJson = jsonParser(docS);
    print(json.decode(finalJson)[0][0]);
    
  }


  jsonParser(String string) {
    List<String> cal = string.split("\\r\\n").toList();
    bool isEvent = false;

    for(int i=0; i<cal.length; i++) {
      if(cal[i] == "END:VEVENT") isEvent = false;
      if(isEvent) {
        if(cal[i].split(":")[0] == "DESCRIPTION") {
          agData.agList.add([cal[i].split(":")[0], (cal[i].split(":")[1] + ":" + cal[i].split(":")[2] + ":" + cal[i].split(":")[3] +
          ":" + cal[i].split(":")[4] + ":" + cal[i+1])]);
        i++;
        } else
          agData.agList.add([cal[i].split(":")[0], cal[i].split(":")[1]]);
      }
      if(cal[i] == "BEGIN:VEVENT") isEvent = true;
    }
    return json.encode(this.agData.agList);
  }


}