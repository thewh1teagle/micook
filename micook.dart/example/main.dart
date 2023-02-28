import 'package:micook/micook.dart';
import 'package:micook/profile/menu_settings.dart';
import 'package:micook/profile/profile.dart';
import 'package:micook/profile/stage.dart';
import 'package:micook/status/stage_mode.dart';

void main() async {
  String address = "<address>";
  String token = "<token>";
  var cooker = MiCooker(address, token);
  await cooker.connect();
  await cooker.startTemp(5, 60);
  // await cooker.stop();
}
