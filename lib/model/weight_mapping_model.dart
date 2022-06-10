/*class WeightMapping {
  String? name;
  List<TypeList>? weight;

  WeightMapping({
    this.name,
    this.weight,
  });

  factory WeightMapping.fromJson(Map<String, dynamic> json) {
    var weightList = json['Weight'] as List;
    name = json['Name'];
    weight = weightList.map((e) => e)
  }
}*/

class WeightMapping {
  String Name;
  List<TypeList> Weight;
  WeightMapping(this.Name, this.Weight);
  factory WeightMapping.fromJson(dynamic json) {
    var Weightlist = json['Weight'] as List;
    List<TypeList> _Weight =
        Weightlist.map((e) => TypeList.fromJson(e)).toList();
    return WeightMapping(json['Name'] as String, _Weight);
  }
  @override
  String toString() {
    return '{ ${this.Name}, ${this.Weight} }';
  }
}

/*class TypeList {
  String? id;
  int? weight;

  TypeList({
    this.id,
    this.weight,
  });

  TypeList.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    weight = json['Weight'];
  }
}*/

class TypeList {
  String Id;
  int Weight;
  TypeList(this.Id, this.Weight);
  factory TypeList.fromJson(dynamic json) {
    return TypeList(json['Id'] as String, json['Weight'] as int);
  }
  @override
  String toString() {
    return '{ ${this.Id}, ${this.Weight} }';
  }
}
