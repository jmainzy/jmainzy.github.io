import 'package:flutter/material.dart';
import 'package:portfolio_website/routes.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Julia Mainzinger',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        textTheme: ThemeData.light().textTheme.copyWith(
              headlineLarge:
                  ThemeData.light().textTheme.headlineLarge!.copyWith(
                        fontSize: 24,
                      ),
            ),
        useMaterial3: true,
      ),
      routes: Routes().routes,
    );
  }
}
