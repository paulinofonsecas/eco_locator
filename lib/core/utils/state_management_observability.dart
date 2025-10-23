import 'package:flutter/foundation.dart';
/// Enhanced ChangeNotifier for Provider with logging capabilities
class ObservableChangeNotifier extends ChangeNotifier {
  void notifyListenersWithLog(String message,
      {dynamic oldValue, dynamic newValue}) {
    _log('State change in $runtimeType: $message');
    if (oldValue != null && newValue != null) {
      _log('  From: $oldValue');
      _log('  To: $newValue');
    }
    notifyListeners();
  }

  /// Utility function for formatted logging
void _log(String message) {
  if (kDebugMode) {
    print('╔═══════════════════════════════════════════════════════');
    print('║ $message');
    print('╚═══════════════════════════════════════════════════════');
  }
}

}

/// Setup function to initialize observability for Provider
void setupStateObservability() {
  if (kDebugMode) {
    print('Provider state observability configured!');
    print('Note: Use ObservableChangeNotifier instead of ChangeNotifier for better logging');
  }
}
