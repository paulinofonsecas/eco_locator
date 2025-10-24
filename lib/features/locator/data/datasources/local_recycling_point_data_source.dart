import 'dart:convert';

import 'package:eco_locator/features/locator/data/datasources/i_recycling_point_datasource.dart';
import 'package:eco_locator/features/locator/data/models/recycling_point_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocalRecyclingPointDatasource extends IRecyclingPoingDatasource {
  @override
  Future<List<RecyclingPointModel>> getRecyclingPoints() async {
    try {
      final assetPath = dotenv.maybeGet('ASSET_PATH');
      if (assetPath == null) {
        throw ArgumentError('ASSET_PATH environment variable is not set.');
      }
      final String response = await rootBundle.loadString(assetPath);
      final List<dynamic> data = json.decode(response);
      return data
          .take(80)
          .map((json) => RecyclingPointModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load recycling points from local assets: $e');
    }
  }
}
