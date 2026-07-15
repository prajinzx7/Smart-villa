import '../models/room_model.dart';

class RoomService {
  List<RoomModel> getRooms() {
    return [
      RoomModel(id: '1', name: 'Living Room'),
      RoomModel(id: '2', name: 'Bedroom'),
      RoomModel(id: '3', name: 'Kitchen'),
    ];
  }
}