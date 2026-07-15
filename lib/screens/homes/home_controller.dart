import '../../models/home_model.dart';
import '../../services/home_service.dart';

class HomeController {
  final HomeService _homeService = HomeService();

  List<HomeModel> getHomes() {
    return _homeService.getHomes();
  }
}