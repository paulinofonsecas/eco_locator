import 'package:eco_locator/features/locator/data/datasources/i_recycling_point_datasource.dart';
import 'package:eco_locator/features/locator/data/datasources/local_recycling_point_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final IRecyclingPoingDatasource datasource = LocalRecyclingPointDatasource();

  test('Get Recycling Points', () async {
    final result = await datasource.getRecyclingPoints();

    expect(result.length, isNot(0));
  });
}
