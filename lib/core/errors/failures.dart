import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
/// Uses Equatable for value comparison
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Failure during server communication
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure during authentication
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Failure during caching operations
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Failure during network operations
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Failure during validation
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Failure during location services
class LocationFailure extends Failure {
  const LocationFailure(super.message);
}

/// Failure during permission requests
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

/// Unexpected or unknown failure
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}
