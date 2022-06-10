// ignore_for_file: non_constant_identifier_names, prefer_const_constructors_in_immutables

import 'dart:convert';

import 'package:discussion_support_system/model/weight_mapping_model.dart';
import 'package:flutter/material.dart';
import '../model/gaps_mapping_model.dart';
import 'package:flutter/services.dart' as rootBundle;

class GapMapping extends StatefulWidget {
  const GapMapping({Key? key}) : super(key: key);

  @override
  State<GapMapping> createState() => _GapMappingState();
}

class _GapMappingState extends State<GapMapping> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Center(
          child: Column(
            children: [
              const Text(
                "Gap Mapping",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              Table(
                border: TableBorder.all(
                    color: Colors.black, style: BorderStyle.solid, width: 2),
                children: [
                  TableRow(
                    children: [
                      Column(children: const [
                        Text('Name', style: TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: const [
                        Text('A1', style: TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: const [
                        Text('A2', style: TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: const [
                        Text('B1', style: TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: const [
                        Text('B2', style: TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: const [
                        Text('B3', style: TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: const [
                        Text('C1', style: TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: const [
                        Text('C2', style: TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: const [
                        Text('C3', style: TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: const [
                        Text('D1', style: TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: const [
                        Text('D2', style: TextStyle(fontSize: 10.0))
                      ])
                    ],
                  ),
                ],
              ),
              FutureGapsMapping(),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "NA Value",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Table(
                border: TableBorder.all(
                    color: Colors.black, style: BorderStyle.solid, width: 2),
                children: [
                  TableRow(
                    children: [
                      Column(children: const [
                        Text('Name', style: TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: const [
                        Text('A', style: TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: const [
                        Text('B', style: TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: const [
                        Text('C', style: TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: const [
                        Text('D', style: TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: const [
                        Text('E', style: TextStyle(fontSize: 10.0))
                      ]),
                    ],
                  ),
                ],
              ),
              NaValue(),
            ],
          ),
        ),
      ),
    );
  }
}

class FutureGapsMapping extends StatefulWidget {
  FutureGapsMapping({Key? key}) : super(key: key);

  @override
  State<FutureGapsMapping> createState() => _FutureGapsMappingState();
}

class _FutureGapsMappingState extends State<FutureGapsMapping> {
  Future<List<GapsMappingModel>> readGapsMappingModel() async {
    //read json file
    final jsondata = await rootBundle.rootBundle
        .loadString('json/CompetencyGapsMapping.json');
    //decode json data as list
    final list = json.decode(jsondata) as List<dynamic>;

    //map json and initialize using DataModel
    return list.map((e) => GapsMappingModel.fromJson(e)).toList();
  }

  Future<List<WeightMapping>> readWeightMappingModel() async {
    //read json file
    final jsondata =
        await rootBundle.rootBundle.loadString('json/WeightMapping.json');
    //decode json data as list
    final list = json.decode(jsondata) as List<dynamic>;

    //map json and initialize using DataModel
    return list.map((e) => WeightMapping.fromJson(e)).toList();
  }

  void gapMapping() async {
    List<GapsMappingModel> _gapsMapping = await readGapsMappingModel();
    List<WeightMapping> _weightMapping = await readWeightMappingModel();
    for (var i = 0; i < _weightMapping.length; i++) {
      for (var j = 0; j < _gapsMapping.length; j++) {
        list.add(_weightMapping[i].Weight[j].Weight - _gapsMapping[j].weight!);
      }
    }
    weightmapping();
  }

  void weightmapping() {
    for (var i = 0; i < list.length; i++) {
      switch (list[i]) {
        case (0):
          list[i] = 5;
          break;
        case (1):
          list[i] = 4.5;
          break;
        case (2):
          list[i] = 3.5;
          break;
        case (3):
          list[i] = 2.5;
          break;
        case (4):
          list[i] = 1.5;
          break;
        case (-1):
          list[i] = 4;
          break;
        case (-2):
          list[i] = 3;
          break;
        case (-3):
          list[i] = 2;
          break;
        case (-4):
          list[i] = 1;
          break;
        default:
      }
    }
  }

  @override
  void initState() {
    gapMapping();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: readWeightMappingModel(),
        builder: (context, data) {
          if (data.hasError) {
            return Center(child: Text("${data.error}"));
          } else if (data.hasData) {
            var item = data.data as List<WeightMapping>;
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: item.length,
              itemBuilder: (context, index) {
                return Table(
                  children: [
                    TableRow(children: [
                      Column(children: [
                        Text(item[index].Name.toString(),
                            style: const TextStyle(fontSize: 9.0))
                      ]),
                      Column(children: [
                        Text(list[index * 10 + 0].toString(),
                            style: const TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: [
                        Text(list[index * 10 + 1].toString(),
                            style: const TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: [
                        Text(list[index * 10 + 2].toString(),
                            style: const TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: [
                        Text(list[index * 10 + 3].toString(),
                            style: const TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: [
                        Text(list[index * 10 + 4].toString(),
                            style: const TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: [
                        Text(list[index * 10 + 5].toString(),
                            style: const TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: [
                        Text(list[index * 10 + 6].toString(),
                            style: const TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: [
                        Text(list[index * 10 + 7].toString(),
                            style: const TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: [
                        Text(list[index * 10 + 8].toString(),
                            style: const TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: [
                        Text(list[index * 10 + 9].toString(),
                            style: const TextStyle(fontSize: 10.0))
                      ]),
                    ])
                  ],
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class NaValue extends StatefulWidget {
  NaValue({Key? key}) : super(key: key);

  @override
  State<NaValue> createState() => _NaValueState();
}

class _NaValueState extends State<NaValue> {
  void NCFList() async {
    List _list = await list;
    List<WeightMapping> _weightMapping = await readWeightMappingModel();
    for (var i = 0; i < _weightMapping.length; i++) {
      NCF.add(_list[i * 9 + 0]);
      NCF.add((_list[i * 9 + 2] + list[i * 9 + 3]) / 2);
      NCF.add((_list[i * 9 + 5] + list[i * 9 + 6]) / 2);
      NCF.add(_list[i * 9 + 8]);
    }
  }

  void NSFList() async {
    List _list = await list;
    List<WeightMapping> _weightMapping = await readWeightMappingModel();
    for (var i = 0; i < _weightMapping.length; i++) {
      NCF.add(_list[i * 9 + 1]);
      NCF.add(_list[i * 9 + 3]);
      NCF.add(_list[i * 9 + 7]);
      NCF.add(_list[i * 9 + 9]);
    }
  }

  void NAList() async {
    List _NCF = await NCF;
    List _NSF = await NSF;
    for (var i = 0; i < NCF.length; i++) {
      NA.add(_NCF[i] * 0.6 + _NSF[i] * 0.4);
    }
  }

  Future<List<GapsMappingModel>> readGapsMappingModel() async {
    //read json file
    final jsondata = await rootBundle.rootBundle
        .loadString('json/CompetencyGapsMapping.json');
    //decode json data as list
    final list = json.decode(jsondata) as List<dynamic>;

    //map json and initialize using DataModel
    return list.map((e) => GapsMappingModel.fromJson(e)).toList();
  }

  Future<List<WeightMapping>> readWeightMappingModel() async {
    //read json file
    final jsondata =
        await rootBundle.rootBundle.loadString('json/WeightMapping.json');
    //decode json data as list
    final list = json.decode(jsondata) as List<dynamic>;

    //map json and initialize using DataModel
    return list.map((e) => WeightMapping.fromJson(e)).toList();
  }

  @override
  void initState() {
    NCFList();
    NSFList();
    NAList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: readWeightMappingModel(),
        builder: (context, data) {
          if (data.hasError) {
            return Center(child: Text("${data.error}"));
          } else if (data.hasData) {
            var item = data.data as List<WeightMapping>;
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: item.length,
              itemBuilder: (context, index) {
                return Table(
                  children: [
                    TableRow(children: [
                      Column(children: [
                        Text(item[index].Name.toString(),
                            style: const TextStyle(fontSize: 9.0))
                      ]),
                      Column(children: [
                        Text(NA[index * 5 + 0].toString(),
                            style: const TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: [
                        Text(NA[index * 5 + 1].toString(),
                            style: const TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: [
                        Text(NA[index * 5 + 2].toString(),
                            style: const TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: [
                        Text(NA[index * 5 + 3].toString(),
                            style: const TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: [
                        Text(NA[index * 5 + 4].toString(),
                            style: const TextStyle(fontSize: 10.0))
                      ]),
                    ])
                  ],
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

List list = [];
List NCF = [];
List NSF = [];
List NA = [];
