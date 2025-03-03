import 'package:flutter/material.dart';
import 'package:fluit/fluit.dart';

void main() async {
  await initFluit();
  runApp(const FluitStudio());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const FluitStudio();
  }
}