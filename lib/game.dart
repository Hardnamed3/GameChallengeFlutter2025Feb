import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:game_challenge_2025feb/components/enemy.dart';
import 'package:game_challenge_2025feb/components/player.dart';

class SpaceInvadersGame extends FlameGame with PanDetector, HasCollisionDetection {
  late Player player;
  late AudioPool bulletPool;
  late AudioPool explosionPool;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // sounds
    startBgmMusic();

    // Background stars
    final parallax = await loadParallaxComponent(
      [
        ParallaxImageData('stars1.png'),
        ParallaxImageData('stars2.png'),
      ],
      baseVelocity: Vector2(0, -5),
      repeat: ImageRepeat.repeat,
      velocityMultiplierDelta: Vector2(0, 5),
    );
    add(parallax);

    // Player
    player = Player();
    add(player);

    // Enemy spawner
    add(
      SpawnComponent(
        factory: (index) {
          return Enemy();
        },
        period: 1,
        area: Rectangle.fromLTWH(0, 0, size.x, -Enemy.enemySize),
      ),
    );
  }

  void startBgmMusic(){
    FlameAudio.bgm.initialize();
    //FlameAudio.loop('background_music.mp3', volume:0.1);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.global);
  }

  @override
  void onPanStart(DragStartInfo info) {
    player.startShooting();
  }

  @override
  void onPanEnd(DragEndInfo info) {
    player.stopShooting();
  }

}