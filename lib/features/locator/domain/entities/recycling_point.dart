import 'package:latlong2/latlong.dart';

class RecyclingPoint {
  final String nome;
  final List<String> materials;
  final double latitude;
  final double longitude;

  RecyclingPoint({
    required this.nome,
    required this.materials,
    required this.latitude,
    required this.longitude,
  });

  LatLng get location => LatLng(latitude, longitude);
}
