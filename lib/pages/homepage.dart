import 'package:flutter/material.dart';
import 'home/home_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Green Snails'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const HomeBody(),
    );
  }
}
