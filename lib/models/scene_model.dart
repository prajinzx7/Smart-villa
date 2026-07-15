class SceneModel {
  final String name;
  final String icon;

  SceneModel({
    required this.name,
    required this.icon,
  });

  String get emoji {
    switch (icon) {
      case "sun":
        return "☀️";

      case "moon":
        return "🌙";

      case "home":
        return "🏠";

      case "movie":
        return "🎬";

      default:
        return "🏠";
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "icon": icon,
    };
  }

  factory SceneModel.fromJson(Map<String, dynamic> json) {
    return SceneModel(
      name: json["name"],
      icon: json["icon"],
    );
  }
}