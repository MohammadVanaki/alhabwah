import 'package:flutter/material.dart';

class RawafidLoading extends StatelessWidget {
  const RawafidLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.onPrimary,
            strokeWidth: 2,
          ),
          const SizedBox(height: 16),
          const Text('جاري التحميل...'),
        ],
      ),
    );
  }
}
