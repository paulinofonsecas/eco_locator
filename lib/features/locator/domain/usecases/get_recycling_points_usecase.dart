import 'package:eco_locator/features/locator/domain/entities/recycling_point.dart';
import 'package:eco_locator/features/locator/domain/repositories/i_recycling_point_repository.dart';

class GetRecyclingPointsUseCase {
  final IRecyclingPointRepository _repository;

  GetRecyclingPointsUseCase(this._repository);

  Future<List<RecyclingPoint>> call() async {
    return _repository.getRecyclingPoints();
  }
}
