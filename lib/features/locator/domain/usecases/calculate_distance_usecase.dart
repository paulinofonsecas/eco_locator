import 'package:eco_locator/features/locator/domain/repositories/i_recycling_point_repository.dart';
import 'package:latlong2/latlong.dart';

class CalculateDistanceUseCase {
  final IRecyclingPointRepository _repository;

  CalculateDistanceUseCase(this._repository);

  Future<double?> call({required LatLng? latLong1, required LatLng? latLong2}) {
    if (latLong1 == null || latLong2 == null) {
      return Future.value(null);
    }
    return _repository.calculateDistance(latLong1, latLong2);
  }
}
