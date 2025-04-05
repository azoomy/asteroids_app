import 'package:flutter/material.dart';
import 'views/game_view.dart';

void main() {
  runApp(const AsteroidsGame());
}

class AsteroidsGame extends StatelessWidget {
  const AsteroidsGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Asteroids Game',
      theme: ThemeData.dark(),
      home: const Scaffold(
        body: GameView(),
      ),
    );
  }
}
