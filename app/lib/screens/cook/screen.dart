import 'package:flutter/material.dart';
import 'package:micook/micook.dart';
import 'cooker_card.dart';

import 'package:MiCook/database.dart';

class CookerWiget extends StatelessWidget {
  MiCooker cooker;
  CookerWiget({super.key, required this.cooker});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(children: [Text(cooker.address)]),
    );
  }
}

class CookScreen extends StatefulWidget {
  const CookScreen({super.key});

  @override
  State<CookScreen> createState() => _CookScreenState();
}

class _CookScreenState extends State<CookScreen> {
  late Database db;
  List<MiCooker> cookers = [];
  bool loading = true;

  Future<void> _onDelete(MiCooker cooker) async {
    await db.removeCooker(cooker.token);
    setState(() {
      cookers = cookers.where((c) => c.token != cooker.token).toList();
    });
  }

  Future<void> asyncInit() async {
    db = await Database.getInstance();
    // await db.clear();
    var cookersEntries = await db.getDevices();

    var newCookers = await Future.wait(cookersEntries.map((e) async {
      var cooker = MiCooker(e.address, e.token);
      try {
        cooker.connect();
        // ignore: empty_catches
      } catch (e) {}

      return cooker;
    }).toList());
    // var newCookersFiltered = newCookers.whereType<MiCooker>().toList();
    setState(() {
      cookers = newCookers;
      loading = false;
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
      body: Column(children: [
        const SizedBox(
          height: 20,
        ),
        const Text(
          "MiCook",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: loading
              ? const CircularProgressIndicator()
              : cookers.isEmpty
                  ? const Text("No devices found")
                  : SizedBox(
                      height: size.height * 0.6,
                      width: size.width > 600
                          ? size.width * 0.4
                          : size.width * 0.95,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: cookers.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CookerCard(
                                cooker: cookers[index], onDelete: _onDelete),
                          );
                        },
                      )),
        )
      ]),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add'), // <-- Text
        icon: const Icon(
          // <-- Icon
          Icons.add,
          size: 24.0,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed('/add');
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
