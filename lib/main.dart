import 'package:eco_locator/core/design_system/theme_extension/theme_manager.dart';
import 'package:eco_locator/features/locator/data/datasources/i_recycling_point_datasource.dart';
import 'package:eco_locator/features/locator/data/datasources/local_recycling_point_data_source.dart';
import 'package:eco_locator/features/locator/data/repositories/recycling_point_repository.dart';
import 'package:eco_locator/features/locator/domain/repositories/i_recycling_point_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:eco_locator/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider<IRecyclingPoingDatasource>(
          create: (_) => LocalRecyclingPointDatasource(),
        ),
        Provider<IRecyclingPointRepository>(
          create: (context) => RecyclingPoingRepository(
            context.read<IRecyclingPoingDatasource>(),
          ),
        ),
      ],
      child: const App(),
    ),
  );
}
