import 'dart:math';
import 'package:flutter/material.dart';
import '../controllers/game_controller.dart';
import '../models/polygon_particle.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView>
    with SingleTickerProviderStateMixin {
  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  late final GameController _controller;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _animationController.addListener(_gameLoop);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!mounted) return;
    try {
      final size = MediaQuery.of(context).size;
      _controller = GameController(
        screenWidth: size.width,
        screenHeight: size.height,
      );
    } catch (e) {
      // Controller already initialized, ignore
    }
  }

  void _gameLoop() {
    setState(() {
      _controller.update();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (_) => _controller.shoot(),
        child: MouseRegion(
          onHover: (event) {
            _controller.onMouseMove(Point(
              event.localPosition.dx,
              event.localPosition.dy,
            ));
          },
          child: Stack(
            children: [
              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Timer: ${_formatTime(_controller.elapsedTime ?? DateTime.now().difference(_controller.startTime))}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              CustomPaint(
                painter: GamePainter(_controller),
                size: Size.infinite,
              ),
              if (_controller.isGameOver)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Game Over!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'You lasted ${_controller.elapsedTime!.inMinutes} mins and ${_controller.elapsedTime!.inSeconds % 60} seconds',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _controller.reset();
                              _animationController.reset();
                              _animationController.repeat();
                            });
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}

class GamePainter extends CustomPainter {
  GamePainter(this.controller);

  final GameController controller;

  @override
  void paint(Canvas canvas, Size size) {
    final bulletPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    for (final bullet in controller.bullets) {
      canvas.drawCircle(
        Offset(bullet.position.x, bullet.position.y),
        bullet.size / 2,
        bulletPaint,
      );
    }

    final particlePaint = Paint()..style = PaintingStyle.fill;

    for (final particle in controller.particles) {
      particlePaint.color = Colors.red.withOpacity(
        0.3 +
            (particle.radius - PolygonParticle.minRadius) /
                (PolygonParticle.maxRadius - PolygonParticle.minRadius) *
                0.7,
      );

      canvas.save();

      canvas.translate(particle.position.x, particle.position.y);

      final path = Path();
      if (particle.vertices.isNotEmpty) {
        path.moveTo(particle.vertices[0].x, particle.vertices[0].y);
        for (var i = 1; i < particle.vertices.length; i++) {
          path.lineTo(particle.vertices[i].x, particle.vertices[i].y);
        }
        path.close();
      }

      canvas.drawPath(path, particlePaint);

      canvas.restore();
    }

    final player = controller.player;
    final playerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.save();

    canvas.translate(player.position.x, player.position.y);
    canvas.rotate(player.rotation);

    final path = Path();
    final size = player.size;
    path.moveTo(size / 2, 0);
    path.lineTo(-size / 2, size / 2);
    path.lineTo(-size / 2, -size / 2);
    path.close();

    canvas.drawPath(path, playerPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(GamePainter oldDelegate) => true;
}
