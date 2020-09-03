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
  AgendaPageCtrl() {}


  //METHODS / FUNCTIONS

  //GET DATA

  //Get all of teachers, groups and agenda of the selected one
  getAll(bool isRunTime) async {
    if(!this.inUse) {
      this.inUse = true;
      String url;
      bool log = await this.agendaPageMod.getReloadLog();
      var pickers = await getPickersList();
      var agenda;
      var teachersGroups;
      List<String> finalTeachersGroups;
      if(isRunTime) {
        teachersGroups = await getTeachGroups(log);
        await new Future.delayed(const Duration(seconds : 10));
        url = getUrl(pickers, teachersGroups);
        agenda = await getAgenda(log, url);
      } else {
        teachersGroups = await getTeachGroups(true);
        url = getUrl(pickers, teachersGroups);
        agenda = await getAgenda(true, url);
      }
      this.inUse = false;
      if(pickers[1] == "Elève") finalTeachersGroups = getAllPickers(teachersGroups[0], pickers);
      else finalTeachersGroups = getAllPickers(teachersGroups[1], pickers);
      return [agenda, finalTeachersGroups, pickers];
    } else {
      return null;
    }
  }

  //Get the agenda's url of the selected group/teacher
  getUrl(var pickers, var teachersGroups) {
    String url;
    int type;
    if(pickers[1] == "Elève") type = 0;
    else type = 1;
    switch (pickers[0]) {
      case "Info": url =  urlFor(type, 0, teachersGroups, pickers[2]); break;
      case "RT": url = urlFor(type, 1, teachersGroups, pickers[2]); break;
      case "GIM": url = urlFor(type, 2, teachersGroups, pickers[2]); break;
      case "CS": url = urlFor(type, 3, teachersGroups, pickers[2]); break;
    }
    return url;
  }
  //Url loop fetcher
  urlFor(int teachStud, int promo, var teachersGroups, String picker) {
    //print(teachStud.toString() + "   " + picker + "   " + promo.toString() + "   " + teachersGroups.toString());
    if(teachStud == 1) {
      for(int i=0; i<teachersGroups[teachStud][promo].length; i++) {
        if(picker == quoteToString(teachersGroups[teachStud][promo][i][0]))
          return quoteToString(teachersGroups[teachStud][promo][i][3]);
      }
    } else {
      for(int i=0; i<teachersGroups[teachStud][promo].length; i++) {
        if(picker == quoteToString(teachersGroups[teachStud][promo][i][0]) + "-" + 
        quoteToString(teachersGroups[teachStud][promo][i][1])) {
          return quoteToString(teachersGroups[teachStud][promo][i][2]);
        }
      }
    }
  }

  //Get agenda
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

  //Get teacher and group list
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

  //Clear agenda and fetch all of courses
  cleanAgendaData(var json) {

    for(int i=0; i<4; i++) {
      for(int k=0; k<5; k++) {
        for(int l=0; l<6; l++) {
          this.agData.agList[i][k][l] = '"'+'~'+'"';
        }
      }
    }

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
        //getNote(timeSplit)

        if(getFirstWeek(getMonday(timeSplit)) == firstWeek) {
          if(timeSplit.weekday-1 != 6 || timeSplit.weekday-1 != 7){
            //print(colorUpdate(json[j+5][1]).toString());
            this.agData.agList[0][timeSplit.weekday-1][hourCourses.indexOf(timeSplit.hour)] = '"'+json[j+5][1]+'\\\\n'
            +colorUpdate(json[j+5][1]).toString()+'\\\\n'+timeSplit.year.toString()+" "+timeSplit.month.toString()
            +" "+timeSplit.day.toString()+" "+timeSplit.hour.toString()+" "+timeSplit.minute.toString()+'"';
        }}
        
        else if(getFirstWeek(getMonday(timeSplit)) == firstWeek+1) {
          if(timeSplit.weekday-1 != 6 || timeSplit.weekday-1 != 7)
            this.agData.agList[1][timeSplit.weekday-1][hourCourses.indexOf(timeSplit.hour)] = '"'+json[j+5][1]+'\\\\n'
            +colorUpdate(json[j+5][1]).toString()+'\\\\n'+timeSplit.year.toString()+" "+timeSplit.month.toString()
            +" "+timeSplit.day.toString()+" "+timeSplit.hour.toString()+" "+timeSplit.minute.toString()+'"';
        }
        
        else if(getFirstWeek(getMonday(timeSplit)) == firstWeek+2) {
          if(timeSplit.weekday-1 != 6 || timeSplit.weekday-1 != 7)
            this.agData.agList[2][timeSplit.weekday-1][hourCourses.indexOf(timeSplit.hour)] = '"'+json[j+5][1]+'\\\\n'
            +colorUpdate(json[j+5][1]).toString()+'\\\\n'+timeSplit.year.toString()+" "+timeSplit.month.toString()
            +" "+timeSplit.day.toString()+" "+timeSplit.hour.toString()+" "+timeSplit.minute.toString()+'"';
        }
      
        else if(getFirstWeek(getMonday(timeSplit)) == firstWeek+3) {
          if(timeSplit.weekday-1 != 6 || timeSplit.weekday-1 != 7)
            this.agData.agList[3][timeSplit.weekday-1][hourCourses.indexOf(timeSplit.hour)] = '"'+json[j+5][1]+'\\\\n'
            +colorUpdate(json[j+5][1]).toString()+'\\\\n'+timeSplit.year.toString()+" "+timeSplit.month.toString()
            +" "+timeSplit.day.toString()+" "+timeSplit.hour.toString()+" "+timeSplit.minute.toString()+'"';
        }

      }
    }
    this.agendaPageMod.saveAgenda(this.agData.agList);
    
  }

  //Fetch colors of courses
  String colorUpdate(String cours) {
    String name = cours.split(" ")[2];
    String color = ("bg " + "#ff0000" + " fg " + "#FFFFFF");
    this.agData.colors.forEach((key, value) {
      if(name == key) {
        color = ("bg " + value[0] + " fg " + value [1]);
      }
    });
    return color;
  }

  //Set a note on a course
  void setNote(DateTime cours, String note) {
    String realCours = '"'+cours.toIso8601String()+'"';
    this.agData.notes[realCours] = '"'+note+'"';
    this.agendaPageMod.saveData("notes", '"'+this.agData.notes.toString()+'"');
  }

  //Get the note of a course
  getNote(DateTime currentTime) async {
    String saveNotes = await this.agendaPageMod.getValue("notes");
    if(saveNotes == null) return "";

    String realNote = "";
    for(int i=1; i<saveNotes.split("").length-1; i++) {
      realNote = realNote + saveNotes.split("")[i];
    }
    Map notes = json.decode(realNote);
    String note = "";
    notes.forEach((key, value) {
      if(currentTime.toIso8601String() == key.toString()) {
        note = value;
      }
    });
    return note;
  }  

  //PICKERS

  //Get all of teachers and groups list adapted to the view (String List)
  getAllPickers(var pickers, var pickerSelect) {
    List<String> finalPickers = new List<String>();
    int promo;
    switch (pickerSelect[0]) {
      case "Info": promo = 0; break;
      case "RT": promo = 1; break;
      case "GIM": promo = 2; break;
      case "CS": promo = 3; break;
    }
    if(pickerSelect[1] == "Elève") {
      for(int i=0; i<pickers[promo].length; i++) {
        finalPickers.add(quoteToString(pickers[promo][i][0]) + "-" + quoteToString(pickers[promo][i][1]));
      }
    } else {
      for(int i=0; i<pickers[promo].length; i++) {
        finalPickers.add(quoteToString(pickers[promo][i][0]));
      }
    }
    return finalPickers;
  }

  //Get internal saved pickers selectionned (already stored)
  getPickersList() async {
    var pPromo = await this.agendaPageMod.getValue("pickPromo");
    var pTeaStu = await this.agendaPageMod.getValue("pickTeachStud");
    var pGroup = await this.agendaPageMod.getValue("pickGroup");
    if (pPromo != null)
      this.agData.pickPromo = pPromo;
    if (pTeaStu != null)
      this.agData.pickTeachStudent = pTeaStu;
    if (pGroup != null)
      this.agData.pickGroup = pGroup;
    return [this.agData.pickPromo, this.agData.pickTeachStudent, this.agData.pickGroup];
  }

  //Set pickers who are selectionned in internal storage
  void savePickers(String pickPromo, String pickTeachStud, String group) {
    if(pickPromo != null)
      this.agendaPageMod.saveData("pickPromo", pickPromo);
    if(pickTeachStud != null)
      this.agendaPageMod.saveData("pickTeachStud", pickTeachStud);
    if(group != null)
      this.agendaPageMod.saveData("pickGroup", group);
    getPickersList();
  }

  //Get internal saved pickers selectionned (not yet stored)
  getPickersSelect() async {
    List<String> pickers = new List<String>();
    //0 : promo, 1 : teach or student, 2 : teach or group
    var pPromo = await this.agendaPageMod.getValue("pickPromo");
    var pTeaStu = await this.agendaPageMod.getValue("pickTeachStud");
    var pGroup = await this.agendaPageMod.getValue("pickGroup");
    if(pPromo == null) this.agendaPageMod.saveData("pickPromo", "Info");
    if(pTeaStu == null) this.agendaPageMod.saveData("pickTeachStud", "Elève");
    if(pGroup == null) this.agendaPageMod.saveData("pickGroup", "INFO1-1A");
    pickers.add(await this.agendaPageMod.getValue("pickPromo"));
    pickers.add(await this.agendaPageMod.getValue("pickTeachStud"));
    pickers.add(await this.agendaPageMod.getValue("pickGroup"));
    return pickers;
  }

  //When picker selection changed (in view), get teacher/group list
  switchChanged() async {
    var pickers = await getPickersList();
    var teachersGroups = await getTeachGroups(false);
    if(pickers[1] == "Elève") {
      this.agData.pickGroup = getAllPickers(teachersGroups[0], pickers)[0];
      return getAllPickers(teachersGroups[0], pickers);
    } else {
      this.agData.pickGroup = getAllPickers(teachersGroups[1], pickers)[0];
      return getAllPickers(teachersGroups[1], pickers);
    }
  }

  //DATETIME FUNCTIONS

  //Get the number of the month of monday's week
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

  //Get the number of week of the year
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

  //Get the number of the next day of the month
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

  //Get the number of a day of a month
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

  //Get the current day or the monday of the next week of weekend
  initDay(DateTime now) {
    if (now.weekday < 6)
      return now;
    else {
      if (now.weekday == 6) return getSomeDays(now, 2);
      if (now.weekday == 7) return getSomeDays(now, 1);
    }
  }
  
  getNameFirstName(String initiales) {
    String finalStr = "";
    int promo;
    switch(this.agData.pickPromo) {
      case "Info" : promo = 0; break;
      case "RT" : promo = 1; break;
      case "GIM" : promo = 2; break;
      case "CS" : promo = 3; break;
    }
    for(int i=0; i<this.agData.teachList[promo].length; i++) {
      if(quoteToString(this.agData.teachList[promo][i][0]) == initiales) {
        finalStr = quoteToString(this.agData.teachList[promo][i][2]) + " " + quoteToString(this.agData.teachList[promo][i][1]);
      }
    }
    return finalStr;
  }

  //List's object converter
  List<String> dynamicToGroup(List<dynamic> list, int promo) {
    List<String> finalList = new List<String>();
    for(int i=0; i<list[promo].length; i++)
      finalList.add(list[promo][i][0].split("\"")[1] + "-" + list[promo][i][1].split("\"")[1]);
    return finalList;
  }
  List<String> dynamicToTeachers(List<dynamic> list, int promo) {
    List<String> finalList = new List<String>();
    for(int i=0; i<list[promo].length; i++)
      finalList.add(list[promo][i][1].split("\"")[1] + " " + list[promo][i][2].split("\"")[1]);
    return finalList;
  }
  List<List<List<String>>> dynamicToAgenda(List<dynamic> list) {
    var month = [[new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6)],
        [new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6)],
        [new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6)],
        [new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6), new List<String>(6)]];
    List<List<List<String>>> finalList = month;
    
    for(int i=0; i<list.length; i++) {
      for(int j=0; j<list[i].length; j++) {
        for(int k=0; k<list[i][j].length; k++) {
          finalList[i][j][k] = list[i][j][k];
        }
      }
    }
    return finalList;
  }
  String listToString(List<List<List<String>>> list, int week, int day, int course) {
    String finalString;
    if(list.toString() == "[]") {
      finalString = "";
    } else {
      finalString = list[week][day][course];
    }
    if(finalString == null) finalString = "";
    else finalString = sameString(finalString);
    return finalString;
  }
  String sameString(String str) {
    String newstr = "";
    if(str.split("").length != 0) {
      if(str.split("")[0] == '"') {
        if(str.split("")[1] != '~') {
          newstr = str.split("\\")[0].split('"')[1] +"\\"+ str.split("\\")[1] + str.split("\\")[2] +"\\"+
          str.split("\\")[3] +"\\"+ str.split("\\")[4] +"\\"+ str.split("\\")[5] + str.split("\\")[6]
          + str.split("\\")[7] +"\\"+ str.split("\\")[8] + str.split("\\")[9] +"\\"+ str.split("\\")[10].split('"')[0];
        }
      } else {
        if(str.split("")[0] != '~')
          newstr = str;
      }
    }
    return newstr;
  }
  //Remove first and last quote of a string
  String quoteToString(String str) {
    if(str.split("\"")[0] == "")
      return str.split("\"")[1];
    else
      return str;
  }

  //FETCH DATA

  //Retrive calendar data in json
  fetchAgenda(String fUrl) async {
    
    String url = quoteToString(fUrl);
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
    List<List<String>> promo = new List<List<String>>();
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
    List<List<String>> teachInfo = new List<List<String>>();
    List<List<String>> teachRT = new List<List<String>>();
    List<List<String>> teachGIM = new List<List<String>>();
    List<List<String>> teachCS = new List<List<String>>();

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

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static String stringToHex(String colorString) {
    String realString = colorString.split("(")[1];
    String finalString = "#" + realString.split("xff")[1].split(")")[0];
    return finalString;
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}