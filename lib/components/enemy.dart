import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:game_challenge_2025feb/components/bullet.dart';
import 'package:game_challenge_2025feb/game.dart';

class Enemy extends SpriteComponent
    with HasGameReference<SpaceInvadersGame>, CollisionCallbacks {

  Enemy({super.position}) : super(
    size: Vector2.all(enemySize),
    anchor: Anchor.center,
  );

  static const enemySize = 75.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await game.loadSprite(
      'enemy.png',
    );

    add(RectangleHitbox());
  }

  

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * 250;

    if (position.y > game.size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Bullet) {
      effectHit();
      other.removeFromParent();

      Future.delayed(const Duration(milliseconds: 150), () {
      removeFromParent();
      });

    }
  }

  void effectHit() {
    // Play explosion sound
    FlameAudio.play('explosion.ogg', volume: 0.6);

    // Add effects
    final colorEffect = ColorEffect(
      const Color.fromARGB(255, 170, 25, 14),
      EffectController(duration: 0.2, alternate: true, repeatCount: 2),
    );

    final scaleEffect = ScaleEffect.to(
      Vector2(1.2, 1.2),
      EffectController(duration: 0.1, alternate: true, repeatCount: 2),
    );

    addAll([colorEffect, scaleEffect]);

    // Add explosion particle effect
    game.add(
      ParticleSystemComponent(
        position: position, // Use the enemy’s position for explosion
        particle: Particle.generate(
          count: 20, // Number of particles
          lifespan: 0.6, // Duration
          generator: (i) {
            final random = Random();
            return AcceleratedParticle(
              acceleration: Vector2(
                random.nextDouble() * 100 - 50,
                random.nextDouble() * 100 - 50,
              ),
              speed: Vector2(
                random.nextDouble() * 200 - 100,
                random.nextDouble() * 200 - 100,
              ),
              child: CircleParticle(
                radius: 3,
                paint: Paint()..color = Colors.orange,
              ),
            );
          },
        ),
      ),
    );
  }
}