import 'package:eco_locator/features/locator/domain/entities/recycling_point.dart';
import 'package:eco_locator/features/locator/presentation/providers/eco_locator_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class EcoLocatorScreen extends StatefulWidget {
  const EcoLocatorScreen({super.key});

  @override
  State<EcoLocatorScreen> createState() => _EcoLocatorScreenState();
}

class _EcoLocatorScreenState extends State<EcoLocatorScreen> {
  final MapController _mapController = MapController();
  static const LatLng _initialCenter = LatLng(-8.838333, 13.234444);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<EcoLocatorProvider>(context, listen: false);
      if (provider.currentLocation != null) {
        _mapController.move(provider.currentLocation!, 13.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoLocator'),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<EcoLocatorProvider>(context).themeMode ==
                      AppThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              Provider.of<EcoLocatorProvider>(context, listen: false)
                  .toggleTheme();
            },
          ),
        ],
      ),
      body: Consumer<EcoLocatorProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        provider.initializeApp();
                      },
                      child: const Text('Tentar Novamente'),
                    ),
                    if (provider.errorMessage!
                        .contains('Permissão de localização negada'))
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Implementar navegação para configurações do app.')),
                          );
                        },
                        child: const Text('Abrir Configurações'),
                      ),
                  ],
                ),
              ),
            );
          }

          final LatLng center = provider.currentLocation ?? _initialCenter;

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: center,
                  initialZoom: 13.0,
                  onTap: (tapPosition, latlng) {},
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.ecolocator',
                  ),
                  MarkerLayer(
                    markers: [
                      if (provider.currentLocation != null)
                        Marker(
                          point: provider.currentLocation!,
                          width: 80,
                          height: 80,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.redAccent,
                            size: 40,
                          ),
                        ),
                      ...provider.filteredRecyclingPoints.map((point) {
                        return Marker(
                          point: point.location,
                          width: 100,
                          height: 100,
                          child: GestureDetector(
                            onTap: () =>
                                _showPointDetails(context, provider, point),
                            child: Icon(
                              _getMaterialIcon(point.materials.first),
                              color: _getMaterialColor(point.materials),
                              size: 32,
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ],
              ),
              Positioned(
                bottom: 20,
                left: 10,
                right: 10,
                child: _buildFilterChips(context, provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, EcoLocatorProvider provider) {
    final List<String> allMaterials = [
      'Todos',
      'Plástico',
      'Vidro',
      'Metal',
      'Papel',
      'Eletrônicos'
    ];

    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      alignment: WrapAlignment.center,
      children: allMaterials.map((material) {
        final isSelected = provider.selectedMaterialFilter == material ||
            (provider.selectedMaterialFilter == null && material == 'Todos');
        return ChoiceChip(
          label: Text(material),
          selected: isSelected,
          onSelected: (selected) {
            provider.applyMaterialFilter(selected ? material : 'Todos');
          },
          selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
          backgroundColor: Theme.of(context).cardColor,
          labelStyle: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).textTheme.bodyLarge?.color,
          ),
        );
      }).toList(),
    );
  }

  void _showPointDetails(
      BuildContext context, EcoLocatorProvider provider, RecyclingPoint point) {
    showDialog(
      context: context,
      builder: (BuildContext bc) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    children: <Widget>[
                      ListTile(
                        title: Text(point.nome,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 8),
                            SizedBox(height: 16),
                            Text(
                              'Materiais aceitos',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                              ),
                            ),
                            Center(
                              child: Wrap(
                                spacing: 12,
                                runSpacing: 4,
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.horizontal,
                                children: point.materials
                                    .join(', ')
                                    .split(', ')
                                    .map((material) {
                                  return Column(
                                    children: [
                                      Icon(
                                        _getMaterialIcon(material),
                                        color: _getMaterialColor(point.materials),
                                        size: 32,
                                      ),
                                     
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(height: 16),
                            Divider(),
                            FutureBuilder<double?>(
                              future: provider.calculateDistance(
                                latLong1: provider.currentLocation!,
                                latLong2: point.location,
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text(
                                    'Distância: Calculando...',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 16,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return const Text(
                                    'Distância: Erro ao calcular',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 16,
                                    ),
                                  );
                                } else if (snapshot.hasData) {
                                  return Center(
                                    child: Text(
                                      '${(snapshot.data!).toStringAsFixed(0)} metros\n até o local',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21,
                                      ),
                                    ),
                                  );
                                }
                                return const Text('Distância: N/A');
                              },
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Fechar'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getMaterialIcon(String material) {
    switch (material) {
      case 'Plástico':
        return FontAwesomeIcons.recycle;
      case 'Vidro':
        return FontAwesomeIcons.wineBottle;
      case 'Metal':
        return FontAwesomeIcons.gear;
      case 'Papel':
        return FontAwesomeIcons.solidNewspaper;
      case 'Eletrônicos':
        return FontAwesomeIcons.mobileAlt;
      default:
        return FontAwesomeIcons.dotCircle;
    }
  }

  Color _getMaterialColor(List<String> materials) {
    if (materials.contains('Plástico')) {
      return Colors.green;
    } else if (materials.contains('Vidro')) {
      return Colors.brown;
    } else if (materials.contains('Metal')) {
      return const Color.fromARGB(255, 92, 10, 127);
    } else if (materials.contains('Papel')) {
      return Colors.yellow;
    } else if (materials.contains('Eletrônicos')) {
      return Colors.blue;
    } else {
      return Colors.grey;
    }
  }
}
