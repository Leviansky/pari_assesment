class DelayTimeoutException implements Exception {
  final String message;
  const DelayTimeoutException(this.message);
}

class DelayConstants {
  static const Duration timeout = Duration(seconds: 30);
  static const Duration interval = Duration(seconds: 1);
  static const Duration cacheValidity = Duration(hours: 24);
  static const String storageKey = 'cached_items';

  const DelayConstants._();
}