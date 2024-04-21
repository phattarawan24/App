class MapModel {
  MapModel({
    required this.id,
    required this.nameTree,
    required this.name,
    required this.lat,
    required this.lng,
    required this.urlImage,
    required this.coloricon,
    required this.height,
  });
  late final String id;
  late final String nameTree;
  late final String name;
  late final String lat;
  late final String lng;
  late final String urlImage;
  late final String coloricon;
  late final String height;

  MapModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameTree = json['nameTree'];
    name = json['name'];
    lat = json['lat'];
    lng = json['lng'];
    urlImage = json['urlImage'];
    coloricon = json['coloricon'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['nameTree'] = nameTree;
    _data['name'] = name;
    _data['lat'] = lat;
    _data['lng'] = lng;
    _data['urlImage'] = urlImage;
    _data['coloricon'] = coloricon;
    _data['height'] = height;
    return _data;
  }
}
