import 'package:flutter/material.dart';

class FadeRoute<T> extends PageRouteBuilder<T> {
  FadeRoute({required Widget page})
    : super(
        transitionDuration: const Duration(milliseconds: 220),
        reverseTransitionDuration: const Duration(milliseconds: 180),
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      );
}
