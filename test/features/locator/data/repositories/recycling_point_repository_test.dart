
import 'package:eco_locator/features/locator/data/datasources/i_recycling_point_datasource.dart';
import 'package:eco_locator/features/locator/data/repositories/recycling_point_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:mockito/mockito.dart';

class MockRecyclingPointDataSource extends Mock
    implements IRecyclingPoingDatasource {}

void main() {
  late RecyclingPoingRepository repository;
  late MockRecyclingPointDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockRecyclingPointDataSource();
    repository = RecyclingPoingRepository(mockDataSource);
  });

  group('calculateDistance', () {
    test('should return 0 when points are the same', () async {
      // Arrange
      final point = LatLng(38.7223, -9.1393);

      // Act
      final distance = await repository.calculateDistance(point, point);

      // Assert
      expect(distance, 0);
    });

    test('should return correct distance for known locations', () async {
      // Arrange
      final lisbon = LatLng(38.7223, -9.1393);
      final madrid = LatLng(40.4168, -3.7038);
      const expectedDistance = 503338.0; // in meters

      // Act
      final distance = await repository.calculateDistance(lisbon, madrid);

      // Assert
      expect(distance, closeTo(expectedDistance, 1.0));
    });

    test('should return correct distance for antipodal points', () async {
      // Arrange
      final point1 = LatLng(40.4168, -3.7038);
      final point2 = LatLng(-40.4168, 176.2962);
      const expectedDistance = 20015000.0; // in meters, approx half earth circumference

      // Act
      final distance = await repository.calculateDistance(point1, point2);

      // Assert
      // Looser tolerance for antipodal calculation
      expect(distance, closeTo(expectedDistance, 1000.0));
    });
  });
}
