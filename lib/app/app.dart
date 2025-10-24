import 'package:eco_locator/features/locator/domain/repositories/i_recycling_point_repository.dart';
import 'package:eco_locator/features/locator/domain/usecases/calculate_distance_usecase.dart';
import 'package:eco_locator/features/locator/domain/usecases/get_recycling_points_usecase.dart';
import 'package:eco_locator/features/locator/presentation/pages/echo_locator_screen.dart';
import 'package:eco_locator/features/locator/presentation/providers/eco_locator_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:eco_locator/core/design_system/theme_extension/app_theme_extension.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<GetRecyclingPointsUseCase>(
          create: (context) => GetRecyclingPointsUseCase(
            context.read<IRecyclingPointRepository>(),
          ),
        ),
        Provider<CalculateDistanceUseCase>(
          create: (_) => CalculateDistanceUseCase(
            context.read<IRecyclingPointRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => EcoLocatorProvider(
            getAllRecyclingPoints: context.read<GetRecyclingPointsUseCase>(),
            calculateDistance: context.read<CalculateDistanceUseCase>(),
          )..initializeApp(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Consumer<EcoLocatorProvider>(
            builder: (context, _, state) {
              return MaterialApp(
                title: dotenv.maybeGet('APP_NAME') ?? 'eco_locator',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: _.themeMode == AppThemeMode.light
                    ? ThemeMode.light
                    : ThemeMode.dark,
                home: const EcoLocatorScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
