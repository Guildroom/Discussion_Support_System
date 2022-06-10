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
  List finalScore = [];
  List finalName = [];
  List AHPNormalisasi = [];
  List AHPAVG = [];
  List AHPName = ['Utilitas', 'Memory', 'baterai', 'chipset'];
  List AHP = [
    [1, 3, 5, 1 / 2],
    [1 / 3, 1, 2, 1 / 4],
    [1 / 5, 1 / 2, 1, 1 / 7],
    [2, 4, 7, 1]
  ];
  List list = [];
  List NCF = [];
  List NSF = [];
  List NA = [];
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
    NCFList();
  }

  void NCFList() async {
    list;
    List<WeightMapping> _weightMapping = await readWeightMappingModel();
    for (var i = 0; i < _weightMapping.length; i++) {
      NCF.add(list[i * 10 + 0]);
      NCF.add((list[i * 10 + 2] + list[i * 10 + 3]) / 2);
      NCF.add((list[i * 10 + 5] + list[i * 10 + 6]) / 2);
      NCF.add(list[i * 10 + 8]);
    }
    NSFList();
  }

  void NSFList() async {
    list;
    List<WeightMapping> _weightMapping = await readWeightMappingModel();
    for (var i = 0; i < _weightMapping.length; i++) {
      NSF.add(list[i * 10 + 1]);
      NSF.add(list[i * 10 + 3]);
      NSF.add(list[i * 10 + 7]);
      NSF.add(list[i * 10 + 9]);
    }
    NAList();
  }

  void NAList() async {
    for (var i = 0; i < NCF.length; i++) {
      NA.add(NCF[i] * 0.6 + NSF[i] * 0.4);
    }
    final_Score();
  }

  void AHPNormalize() {
    for (var i = 0; i < AHP.length; i++) {
      for (var j = 0; j < AHP.length; j++) {
        AHPNormalisasi.add(
            AHP[i][j] / (AHP[0][j] + AHP[1][j] + AHP[2][j] + AHP[3][j]));
      }
    }
    AHP_AVG();
  }

  void AHP_AVG() {
    for (var i = 0; i < AHP.length; i++) {
      AHPAVG.add((AHPNormalisasi[i * 4 + 0] +
              AHPNormalisasi[i * 4 + 0] +
              AHPNormalisasi[i * 4 + 0] +
              AHPNormalisasi[i * 4 + 0]) /
          4);
    }
  }

  void final_Score() async {
    List<WeightMapping> _weightMapping = await readWeightMappingModel();
    for (var i = 0; i < _weightMapping.length; i++) {
      finalName.add(_weightMapping[i].Name);
      finalScore.add(NA[i * 4 + 0] * AHPAVG[0] +
          NA[i * 4 + 1] * AHPAVG[1] +
          NA[i * 4 + 2] * AHPAVG[2] +
          NA[i * 4 + 3] * AHPAVG[3]);
    }
  }

  @override
  void initState() {
    gapMapping();

    AHPNormalize();
    super.initState();
  }

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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
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
              Container(
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
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "NA Value",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
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
                    ],
                  ),
                ],
              ),
              Container(
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
                                  Text(
                                      NA[index * 4 + 0]
                                          .toStringAsPrecision(3)
                                          .toString(),
                                      style: const TextStyle(fontSize: 10.0))
                                ]),
                                Column(children: [
                                  Text(
                                      NA[index * 4 + 1]
                                          .toStringAsPrecision(3)
                                          .toString(),
                                      style: const TextStyle(fontSize: 10.0))
                                ]),
                                Column(children: [
                                  Text(
                                      NA[index * 4 + 2]
                                          .toStringAsPrecision(3)
                                          .toString(),
                                      style: const TextStyle(fontSize: 10.0))
                                ]),
                                Column(children: [
                                  Text(
                                      NA[index * 4 + 3]
                                          .toStringAsPrecision(3)
                                          .toString(),
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
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "AHP Table",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Table(
                border: TableBorder.all(
                    color: Colors.black, style: BorderStyle.solid, width: 2),
                children: [
                  TableRow(
                    children: [
                      Column(children: const [
                        Text('', style: TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: [
                        Text(AHPName[0], style: const TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: [
                        Text(AHPName[1], style: const TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: [
                        Text(AHPName[2], style: const TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: [
                        Text(AHPName[3], style: const TextStyle(fontSize: 10.0))
                      ]),
                    ],
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: AHP.length,
                itemBuilder: (context, index) {
                  return Table(
                    children: [
                      TableRow(
                        children: [
                          Column(children: [
                            Text(AHPName[index],
                                style: const TextStyle(fontSize: 10.0))
                          ]),
                          Column(children: [
                            Text(
                                AHP[index][0].toStringAsPrecision(3).toString(),
                                style: const TextStyle(fontSize: 10.0))
                          ]),
                          Column(children: [
                            Text(
                                AHP[index][1].toStringAsPrecision(3).toString(),
                                style: const TextStyle(fontSize: 10.0))
                          ]),
                          Column(children: [
                            Text(
                                AHP[index][2].toStringAsPrecision(3).toString(),
                                style: const TextStyle(fontSize: 10.0))
                          ]),
                          Column(children: [
                            Text(
                                AHP[index][3].toStringAsPrecision(3).toString(),
                                style: const TextStyle(fontSize: 10.0))
                          ]),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "AHP Normalisasi & AVG",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Table(
                border: TableBorder.all(
                    color: Colors.black, style: BorderStyle.solid, width: 2),
                children: [
                  TableRow(
                    children: [
                      Column(children: const [
                        Text('', style: TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: [
                        Text(AHPName[0], style: const TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: [
                        Text(AHPName[1], style: const TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: [
                        Text(AHPName[2], style: const TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: [
                        Text(AHPName[3], style: const TextStyle(fontSize: 10.0))
                      ]),
                      Column(children: const [
                        Text('AVG', style: TextStyle(fontSize: 10.0))
                      ]),
                    ],
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: AHP.length,
                itemBuilder: (context, index) {
                  return Table(
                    children: [
                      TableRow(
                        children: [
                          Column(children: [
                            Text(AHPName[index],
                                style: const TextStyle(fontSize: 10.0))
                          ]),
                          Column(children: [
                            Text(
                                AHPNormalisasi[index * 4 + 0]
                                    .toStringAsPrecision(3)
                                    .toString(),
                                style: const TextStyle(fontSize: 10.0))
                          ]),
                          Column(children: [
                            Text(
                                AHPNormalisasi[index * 4 + 1]
                                    .toStringAsPrecision(3)
                                    .toString(),
                                style: const TextStyle(fontSize: 10.0))
                          ]),
                          Column(children: [
                            Text(
                                AHPNormalisasi[index * 4 + 2]
                                    .toStringAsPrecision(3)
                                    .toString(),
                                style: const TextStyle(fontSize: 10.0))
                          ]),
                          Column(children: [
                            Text(
                                AHPNormalisasi[index * 4 + 3]
                                    .toStringAsPrecision(3)
                                    .toString(),
                                style: const TextStyle(fontSize: 10.0))
                          ]),
                          Column(children: [
                            Text(
                                AHPAVG[index].toStringAsPrecision(3).toString(),
                                style: const TextStyle(fontSize: 10.0))
                          ]),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Final Score",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: finalScore.length,
                itemBuilder: (context, index) {
                  return Table(
                    children: [
                      TableRow(
                        children: [
                          Column(children: [
                            Text(finalName[index],
                                style: const TextStyle(fontSize: 10.0))
                          ]),
                          Column(children: [
                            Text(
                                finalScore[index]
                                    .toStringAsPrecision(3)
                                    .toString(),
                                style: const TextStyle(fontSize: 10.0))
                          ]),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
