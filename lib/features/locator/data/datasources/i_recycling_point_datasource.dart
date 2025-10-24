import '../models/recycling_point_model.dart';

abstract class IRecyclingPoingDatasource {
  Future<List<RecyclingPointModel>> getRecyclingPoints();
}
