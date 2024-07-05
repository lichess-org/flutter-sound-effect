import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sound_effect_platform_interface.dart';

/// An implementation of [SoundEffectPlatform] that uses method channels.
class MethodChannelSoundEffect extends SoundEffectPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sound_effect');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
