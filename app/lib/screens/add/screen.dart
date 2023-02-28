// ignore_for_file: implementation_imports, unnecessary_import, unused_import

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:MiCook/utils.dart';

import 'package:MiCook/database.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController addressController = TextEditingController();
  TextEditingController tokenController = TextEditingController();
  late Database db;

  Future<void> asyncInit() async {
    var dbInstance = await Database.getInstance();
    setState(() {
      db = dbInstance;
    });
  }

  @override
  void initState() {
    super.initState();
    asyncInit();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Center(
            child: SizedBox(
              width: size.width > 600 ? size.width * 0.23 : size.width * 0.75,
              child: Column(children: [
                const Text(
                  "Add device",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      await openUrl("https://github.com/thewh1teagle/findmi");
                    },
                    child: const Text(
                      "Use findmi to get devices tokens",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: addressController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address',
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: tokenController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Token',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FloatingActionButton.extended(
                  label: const Text('Add'), // <-- Text
                  icon: const Icon(
                    // <-- Icon
                    Icons.add,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    String address = addressController.text;
                    String token = tokenController.text;
                    await db.addCooker(address, token);
                    if (context.mounted) {
                      Navigator.of(context).pushReplacementNamed("/");
                    }
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
