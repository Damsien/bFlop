import 'package:shared_preferences/shared_preferences.dart';

class MasterModel {

  var returnedValue;

  MasterModel() {
    
  }

  saveData(String key, var value) {
    if(value.runtimeType == String)
      saveString(key, value).then((bool val) => print("saveString : " + value.toString()));
    if(value.runtimeType == List())
      saveStringList(key, value).then((bool val) => print("saveStringList : " + value.toString()));
    if(value.runtimeType == int)
      saveInt(key, value).then((bool val) => print("saveInt : " + value.toString()));
    if(value.runtimeType == double)
      saveDouble(key, value).then((bool val) => print("saveDouble : " + value.toString()));
    if(value.runtimeType == bool)
      saveBool(key, value).then((bool val) => print("saveBool : " + value.toString()));
  }

  update(var value) {
      this.returnedValue = value;
  }


  Future<bool> saveString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    return prefs.commit();
  }

  Future<bool> saveStringList(String key, List<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
    return prefs.commit();
  }

  Future<bool> saveInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
    return prefs.commit();
  }

  Future<bool> saveDouble(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
    return prefs.commit();
  }

  Future<bool> saveBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
    return prefs.commit();
  }

  Future<Object> getValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

}
