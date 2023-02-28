enum StageMode {
  FireMode,
  TemperatureMode,
  Unknown4,
  TempAutoSmallPot,
  Unknown10,
  TempAutoBigPot,
  Unknown16,
}

extension StageModeExtension on StageMode {
  int get value {
    switch (this) {
      case StageMode.FireMode:
        return 0;
      case StageMode.TemperatureMode:
        return 2;
      case StageMode.Unknown4:
        return 4;
      case StageMode.TempAutoSmallPot:
        return 8;
      case StageMode.Unknown10:
        return 10;
      case StageMode.TempAutoBigPot:
        return 24;
      case StageMode.Unknown16:
        return 16;
    }
  }
}
