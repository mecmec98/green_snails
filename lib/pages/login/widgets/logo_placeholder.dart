import 'package:flutter/material.dart';

class LogoPlaceholder extends StatelessWidget {
  const LogoPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Icon(
        Icons.eco_rounded,
        size: 64,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}
