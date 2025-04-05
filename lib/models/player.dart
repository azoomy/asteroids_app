import 'dart:math';
import 'game_object.dart';

class Player extends GameObject {
  Player({
    required Point<double> position,
    Point<double> velocity = const Point(0, 0),
    double rotation = 0,
    this.size = 20.0,
  }) : super(
          position: position,
          velocity: velocity,
          rotation: rotation,
        );

  final double size;

  void moveTowards(Point<double> target) {
    final dx = target.x - position.x;
    final dy = target.y - position.y;

    rotation = atan2(dy, dx);

    position = target;
  }

  @override
  bool collidesWith(GameObject other) {
    final dx = position.x - other.position.x;
    final dy = position.y - other.position.y;
    final distance = sqrt(dx * dx + dy * dy);

    if (other is Player) {
      return distance < (size + other.size) / 2;
    }

    return distance < size / 2;
  }
}
