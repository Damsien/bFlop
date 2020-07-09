import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:bflop/model/masterModel.dart';
import 'package:http/io_client.dart';

class AgendaPageModel extends MasterModel {

  int reloadLogTime;

  AgendaPageModel() {

  }

  //Fetch calendar data
  Future<http.Response> fetchAgenda(String url) async {
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);
  
    //final response = await http.post('$url', // Previous Code
  
    final response = await ioClient.get(url,
        headers: {
          HttpHeaders.contentTypeHeader: 'text/calendar',
          //HttpHeaders.authorizationHeader: '',
          
        }
        );
    return response;
    /*
    return http.get(url,
        headers: {'Content-Type': 'text/calendar'}
    );*/
  }

  //Fetch student/teachers data
  Future<http.Response> fetchGroupTeach(String url) async {
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);
  
    //final response = await http.post('$url', // Previous Code
  
    final response = await ioClient.get(url,
        headers: {
          HttpHeaders.contentTypeHeader: 'text/html',
          //HttpHeaders.authorizationHeader: '',
          
        }
        );
    return response;
    /*return http.get(url,
        headers: {'Content-Type': 'text/html'}
    );*/
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

//Remove first and last quote of a string
String quoteToString(String str) {
  String newStr;
  if(str.split("\"")[0] == "") {
    for(int i=0; i<str.split("").length; i++) {
      if(str.split("")[i] != '"')
        newStr = newStr + str.split("")[i];
    }
    return str.split("\"")[1];
  }
  else
    return str;
}