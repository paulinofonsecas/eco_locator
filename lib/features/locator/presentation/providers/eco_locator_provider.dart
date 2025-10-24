import 'package:eco_locator/features/locator/domain/entities/recycling_point.dart';
import 'package:eco_locator/features/locator/domain/usecases/calculate_distance_usecase.dart';
import 'package:eco_locator/features/locator/domain/usecases/get_recycling_points_usecase.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

enum AppThemeMode { light, dark }

class EcoLocatorProvider extends ChangeNotifier {
  final GetRecyclingPointsUseCase getAllRecyclingPoints;
  final CalculateDistanceUseCase calculateDistance;

  EcoLocatorProvider({
    required this.getAllRecyclingPoints,
    required this.calculateDistance,
  });

  LatLng? _currentLocation;
  LatLng? get currentLocation => _currentLocation;

  List<RecyclingPoint> _allRecyclingPoints = [];
  List<RecyclingPoint> _filteredRecyclingPoints = [];
  List<RecyclingPoint> get filteredRecyclingPoints => _filteredRecyclingPoints;

  String? _selectedMaterialFilter;
  String? get selectedMaterialFilter => _selectedMaterialFilter;

  AppThemeMode _themeMode = AppThemeMode.light;
  AppThemeMode get themeMode => _themeMode;
  ThemeData get currentTheme =>
      _themeMode == AppThemeMode.light ? ThemeData.light() : ThemeData.dark();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> initializeApp() async {
    _setLoading(true);
    await _getCurrentLocation();
    await _loadRecyclingPoints();
    _setLoading(false);
  }

  Future<void> _getCurrentLocation() async {
    _setErrorMessage(null);
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _setErrorMessage('O serviço de localização está desativado.');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _setErrorMessage('Permissão de localização negada.');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _setErrorMessage(
          'Permissão de localização permanentemente negada. Por favor, ative nas configurações do app.');
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _currentLocation = LatLng(position.latitude, position.longitude);
    } catch (e) {
      _setErrorMessage('Falha ao obter localização: ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> _loadRecyclingPoints() async {
    _setErrorMessage(null);
    try {
      _allRecyclingPoints = await getAllRecyclingPoints();
      _applyFilter(); // Aplica o filtro inicial (todos)
    } catch (e) {
      _setErrorMessage(
          'Falha ao carregar pontos de reciclagem: ${e.toString()}');
    }
    notifyListeners();
  }

  void applyMaterialFilter(String? material) {
    _selectedMaterialFilter = material;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_selectedMaterialFilter == null || _selectedMaterialFilter == 'Todos') {
      _filteredRecyclingPoints = List.from(_allRecyclingPoints);
    } else {
      _filteredRecyclingPoints = _allRecyclingPoints
          .where((point) => point.materials.contains(_selectedMaterialFilter))
          .toList();
    }
  }

  Future<double?> getDistanceToPoint(RecyclingPoint point) async {
    if (_currentLocation == null) return 0.0;
    try {
      return calculateDistance(
        latLong1: _currentLocation!,
        latLong2: LatLng(point.latitude, point.longitude),
      );
    } catch (e) {
      debugPrint('Error calculating distance: $e');
      return 0.0;
    }
  }

  void toggleTheme() {
    _themeMode = _themeMode == AppThemeMode.light
        ? AppThemeMode.dark
        : AppThemeMode.light;
    print('Theme changed => ' + _themeMode.toString());
    notifyListeners();
  }
}
