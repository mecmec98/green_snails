import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: auth.loading ? null : () => auth.signInWithGoogle(),
        icon: Image.asset(
          'assets/icons/google_g.png',
          width: 24,
          height: 24,
          errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata, size: 24),
        ),
        label: const Text('Sign in with Google'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          side: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
      ),
    );
  }
}
