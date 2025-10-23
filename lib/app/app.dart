import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:eco_locator/core/design_system/theme_extension/app_theme_extension.dart';
import 'package:eco_locator/core/design_system/theme_extension/theme_manager.dart';

import 'package:eco_locator/app/app_flutter_bunny.dart';

/// Main App widget that configures the application using Provider pattern.
class App extends StatelessWidget {
  /// Creates a new App instance.
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: dotenv.maybeGet('APP_NAME') ?? 'eco_locator',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode:
                Provider.of<ThemeProvider>(context).themeMode.toThemeMode(),
            home: const FlutterBunnyScreen(),
          );
        },
      ),
    );
  }
}
