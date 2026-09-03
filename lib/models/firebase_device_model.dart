class FirebaseDeviceModel {

  final String id;
  final String name;
  final String type;
  final String roomId;
  final bool state;
  final String espId;


  FirebaseDeviceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.roomId,
    required this.state,
    required this.espId,
  });


  factory FirebaseDeviceModel.fromJson(
      String id,
      Map<String, dynamic> json,
      ) {

    return FirebaseDeviceModel(
      id: id,
      name: json["name"] ?? "",
      type: json["type"] ?? "",
      roomId: json["roomId"] ?? "",
      state: json["state"] ?? false,
      espId: json["espId"] ?? "",
    );
  }


  Map<String, dynamic> toJson() {

    return {

      "name": name,
      "type": type,
      "roomId": roomId,
      "state": state,
      "espId": espId,

    };
  }

}