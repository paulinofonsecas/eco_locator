import 'package:eco_locator/features/locator/domain/entities/recycling_point.dart';
import 'package:latlong2/latlong.dart';

abstract class IRecyclingPointRepository {
  Future<List<RecyclingPoint>> getRecyclingPoints();
  Future<double?> calculateDistance(LatLng lat, LatLng long);
}