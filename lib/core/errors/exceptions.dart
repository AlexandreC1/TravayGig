/// Base exception class for the application
class AppException implements Exception {
  final String message;
  final dynamic error;

  AppException(this.message, [this.error]);

  @override
  String toString() => message;
}

/// Exception thrown when server communication fails
class ServerException extends AppException {
  ServerException(super.message, [super.error]);
}

/// Exception thrown when authentication fails
class AuthException extends AppException {
  AuthException(super.message, [super.error]);
}

/// Exception thrown when cache operations fail
class CacheException extends AppException {
  CacheException(super.message, [super.error]);
}

/// Exception thrown when network is unavailable
class NetworkException extends AppException {
  NetworkException(super.message, [super.error]);
}

/// Exception thrown when validation fails
class ValidationException extends AppException {
  ValidationException(super.message, [super.error]);
}

/// Exception thrown when location services fail
class LocationException extends AppException {
  LocationException(super.message, [super.error]);
}

/// Exception thrown when permission is denied
class PermissionException extends AppException {
  PermissionException(super.message, [super.error]);
}
