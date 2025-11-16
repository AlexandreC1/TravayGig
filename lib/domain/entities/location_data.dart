import 'package:equatable/equatable.dart';

/// Domain entity representing location data
class LocationData extends Equatable {
  final double latitude;
  final double longitude;
  final String? address;
  final double? accuracy;

  const LocationData({
    required this.latitude,
    required this.longitude,
    this.address,
    this.accuracy,
  });

  /// Create a copy with updated fields
  LocationData copyWith({
    double? latitude,
    double? longitude,
    String? address,
    double? accuracy,
  }) {
    return LocationData(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      accuracy: accuracy ?? this.accuracy,
    );
  }

  @override
  List<Object?> get props => [latitude, longitude, address, accuracy];
}
