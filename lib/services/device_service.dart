import '../models/device_model.dart';

class DeviceService {
  List<DeviceModel> getDevices() {
    return [
      // Living Room (1)
      DeviceModel(id: '1', name: 'Light', type: 'Switch', roomId: '1'),
      DeviceModel(id: '2', name: 'Fan', type: 'Switch', roomId: '1'),
      DeviceModel(id: '3', name: 'AC', type: 'Appliance', roomId: '1'),

      // Bedroom (2)
      DeviceModel(id: '4', name: 'Light', type: 'Switch', roomId: '2'),
      DeviceModel(id: '5', name: 'Fan', type: 'Switch', roomId: '2'),
      DeviceModel(id: '6', name: 'AC', type: 'Appliance', roomId: '2'),

      // Kitchen (3)
      DeviceModel(id: '7', name: 'Light', type: 'Switch', roomId: '3'),
    ];
  }
}