import 'dart:math' as math;
import 'game_object.dart';
import 'player.dart';

class Particle extends GameObject {
  Particle({
    required super.position,
    required super.velocity,
    required this.size,
  });

  static const double minSize = 20.0;
  static const double maxSize = 80.0;
  static const double minSpeed = 1.0;
  static const double maxSpeed = 3.0;

  final double size;

  static Particle random({
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

    final size = minSize + random.nextDouble() * (maxSize - minSize);

    return Particle(
      position: position,
      velocity: velocity,
      size: size,
    );
  }

  @override
  bool collidesWith(GameObject other) {
    if (other is Player) {
      final dx = position.x - other.position.x;
      final dy = position.y - other.position.y;
      final distance = math.sqrt(dx * dx + dy * dy);

      // Circular collision detection
      return distance < (size + other.size) / 2;
    }
    return false;
  }
}
