import 'dart:math';

/// Base class for all game objects (player, asteroids, bullets)
abstract class GameObject {
  GameObject({
    required this.position,
    required this.velocity,
    this.rotation = 0,
  });

  Point<double> position;

  Point<double> velocity;

  double rotation;

  void update() {
    position = Point(
      position.x + velocity.x,
      position.y + velocity.y,
    );
  }

  bool collidesWith(GameObject other);
}
