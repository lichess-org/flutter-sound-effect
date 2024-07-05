
import 'sound_effect_platform_interface.dart';

class SoundEffect {
  Future<String?> getPlatformVersion() {
    return SoundEffectPlatform.instance.getPlatformVersion();
  }
}
