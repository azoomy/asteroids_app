# Space Asteroids Game

A modern take on the classic Asteroids game built with Flutter, featuring smooth animations, polygon-based asteroids, and precise mouse controls.

## Features

- **Smooth Player Controls**: Control your spaceship with precise mouse movements
- **Dynamic Shooting Mechanics**: Click to shoot bullets at incoming asteroids
- **Polygon Asteroids**: Uniquely shaped asteroids with varying sizes (20-80 units) and vertices (5-8 sides)
- **Survival Timer**: Track your survival time in the asteroid field
- **Game Over Screen**: Shows your final survival time with a restart option
- **Performance Optimized**: Built with Flutter's CustomPainter for smooth rendering

## Game Mechanics

- **Player Movement**: Move your triangular spaceship by moving the mouse
- **Shooting**: Click anywhere to shoot bullets in the direction your ship is facing
- **Asteroids**: Dodge or destroy incoming polygon-shaped asteroids
- **Collision System**: Precise collision detection between bullets, player, and asteroids
- **Difficulty Scaling**: Maintains 5-15 asteroids in the field at all times

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Dart SDK (latest version)

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/space_asteroids_app.git
```

2. Navigate to the project directory
```bash
cd space_asteroids_app
```

3. Install dependencies
```bash
flutter pub get
```

4. Run the app
```bash
flutter run
```

## Technical Implementation

### Architecture

The game follows the MVC (Model-View-Controller) pattern:

- **Models**: 
  - Player: Handles spaceship movement and collision detection
  - Bullets: Manages projectile physics and collision
  - PolygonParticle: Implements asteroids with random shapes

- **View**: 
  - GameView: Renders game elements using CustomPainter
  - Handles user input and game over UI

- **Controller**: 
  - GameController: Manages game state, object spawning, and collision detection
  - Implements game loop and updates object positions

### Key Features

- **Asteroid Generation**: Random polygon shapes with 5-8 vertices
- **Collision Detection**: Distance-based collision system for accurate hit detection
- **Particle System**: Smooth movement and rotation of game objects
- **Performance**: Optimized rendering using Flutter's CustomPainter

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
