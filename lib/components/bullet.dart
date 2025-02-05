import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:game_challenge_2025feb/game.dart';

class Bullet extends SpriteComponent with HasGameReference<SpaceInvadersGame> {
  
  Bullet({super.position}) : super(
    size: Vector2(25, 50),
    anchor: Anchor.center,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await game.loadSprite('bullet.png');
    add(RectangleHitbox(collisionType: CollisionType.passive));

    FlameAudio.play('laser.ogg', volume: 0.1);
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * -500;

    if (position.y < -height) {
      removeFromParent();
    }
  }
}