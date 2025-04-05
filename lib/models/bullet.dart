import 'dart:math';
import 'game_object.dart';
import 'polygon_particle.dart';

class Bullet extends GameObject {
  Bullet({
    required Point<double> position,
    required Point<double> velocity,
    required this.size,
  }) : super(
    position: position,
    velocity: velocity,
  );

  final double size;

  @override
  bool collidesWith(GameObject other) {
    if (other is! PolygonParticle) return false;

    final dx = position.x - other.position.x;
    final dy = position.y - other.position.y;
    final distance = sqrt(dx * dx + dy * dy);

    return distance < (size / 2 + other.radius);
  }
}