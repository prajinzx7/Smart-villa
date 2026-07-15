import 'package:flutter/material.dart';
import '../../services/room_service.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rooms = RoomService().getRooms();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rooms"),
      ),
      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];

          return ListTile(
            leading: const Icon(Icons.meeting_room),
            title: Text(room.name),
            onTap: () {
              print("ROOM ID SENT: ${room.id}");

              Navigator.pushNamed(
                context,
                '/devices',
                arguments: room.id,
              );
            },
          );
        },
      ),
    );
  }
}