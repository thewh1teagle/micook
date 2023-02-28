// ignore_for_file: implementation_imports

import 'dart:async';

import 'package:MiCook/utils.dart';
import 'package:duration/duration.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:micook/micook.dart';
import 'package:micook/status/operation_mode.dart';
import 'package:numberpicker/numberpicker.dart';

typedef OnDeleteCallback = void Function(MiCooker cooker);

class CookerCard extends StatefulWidget {
  MiCooker cooker;
  OnDeleteCallback onDelete;

  CookerCard({super.key, required this.cooker, required this.onDelete});

  @override
  State<CookerCard> createState() => _CookerCardState();
}

class _CookerCardState extends State<CookerCard> {
  Duration _duration = const Duration(hours: 0, minutes: 50);
  int _temp = 80;
  bool running = false;
  int? currentTemp;
  Duration? remainingTime;
  bool connected = false;

  void _updateStatus() async {
    var status = await widget.cooker.getStatus();
    setState(() {
      running = status?.mode == OperationMode.running;
      currentTemp = status?.temperature;
      remainingTime = status?.remainingTime;
    });
  }

  void _updateStatusInterval() {
    _updateStatus();
    Timer.periodic(const Duration(seconds: 4), (timer) {
      _updateStatus();
    });
  }

  String formatDuration(Duration d) {
    int hours = d.inHours;
    if (hours > 0) {
      return "${d.inHours}h ${d.inMinutes.remainder(60)}m";
    }
    return "${d.inMinutes}m";
  }

  Future<void> tryConnect() async {
    try {
      await widget.cooker.connect();
      setState(() {
        connected = true;
        _updateStatus();
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> _tryConnectInterval() async {
    tryConnect();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      tryConnect();
    });
  }

  @override
  void initState() {
    super.initState();
    connected = widget.cooker.connected;
    if (!connected) {
      _tryConnectInterval();
    } else {
      _updateStatusInterval();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!connected) {
      return Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [BoxShadow(blurRadius: 4, spreadRadius: 1)]),
          child: Row(
            children: [
              Text("${widget.cooker.address} not available"),
              const Spacer(),
              PopupMenuButton(
                constraints: const BoxConstraints.expand(width: 80, height: 60),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: const Text("Delete"),
                      onTap: () {
                        widget.onDelete(widget.cooker);
                      },
                    ),
                  ];
                },
              )
            ],
          ));
    }
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [BoxShadow(blurRadius: 4, spreadRadius: 1)]),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.cooker.address,
                            style: const TextStyle(fontWeight: FontWeight.w200),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: 35,
                            width: 35,
                            child: CircleAvatar(
                              backgroundColor: Colors.yellow,
                              child: Text(
                                currentTemp != null ? "${currentTemp}c" : 'n/a',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            width: 35,
                            child: CircleAvatar(
                              backgroundColor: Colors.yellow,
                              child: Text(
                                remainingTime != null
                                    ? formatDurationInHhMm(remainingTime!)
                                    : 'n/a',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        right: 0,
                        child: PopupMenuButton(
                          constraints: const BoxConstraints.expand(
                              width: 80, height: 60),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem<int>(
                                value: 0,
                                child: const Text("Delete"),
                                onTap: () {
                                  widget.onDelete(widget.cooker);
                                },
                              ),
                            ];
                          },
                        ))
                  ],
                ),
              ),
            ],
          ),
          Transform.translate(
            offset: const Offset(0, 35),
            child: const Text("Temperature"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: 0.8,
                child: NumberPicker(
                    textMapper: (numberText) => "${numberText}c",
                    itemWidth: 100,
                    itemHeight: 100,
                    haptics: false,
                    infiniteLoop: false,
                    axis: Axis.horizontal,
                    decoration: const BoxDecoration(color: Colors.transparent),
                    textStyle: const TextStyle(color: Colors.blue),
                    minValue: 40,
                    maxValue: 229,
                    value: _temp,
                    onChanged: (val) {
                      setState(() {
                        _temp = val;
                      });
                    }),
              ),
            ],
          ),
          Transform.translate(
              offset: const Offset(0, -25), child: const Text("Duration")),
          Transform.translate(
            offset: const Offset(0, -20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // _duratoinModal(context);
                    var newDuration = await showDurationPicker(
                      context: context,
                      initialTime: _duration,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    );
                    setState(() {
                      _duration = newDuration!;
                    });
                  },
                  child: Text(formatDuration(_duration)),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          CircleAvatar(
            child: IconButton(
              color: Colors.white,
              onPressed: () async {
                if (running) {
                  await widget.cooker.stop();
                } else {
                  await widget.cooker.startTemp(_duration.inMinutes, _temp,
                      confirmStart: true);
                }
              },
              icon: Icon(running ? Icons.stop : Icons.play_arrow),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }
}
