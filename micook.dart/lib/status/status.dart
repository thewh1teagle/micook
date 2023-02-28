import 'package:micook/status/operation_mode.dart';

class MiCookerStatus {
  late Map<String, dynamic> _data;
  MiCookerStatus(List<dynamic> data) {
    List<String> properties = _getProperties(data);
    _data = Map.fromIterables(properties, data);
    for (var p in properties) {
      if (!_data.containsKey(p)) {
        _data[p] = null;
      }
    }
    print(_data);
  }

  List<String> _getProperties(List<dynamic> data) {
    List<String> propsOld = [
      "func",
      "menu",
      "action",
      "t_func",
      "version",
      "profiles",
      "play",
    ];
    List<String> propsNew = [
      "func",
      "menu",
      "action",
      "t_func",
      "version",
      "profiles",
      "set_wifi_led",
      "play",
    ];

    if (data.length != propsNew.length && data.length != propsOld.length) {
      throw Exception(
          "Receive values count ${data.length} does not match requested count");
    } else if (data.length == propsNew.length) {
      return propsNew;
    } else {
      return propsOld;
    }
  }

  int? get temperature {
    String action = _data["action"];
    if (action.length >= 6) {
      return int.parse(action.substring(2, 4), radix: 16);
    }
    return null;
  }

  Duration? get remainingTime {
    String tFunc = _data["t_func"];
    print(tFunc);
    String hoursHex = tFunc.substring(0, 2); // 0,1
    String minutesHex = tFunc.substring(2, 4); // 2,3
    int hours = int.parse(hoursHex, radix: 16);
    int minutes = int.parse(minutesHex, radix: 16);
    return Duration(hours: hours, minutes: minutes);
  }

  OperationMode get mode {
    var rawMode = _data["func"];
    return OperationModeExtension.fromString(rawMode);
  }
}
