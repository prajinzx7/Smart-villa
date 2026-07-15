import '../models/home_model.dart';

class HomeService {
  List<HomeModel> getHomes() {
    return [
      HomeModel(id: '1', name: 'My Home'),
    ];
  }
}