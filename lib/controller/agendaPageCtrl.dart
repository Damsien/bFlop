import 'package:flutter/material.dart';
import 'package:bflop/model/data/agendaData.dart';
import 'dart:convert';
import 'package:jsonml/html2jsonml.dart';

import './masterCtrl.dart';
import 'package:bflop/model/agendaPageModel.dart';

class AgendaPageCtrl extends MasterCtrl {

  //ATTRIBUTES
   
    //Model
  AgendaPageModel agendaPageMod = new AgendaPageModel();
    //Data
  AgendaData agData = new AgendaData.single();
    //Logs
  bool reloadLog;
    //Get process
  bool inUse = false;


  //CONSTRUCTOR
  AgendaPageCtrl() {

  }


  //METHODS / FUNCTIONS

  //GET DATA

  getAll(bool isRunTime, String url) async {
    if(!this.inUse) {
      this.inUse = true;
      bool log = await this.agendaPageMod.getReloadLog();
      var agenda;
      var teachersGroups;
      if(isRunTime) {
        agenda = await getAgenda(log, url);
        teachersGroups = await getTeachGroups(log);
      } else {
        agenda = await getAgenda(true, url);
        teachersGroups = await getTeachGroups(true);
      }
      this.inUse = false;
      return [agenda, teachersGroups[0], teachersGroups[1]];
    } else {
      return null;
    }
  }

  getAgenda(bool log, String url) async {
    if(log) {
      var unAgenda = await fetchAgenda(url);
      cleanAgendaData(unAgenda);
      return this.agData.agList;
    } else {
      var agenda = await this.agendaPageMod.getAgenda();
      return agenda;
    }
  }

  getTeachGroups(bool log) async {
    if(log) {
      fetchGroupTeach();
    } else {
      this.agData.groupList = await this.agendaPageMod.getGroups();
      this.agData.teachList = await this.agendaPageMod.getTeachers();
    }
    return [this.agData.groupList, this.agData.teachList];
  }

  //AGENDA DATA REORGANIZATION

  cleanAgendaData(var json) {

    int firstWeek = getFirstWeek(getMonday(new DateTime.now()));
    DateTime timeSplit;
    List<int> hourCourses = [08, 09, 11, 14, 15, 17];

        
    for(int j=1; j<json.length; j++) {
      if(json[j-1][0] == "SUMMARY") {

        timeSplit = new DateTime(
          int.parse(json[j][1].split("")[0].toString()+json[j][1].split("")[1].toString()
          +json[j][1].split("")[2].toString()+json[j][1].split("")[3].toString()),
          int.parse(json[j][1].split("")[4].toString()+json[j][1].split("")[5].toString()),
          int.parse(json[j][1].split("")[6].toString()+json[j][1].split("")[7].toString()),
          int.parse(json[j][1].split("")[9].toString()+json[j][1].split("")[10].toString()),
          int.parse(json[j][1].split("")[11].toString()+json[j][1].split("")[12].toString()),
        );

        if(getFirstWeek(getMonday(timeSplit)) == firstWeek-1) {
          this.agData.agList[0][timeSplit.weekday-1][hourCourses.indexOf(timeSplit.hour)] = '"'+json[j+5][1]+'"';
        }
        
        else if(getFirstWeek(getMonday(timeSplit)) == firstWeek+1) {
          this.agData.agList[1][timeSplit.weekday-1][hourCourses.indexOf(timeSplit.hour)] = '"'+json[j+5][1]+'"';
        }
        
        else if(getFirstWeek(getMonday(timeSplit)) == firstWeek+2) {
          this.agData.agList[2][timeSplit.weekday-1][hourCourses.indexOf(timeSplit.hour)] = '"'+json[j+5][1]+'"';
        }
      
        else if(getFirstWeek(getMonday(timeSplit)) == firstWeek+3) {
          this.agData.agList[3][timeSplit.weekday-1][hourCourses.indexOf(timeSplit.hour)] = '"'+json[j+5][1]+'"';
        }

      }
    }
    this.agendaPageMod.saveAgenda(this.agData.agList);
    
  }

