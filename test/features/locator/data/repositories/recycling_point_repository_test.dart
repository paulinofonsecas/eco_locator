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
      final point = LatLng(38.7223, 38.7223);

      final distance = await repository.calculateDistance(point, point);

      expect(distance, 0);
    });

    test('should return correct distance for known locations', () async {
      final cityA = LatLng(-8.843861213756469, 13.296716401687153);
      final cityB = LatLng(-8.865125284744485, 13.310886148898796);
      const expectedDistance = 5000.0;

      final distance = await repository.calculateDistance(cityA, cityB);
      print('Distancia calculada: ' + distance.toString());

      expect(distance, lessThan(expectedDistance));
    });

    test('should return correct distance for antipodal points', () async {
      final point1 = LatLng(40.4168, -3.7038);
      final point2 = LatLng(-40.4168, 176.2962);
      const expectedDistance = 20015000.0;

      final distance = await repository.calculateDistance(point1, point2);

      expect(distance, closeTo(expectedDistance, 1000.0));
    });
  });
}
