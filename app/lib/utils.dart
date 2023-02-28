import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(String url) async {
  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}

String formatDurationInHhMm(Duration duration) {
  final HH = (duration.inHours).toString().padLeft(2, '0');
  final mm = (duration.inMinutes % 60).toString().padLeft(2, '0');

  return '$HH:$mm';
}