  getMonday(DateTime date) {
    var monday;
    int nbDatMonday;

    //If we are in week
    if(date.weekday < 6)
      nbDatMonday = date.day - date.weekday+1;
    //If we are in weekend
    else
      nbDatMonday = date.day - date.weekday+8;

    //If the monday is in the past month
    if(nbDatMonday < 1) {
      int year = date.year;
      int day;

      if(date.month-1 == 1 || date.month-1 == 3 || date.month-1 == 5 || date.month-1 == 7 || date.month-1 == 8 || date.month-1 == 10 || date.month-1 == 12) {
        day = 31+nbDatMonday;
        if(date.month == 1) year = date.year-1;
      } else {
        if(date.month-1 == 2) {
          if(date.year %(4) == 0 || date.year % (400) == 0) day = 29+nbDatMonday;
          else day = 28+nbDatMonday;
        } else
          day = 30+nbDatMonday;
      }

      monday = new DateTime(year, date.month-1, day);
    } else {
      monday = new DateTime(date.year, date.month, nbDatMonday);
    }
    return monday;
  }

  getFirstWeek(DateTime date) {
    var first = new DateTime(date.year, 1, 1);
    Duration diff = date.difference(first);
    int week;
    if(date.weekday == 5)
      week = (diff.inDays/7).toInt()+1;
    else
      week = (diff.inDays/7).toInt()+2;
    return week;
  }

  getNextDay(DateTime date) {
    var today = date.day;
    var nextDay = date.day+1;
    var nextMonth = date.month;
    var nextYear = date.year;

    if(date.month == 1 || date.month == 3 || date.month == 5 || date.month == 7 || date.month == 8 || date.month == 10 || date.month == 12) {
      if(today == 31) {
        nextDay = 1;
        if(date.month == 12) {
          nextMonth = 1;
          nextYear = date.year+1;
        } else
          nextMonth = date.month+1;
      }
    } else {
      if(date.year %(4) == 0 || date.year % (400) == 0) {
        if(date.month == 2) {
          if(today == 29) {
            nextDay = 1;
            nextMonth = date.month+1;
          }
        }
      } else if(date.day == 28) {
        if(date.month == 2) {
          nextDay = 1;
          nextMonth = date.month+1;
        }
      } else if(date.day == 30) {
        nextDay = 1;
        nextMonth = date.month+1;
      }
    }
    return DateTime(nextYear, nextMonth, nextDay);
  }

  getSomeDays(DateTime date, int moreDays) {
    var today = date.day;
    var nextDay = date.day+moreDays;
    var nextMonth = date.month;
    var nextYear = date.year;

    if(date.month == 1 || date.month == 3 || date.month == 5 || date.month == 7 || date.month == 8 || date.month == 10 || date.month == 12) {
      if(today+moreDays > 31) {
        nextDay = 0-(31-today-moreDays);
        if(date.month == 12) {
          nextMonth = 1;
          nextYear = date.year+1;
        } else
          nextMonth = date.month+1;
      }
    } else {
      if(date.year %(4) == 0 || date.year % (400) == 0) {
        if(date.month == 2) {
          if(today+moreDays > 29) {
            nextDay = 0-(29-today-moreDays);
            nextMonth = date.month+1;
          }
        }
      } else if(today+moreDays > 28) {
        if(date.month == 2) {
          nextDay = 0-(28-today-moreDays);
          nextMonth = date.month+1;
        }
      } else if(today+moreDays > 30) {
        nextDay = 0-(30-today-moreDays);
        nextMonth = date.month+1;
      }
    }
    return DateTime(nextYear, nextMonth, nextDay);
  }

  //FETCH DATA

  //Retrive calendar data in json
  fetchAgenda(String url) async {
    
    var doc = await this.agendaPageMod.fetchAgenda('https://flopedt.iut-blagnac.fr' + url);
    var docS = json.encode(utf8.decode(doc.bodyBytes));

    var finalJson = icalToJson(docS);
    return finalJson;

  }

  //Parse ical to json format
  icalToJson(String string) {

    List<List> finalJson = List<List>();

    List<String> cal = string.split("\\r\\n").toList();
    bool isEvent = false;

    for(int i=0; i<cal.length; i++) {
      if(cal[i] == "BEGIN:VEVENT") isEvent = true;
      if(isEvent) {
        if(cal[i].split(":")[0] == "DESCRIPTION") {
          finalJson.add([''+cal[i].split(":")[0]+'', ''+(cal[i].split(":")[1] + ":" + cal[i].split(":")[2] + ":" + cal[i].split(":")[3] +
          ":" + cal[i].split(":")[4] + ":" + cal[i+1])+'']);
        i++;
        } else
          finalJson.add([''+cal[i].split(":")[0]+'', ''+cal[i].split(":")[1]+'']);
      }
      if(cal[i] == "END:VEVENT") isEvent = false;
    }
    
    return finalJson;
  }


