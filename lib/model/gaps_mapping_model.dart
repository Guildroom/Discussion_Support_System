class GapsMappingModel{
  //data Type
  int? weight;
  String? name;
  String? type;
  String? id;
  
  GapsMappingModel(
    {
    this.weight,
    this.name,
    this.type,
    this.id
    }
  );

  GapsMappingModel.fromJson(Map<String,dynamic> json){
    weight = json['Weight'];
    name = json['Name'];
    type = json['Type'];
    id = json['id'];
  }
}
