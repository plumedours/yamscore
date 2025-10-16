import 'package:flutter/material.dart';

class PulseOnChange extends StatefulWidget {
  final Widget child;
  final Object watchKey; // change this object to trigger the pulse
  const PulseOnChange({super.key, required this.child, required this.watchKey});

  @override
  State<PulseOnChange> createState() => _PulseOnChangeState();
}

class _PulseOnChangeState extends State<PulseOnChange>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );
  late final Animation<double> _a = CurvedAnimation(
    parent: _c,
    curve: Curves.easeOutCubic,
  );

  Object? _prev;

  @override
  void didUpdateWidget(covariant PulseOnChange oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_prev != widget.watchKey) {
      _c.forward(from: 0);
      _prev = widget.watchKey;
    }
  }

  @override
  void initState() {
    super.initState();
    _prev = widget.watchKey;
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.04).animate(_a),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              blurRadius: 18 * _a.value,
              spreadRadius: -6 * _a.value,
              color: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.22 * _a.value),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}
