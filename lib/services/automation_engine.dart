import 'dart:async';

class AutomationEngine {

  Timer? _timer;

  void start() {

    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(minutes: 1),
          (_) {

        print("Checking automations...");

      },
    );
  }

  void stop() {
    _timer?.cancel();
  }
}