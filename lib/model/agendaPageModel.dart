import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:bflop/model/masterModel.dart';

class AgendaPageModel extends MasterModel {

  int reloadLogTime;

  AgendaPageModel() {

  }

  //Fetch calendar data
  Future<http.Response> fetchAgenda(String url) {
    return http.get(url,
        headers: {'Content-Type': 'text/calendar'}
    );
  }

  //Fetch student/teachers data
  Future<http.Response> fetchGroupTeach(String url) {
    return http.get(url,
        headers: {'Content-Type': 'text/html'}
    );
  }

  void saveTeachGroups(var teachers, var groups) {
    super.saveData('teachers', teachers.toString());
    super.saveData('groups', groups.toString());
  }

  getTeachers() async {
    var teachers = await super.getValue('teachers');
    return json.decode(teachers);
  }

  getGroups() async {
    var groups = await super.getValue('groups');
    //print(groups);
    return json.decode(groups);
  }

  void saveAgenda(List<List> agenda) {
    super.saveData('agenda', agenda.toString());
  }

  getAgenda() async {
    saveReloadLog(this.reloadLogTime+1);
    var agenda = await super.getValue('agenda');
    return json.decode(agenda);
  }

  void saveReloadLog(int reloadLogTime) {
    super.saveData('reloadLog', reloadLogTime);
  }

  getReloadLog() async {
    bool reloadLog;
    this.reloadLogTime = await super.getValue('reloadLog');
    if(this.reloadLogTime == null) {
      this.reloadLogTime = 0;
      saveReloadLog(this.reloadLogTime);
      reloadLog = true;
    } else {
      if(this.reloadLogTime >= 7) {
        this.reloadLogTime = 0;
        saveReloadLog(this.reloadLogTime);
        reloadLog = true;
      } else {
        reloadLog = false;
      }
    }
    //print(reloadLog);
    return reloadLog;
  }

}