import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:micook/constants.dart';
import 'package:micook/utils.dart' as utils;
import '../status/stage_mode.dart';
import 'menu_settings.dart';
import 'stage.dart';

const int recipeNameMaxLenV1 = 13,
    recipeNameMaxLenV2 = 28,
    defaultFireOnOff = 20,
    defaultThresholdCelcius = 249,
    defaultTempTargetCelcius = 40,
    defaultFireLevel = 45,
    defaultPhaseMinutes = 50;

class Profile {
  List<int> buf = [];
  MenuSettings settings;
  String name;
  late int minutes;
  String deviceModel;
  List<Stage> stages;
  bool? isV1;

  Profile({
    required this.stages,
    required this.deviceModel,
    required this.settings,
    required this.name,
  }) {
    if (deviceIds.containsKey(deviceModel) == false) {
      throw Exception("Unknown device model $deviceModel");
    }

    isV1 = modelVersion1.contains(deviceModel)
        ? true
        : modelVersion2.contains(deviceModel)
            ? false
            : null;
    if (isV1 == null) {
      throw Exception("Unknown device version $deviceModel");
    }

    int deviceId = deviceIds[deviceModel]!;
    buf.add(3); // unknown 1
    buf.add(deviceId);
    buf.add(9); // menu location
    var byteName = createName(name);
    buf.addAll(byteName); // recipe name
    buf.addAll(padding(isV1! ? 1 : 2));
    buf.addAll(createRecipeId());
    buf.add(settings.toInt()); // setting

    minutes = stages.fold(
      0,
      (sum, stage) => sum + stage.minutes,
    ); // whole durations is sum of minutes in all stages

    buf.addAll(createDurations(minutes));
    buf.addAll(padding(2)); // byte 44, 45
    buf.add(1); // unknown_46, should be set to 1
    buf.addAll(padding(isV1! ? 7 : 1)); //
    for (var s in stages) {
      buf.addAll(s.toUint8List());
    }
    for (int i = 0; i < 15 - stages.length; i++) {
      buf.addAll(Stage().toUint8List());
    }

    buf.addAll(padding(isV1! ? 16 : 6));
    buf.addAll([0, 0, 0]); // unknown175, unknown176, unknown177
    Uint8List crc = createCRC(buf);
    buf.addAll(crc);
  }

  static Uint8List createRecipeId() {
    // int id = Random().nextInt(pow(2, 32).toInt());
    int id = 123123;
    ByteData u32id = ByteData(4);
    u32id.setUint32(0, id, Endian.big);
    return u32id.buffer.asUint8List();
  }

  static List<int> padding(int byteSize) {
    return List.filled(byteSize, 0);
  }

  static Uint8List createDurations(int minutes,
      {int durMaxH = 0, int durMaxM = 0, int durMinH = 0, int durMinM = 0}) {
    if (minutes > 60 * 3) {
      throw Exception("Max Cooking duration is 3 hours");
    }
    int durH = minutes ~/ 60;
    int durM = minutes % 60;

    return Uint8List.fromList([durH, durM, durMaxH, durMaxM, durMinH, durMinM]);
  }

  Uint8List createName(String value) {
    // value = gbk.gbk.encode(value);
    value = value.replaceAll(" ", "\n");
    ByteData nameBytes =
        ByteData(isV1! ? recipeNameMaxLenV1 : recipeNameMaxLenV2);

    int offset = 0;
    for (int i = offset; i < value.length; i++) {
      int code = value.codeUnitAt(i);
      nameBytes.setUint8(i, code);
    }
    return nameBytes.buffer.asUint8List();
  }

  static Uint8List createCRC(List<int> buf) {
    int crc = utils.crc16(buf);
    ByteData crcBytes = ByteData(2);
    crcBytes.setInt16(0, crc, Endian.big);
    return crcBytes.buffer.asUint8List();
  }

  toHex() {
    return hex.encode(buf);
  }
}
