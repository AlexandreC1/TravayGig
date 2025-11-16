import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/location_data.dart';

part 'location_data_model.g.dart';

/// Data transfer object for LocationData
@JsonSerializable()
class LocationDataModel {
  final double latitude;
  final double longitude;
  final String? address;
  final double? accuracy;

  const LocationDataModel({
    required this.latitude,
    required this.longitude,
    this.address,
    this.accuracy,
  });

  /// Convert from JSON
  factory LocationDataModel.fromJson(Map<String, dynamic> json) =>
      _$LocationDataModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$LocationDataModelToJson(this);

  /// Convert from domain entity
  factory LocationDataModel.fromEntity(LocationData entity) {
    return LocationDataModel(
      latitude: entity.latitude,
      longitude: entity.longitude,
      address: entity.address,
      accuracy: entity.accuracy,
    );
  }

  /// Convert to domain entity
  LocationData toEntity() {
    return LocationData(
      latitude: latitude,
      longitude: longitude,
      address: address,
      accuracy: accuracy,
    );
  }
}
