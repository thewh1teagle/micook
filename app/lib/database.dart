import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CookerEntry {
  String token;
  String address;
  CookerEntry(this.address, this.token);

  Map<String, String> toMap() {
    return {"address": address, "token": token};
  }

  toJson() {
    return json.encode(toMap());
  }

  static CookerEntry fromMap(dynamic deviceMap) {
    return CookerEntry(deviceMap["address"]!, deviceMap["token"]!);
  }
}

class Database {
  SharedPreferences fs;
  Database(this.fs);

  static Future<Database> getInstance() async {
    var fs = await SharedPreferences.getInstance();
    return Database(fs);
  }

  Future<void> clear() async {
    await fs.clear();
  }

  Future<void> _writeDevices(List<CookerEntry> devices) async {
    var devicesMap = devices.map((e) => e.toMap()).toList();
    String devicesJson = json.encode(devicesMap);
    fs.setString("cookers", devicesJson);
  }

  Future<List<CookerEntry>> getDevices() async {
    String? value = fs.getString("cookers");
    if (value == null) {
      return [];
    }
    List<dynamic> devicesMap = json.decode(value);
    List<CookerEntry> devices = [];
    for (var devMap in devicesMap) {
      devices.add(CookerEntry.fromMap(devMap));
    }
    return devices;
  }

  Future<void> addCooker(String address, String token) async {
    var devices = await getDevices();
    var dev = CookerEntry(address, token);
    devices.add(dev);
    _writeDevices(devices);
  }

  Future<void> removeCooker(String token) async {
    var devices = await getDevices();
    devices = devices.where((d) => d.token != token).toList();
    _writeDevices(devices);
  }
}
