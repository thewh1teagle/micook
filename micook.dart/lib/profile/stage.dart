import 'dart:typed_data';

import 'package:micook/profile/profile.dart';

import '../status/stage_mode.dart';

class Stage {
  StageMode mode;
  int minutes;
  int tempTarget;
  int tempThresold = defaultThresholdCelcius;
  int power;
  int fireOff = defaultFireOnOff;
  int fireOn = defaultFireOnOff;
  late int hours;
  Stage(
      {this.mode = StageMode.FireMode,
      this.minutes = defaultPhaseMinutes,
      this.tempTarget = defaultTempTargetCelcius,
      this.power = defaultFireLevel}) {
    hours = minutes ~/ 60 + 128; // add 128 to shift it into signed integer
  }

  Uint8List toUint8List() {
    return Uint8List.fromList([
      mode.value,
      hours,
      minutes,
      tempThresold,
      tempTarget,
      power,
      fireOff,
      fireOn
    ]);
  }
}
