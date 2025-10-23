import 'package:flutter/material.dart';

import 'package:eco_locator/core/design_system/theme_extension/app_theme_extension.dart';

class FlutterBunnyScreen extends StatefulWidget {
  const FlutterBunnyScreen({Key? key}) : super(key: key);

  @override
  State<FlutterBunnyScreen> createState() => _FlutterBunnyScreenState();
}

class _FlutterBunnyScreenState extends State<FlutterBunnyScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colors.surface,
      appBar: AppBar(
        title: Text(
          'Eco Locator',
          style: context.theme.fonts.headerLarger.copyWith(fontSize: 20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
