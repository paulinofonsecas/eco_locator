import 'dart:math' as math;

import 'package:eco_locator/features/locator/data/datasources/i_recycling_point_datasource.dart';
import 'package:eco_locator/features/locator/domain/entities/recycling_point.dart';
import 'package:eco_locator/features/locator/domain/repositories/i_recycling_point_repository.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class RecyclingPoingRepository implements IRecyclingPointRepository {
  final IRecyclingPoingDatasource _datasource;

  RecyclingPoingRepository(this._datasource);

  @override
  Future<double?> calculateDistance(LatLng point1, LatLng point2) async {
    try {
      final now = DateTime.now();
      debugPrint('Calculating distance between $point1 and $point2');
      debugPrint('Initial time is ${now}');
      const double earthRadius = 6371000; // metros

      final lat1Rad = point1.latitude * (math.pi / 180);
      final lat2Rad = point2.latitude * (math.pi / 180);
      final deltaLatRad = (point2.latitude - point1.latitude) * (math.pi / 180);
      final deltaLngRad =
          (point2.longitude - point1.longitude) * (math.pi / 180);

      final a = math.sin(deltaLatRad / 2) * math.sin(deltaLatRad / 2) +
          math.cos(lat1Rad) *
              math.cos(lat2Rad) *
              math.sin(deltaLngRad / 2) *
              math.sin(deltaLngRad / 2);

      final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

      return earthRadius * c;
    } catch (e) {
      return null;
    } finally {
      final last = DateTime.now();
      debugPrint('Final time is ${last.difference}');
    }
  }

  @override
  Future<List<RecyclingPoint>> getRecyclingPoints() async {
    try {
      return _datasource.getRecyclingPoints();
    } catch (e) {
      return [];
    }
  }
}
