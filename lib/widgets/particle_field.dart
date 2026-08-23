import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../theme/app_theme.dart';

/// Particle field visualization.
/// Dots rise from bottom to top. Count & speed scale with |mA|.
/// Smooth, minimal, no glow, no gradient.
class ParticleField extends StatefulWidget {
  final int currentMa;   // signed
  final bool active;     // charging?
  final double height;

  const ParticleField({
    super.key,
    required this.currentMa,
    required this.active,
    this.height = 180,
  });

  @override
  State<ParticleField> createState() => _ParticleFieldState();
}

class _Particle {
  double x;   // 0..1 across width
  double y;   // 0..1 (0 = bottom, 1 = top)
  double vy;  // upward velocity per frame (in normalized units)
  double size;
  double opacity;

  _Particle(this.x, this.y, this.vy, this.size, this.opacity);
}

class _ParticleFieldState extends State<ParticleField>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final List<_Particle> _particles = [];
  final Random _rng = Random();
  Duration _last = Duration.zero;
  double _spawnAccumulator = 0;

  @override
  void initState() {
    super.initState();
    _ticker = Ticker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    final dt = (_last == Duration.zero)
        ? 1 / 60
        : (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;

    // Map |mA| → target particles per second & velocity.
    // 0 mA => 0/s, 3000 mA => ~40/s.
    final mag = widget.currentMa.abs().clamp(0, 5000).toDouble();
    final rate = widget.active ? (mag / 75.0) : 0;      // spawns per second
    final baseVy = 0.10 + (mag / 5000.0) * 0.35;        // 0.10..0.45 per s

    _spawnAccumulator += rate * dt;
    while (_spawnAccumulator >= 1) {
      _spawnAccumulator -= 1;
      _spawn(baseVy);
    }

    // Advance existing particles
    for (final p in _particles) {
      p.y += p.vy * dt;
      // fade out near top
      if (p.y > 0.75) {
        p.opacity = ((1.0 - p.y) / 0.25).clamp(0.0, 1.0) * 0.9;
      }
    }
    _particles.removeWhere((p) => p.y >= 1.0);

    if (mounted) setState(() {});
  }

  void _spawn(double baseVy) {
    _particles.add(_Particle(
      _rng.nextDouble(),
      0.0,
      baseVy * (0.75 + _rng.nextDouble() * 0.5),
      1.5 + _rng.nextDouble() * 2.0,
      0.35 + _rng.nextDouble() * 0.55,
    ));
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: CustomPaint(
        painter: _ParticlePainter(_particles),
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final p in particles) {
      paint.color = AppColors.accent.withOpacity(p.opacity);
      final dx = p.x * size.width;
      final dy = size.height - (p.y * size.height);
      canvas.drawCircle(Offset(dx, dy), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => true;
}
