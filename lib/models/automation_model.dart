class AutomationModel {
  final String id;
  final String name;
  final String startTime;
  final String endTime;
  final String sceneName;
  final bool enabled;

  AutomationModel({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.sceneName,
    required this.enabled,
  });


  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "startTime": startTime,
      "endTime": endTime,
      "sceneName": sceneName,
      "enabled": enabled,
    };
  }


  factory AutomationModel.fromJson(
      Map<String, dynamic> json) {

    return AutomationModel(
      id: json["id"],
      name: json["name"],
      startTime: json["startTime"],
      endTime: json["endTime"],
      sceneName: json["sceneName"],
      enabled: json["enabled"],
    );
  }
}