  //Retrieve groups and teachers
  void fetchGroupTeach() async {
    await fetchTeachers();
    await fetchGroups();
    this.agendaPageMod.saveTeachGroups(this.agData.teachList, this.agData.groupList);
  }

  //Parse html to json format
  htmlToJson(var html) {
    List<String> comment = html.split("\\n");
    String noComment = "";
    for(int i=0; i<comment.length; i++) {
      if(!comment[i].contains("<!-")) {
        List<String> slash = comment[i].split("\\");
        for(int j=0; j<slash.length; j++) {
          noComment = noComment + slash[j];
        }
      }
    }
    var jsonml = encodeToJsonML(noComment);
    return jsonml;
  }

  //Fetch groups
  fetchGroups() async {
    List<String> urls = ['https://flopedt.iut-blagnac.fr/ics/INFO/', 'https://flopedt.iut-blagnac.fr/ics/RT/',
    'https://flopedt.iut-blagnac.fr/ics/GIM/', 'https://flopedt.iut-blagnac.fr/ics/CS/'];
    this.agData.groupList.clear();
    for(int i=0; i<urls.length; i++) {
      var doc = await this.agendaPageMod.fetchGroupTeach(urls[i]);
      var docS = json.encode(utf8.decode(doc.bodyBytes));
      listGroup(htmlToJson(docS));
    }
    return this.agData.groupList;
  }

  //List of groups
  void listGroup(var json) {
    //indexPromo => 0 : info, 1 : rt, 2 : gim, 3 : cs
    List<List> promo = new List<List>();
    var groupJson = json[23][4][9][2][2];

    for(int i=2; i<groupJson.length; i+=2) {
      promo.add(['"'+groupJson[i][2][1].toString()+'"', '"'+groupJson[i][4][1].toString()+'"', '"'+groupJson[i][6][1][1].values.toList()[0].toString()+'"']);
    }

    this.agData.groupList.add(promo);
  }

  //Fetch teachers
  fetchTeachers() async {
    var doc = await this.agendaPageMod.fetchGroupTeach('https://flopedt.iut-blagnac.fr/ics/INFO/');
    var docS = json.encode(utf8.decode(doc.bodyBytes));
    listTeachers(htmlToJson(docS));
    return this.agData.teachList;
  }

  //List of teachers
  void listTeachers(var json) {
    List<List> teachInfo = new List<List>();
    List<List> teachRT = new List<List>();
    List<List> teachGIM = new List<List>();
    List<List> teachCS = new List<List>();

    var teachJson = json[23][4][13][2][2];

    for(int i=2; i<teachJson.length; i++) {
      if(teachJson[i][8].length > 1) {
        for(int j=0; j<teachJson[i][8][1].split(", ").length; j++) {
          if(teachJson[i][8][1].split(", ")[j] == "INFO")
            teachInfo.add(['"'+teachJson[i][2][1]+'"', '"'+teachJson[i][4][1]+'"', '"'+teachJson[i][6][1]+'"', '"'+teachJson[i][10][1][1].values.toList()[0]+'"']);
          if(teachJson[i][8][1].split(", ")[j] == "RT")
            teachRT.add(['"'+teachJson[i][2][1]+'"', '"'+teachJson[i][4][1]+'"', '"'+teachJson[i][6][1]+'"', '"'+teachJson[i][10][1][1].values.toList()[0]+'"']);
          if(teachJson[i][8][1].split(", ")[j] == "GIM")
            teachGIM.add(['"'+teachJson[i][2][1]+'"', '"'+teachJson[i][4][1]+'"', '"'+teachJson[i][6][1]+'"', '"'+teachJson[i][10][1][1].values.toList()[0]+'"']);
          if(teachJson[i][8][1].split(", ")[j] == "CS")
            teachCS.add(['"'+teachJson[i][2][1]+'"', '"'+teachJson[i][4][1]+'"', '"'+teachJson[i][6][1]+'"', '"'+teachJson[i][10][1][1].values.toList()[0]+'"']);
        }
      }
    }

    this.agData.teachList.clear();
    this.agData.teachList.add(teachInfo);
    this.agData.teachList.add(teachRT);
    this.agData.teachList.add(teachGIM);
    this.agData.teachList.add(teachCS);
  }

}