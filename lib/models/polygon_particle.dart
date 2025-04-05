import 'dart:math' as math;
import 'game_object.dart';
import 'player.dart';

class PolygonParticle extends GameObject {
  PolygonParticle({
    required super.position,
    required super.velocity,
    required this.vertices,
    required this.radius,
  });

  static const double minRadius = 20.0;
  static const double maxRadius = 80.0;
  static const double minSpeed = 1.0;
  static const double maxSpeed = 2.0;
  static const int minVertices = 5;
  static const int maxVertices = 8;

  final List<math.Point<double>> vertices;
  final double radius;

  static PolygonParticle random({
    required double screenWidth,
    required double screenHeight,
  }) {
    final random = math.Random();

    final position = math.Point(
      random.nextDouble() * screenWidth,
      random.nextDouble() * screenHeight,
    );

    final angle = random.nextDouble() * 2 * math.pi;
    final speed = minSpeed + random.nextDouble() * (maxSpeed - minSpeed);
    final velocity = math.Point(
      speed * math.cos(angle),
      speed * math.sin(angle),
    );

    final radius = minRadius + random.nextDouble() * (maxRadius - minRadius);

    final numVertices =
        minVertices + random.nextInt(maxVertices - minVertices + 1);

    final vertices = <math.Point<double>>[];
    final baseAngles =
        List.generate(numVertices, (i) => 2 * math.pi * i / numVertices);

    final angles = baseAngles.map((angle) {
      return angle + (random.nextDouble() - 0.5) * math.pi / numVertices;
    }).toList();

    for (final angle in angles) {
      final vertexRadius = radius * (0.8 + random.nextDouble() * 0.4);
      vertices.add(math.Point(
        vertexRadius * math.cos(angle),
        vertexRadius * math.sin(angle),
      ));
    }

    return PolygonParticle(
      position: position,
      velocity: velocity,
      vertices: vertices,
      radius: radius,
    );
  }

  @override
  bool collidesWith(GameObject other) {
    if (other is Player) {
      final dx = position.x - other.position.x;
      final dy = position.y - other.position.y;
      final distance = math.sqrt(dx * dx + dy * dy);
      return distance < radius + other.size / 2;
    }
    return false;
  }
}
