import 'package:videoplayerfirebase/ui/index.dart';

class VFModel {
  final String name;
  final String url;
  final int uploadTime;

  VFModel({
    required this.name,
    required this.uploadTime,
    required this.url,
  });

  static VFModel fromMap(Map<String, dynamic> json) {
    return VFModel(
      name: json["name"],
      uploadTime: json["uploadTime"],
      url: json["url"],
    );
  }

  @override
  String toString() {
    return "${name} :: ${uploadTime} :: ${url}";
  }
}
