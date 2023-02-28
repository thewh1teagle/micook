import 'dart:io';
import 'package:convert/convert.dart';
import 'package:micook/profile/menu_settings.dart';
import 'package:micook/profile/profile.dart';
import 'package:micook/profile/stage.dart';
import 'package:micook/status/stage_mode.dart';
import 'package:micook/status/status.dart';
import 'package:miio/miio.dart';

class MiCooker {
  MiIODevice? dev;
  String token;
  String address;
  bool connected = false;
  MiCooker(this.address, this.token);

  Future<void> connect() async {
    var binaryToken = hex.decode(token);
    final hello = await MiIO.instance.hello(InternetAddress(address));
    dev = MiIODevice(
        address: InternetAddress(address),
        token: binaryToken,
        id: hello.deviceId);
    connected = true;
  }

  Future<String> get model async {
    return (await dev!.info)["model"];
  }

  Future<Map<String, dynamic>> get info async {
    return await dev!.info;
  }

  Future<void> startProfile(Profile profile) async {
    String method = profile.settings.confirmStart ? "set_menu1" : "set_start";
    await dev?.call(method, [profile.toHex()]);
  }

  Future<void> startTemp(int minutes, int temp,
      {bool confirmStart = true}) async {
    Profile profile = Profile(
      stages: [
        Stage(
            mode: StageMode.TemperatureMode, minutes: minutes, tempTarget: temp)
      ],
      deviceModel: await model,
      settings: MenuSettings(confirmStart: confirmStart),
      name: "$temp Degrees",
    );
    await startProfile(profile);
  }

  Future<void> stop() async {
    await dev?.call("set_func", ["end"]);
  }

  Future<MiCookerStatus?> getStatus() async {
    List<dynamic>? data = await dev?.call("get_prop", ["all"]);
    return data != null ? MiCookerStatus(data) : null;
  }
}
