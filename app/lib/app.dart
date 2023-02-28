import 'package:flutter/material.dart';
import 'package:MiCook/screens/add/screen.dart';
import 'package:MiCook/screens/cook/screen.dart';
import 'package:MiCook/screens/loading.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // This widget is the root of your application.

  bool _isLoading = true;

  Future<void> asyncInit() async {
    // await Future.delayed(Duration(seconds: 2));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    asyncInit();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiCook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>
            _isLoading ? const LoadingScreen() : const CookScreen(),
        '/add': (context) => const AddScreen()
      },
    );
  }
}
