import 'sound_effect_platform_interface.dart';

class SoundEffect {
  Future<void> load(String soundId, String path) {
    return SoundEffectPlatform.instance.load(soundId, path);
  }

  Future<void> play(String soundId, [double volume = 1.0]) {
    return SoundEffectPlatform.instance.play(soundId);
  }
}
