import 'dart:math';
import '../models/player.dart';
import '../models/polygon_particle.dart';
import '../models/bullet.dart';

class GameController {
  GameController({
    required this.screenWidth,
    required this.screenHeight,
  }) {
    player = Player(
      position: Point(
        screenWidth / 2,
        screenHeight / 2,
      ),
    );
    startTime = DateTime.now();
  }

  final double screenWidth;
  final double screenHeight;
  late final Player player;
  final List<PolygonParticle> particles = [];
  final List<Bullet> bullets = [];
  static const int minParticles = 5;
  static const int maxParticles = 15;
  static const double bulletSpeed = 10.0;
  static const double bulletSize = 5.0;
  bool isGameOver = false;
  late DateTime startTime;
  Duration? elapsedTime;

  void onMouseMove(Point<double> position) {
    if (isGameOver) return;
    player.moveTowards(position);
  }

  void shoot() {
    if (isGameOver) return;

    final bulletVelocity = Point(
      cos(player.rotation) * bulletSpeed,
      sin(player.rotation) * bulletSpeed,
    );

    bullets.add(Bullet(
      position: player.position,
      velocity: bulletVelocity,
      size: bulletSize,
    ));
  }

  void update() {
    if (isGameOver) return;

    player.update();

    for (var i = bullets.length - 1; i >= 0; i--) {
      final bullet = bullets[i];
      bullet.update();

      if (bullet.position.x < -50 ||
          bullet.position.x > screenWidth + 50 ||
          bullet.position.y < -50 ||
          bullet.position.y > screenHeight + 50) {
        bullets.removeAt(i);
        continue;
      }

      for (var j = particles.length - 1; j >= 0; j--) {
        if (bullet.collidesWith(particles[j])) {
          particles.removeAt(j);
          bullets.removeAt(i);
          break;
        }
      }
    }

    for (var i = particles.length - 1; i >= 0; i--) {
      final particle = particles[i];
      particle.update();

      if (particle.collidesWith(player)) {
        isGameOver = true;
        elapsedTime = DateTime.now().difference(startTime);
        return;
      }

      if (particle.position.x < -50 ||
          particle.position.x > screenWidth + 50 ||
          particle.position.y < -50 ||
          particle.position.y > screenHeight + 50) {
        particles.removeAt(i);
      }
    }

    // Spawn new particles if needed
    while (particles.length < minParticles) {
      particles.add(PolygonParticle.random(
        screenWidth: screenWidth,
        screenHeight: screenHeight,
      ));
    }
  }

  void reset() {
    isGameOver = false;
    startTime = DateTime.now();
    elapsedTime = null;
    player.position = Point(
      screenWidth / 2,
      screenHeight / 2,
    );
    particles.clear();
    bullets.clear();
    for (var i = 0; i < minParticles; i++) {
      particles.add(PolygonParticle.random(
        screenWidth: screenWidth,
        screenHeight: screenHeight,
      ));
    }
  }
}
