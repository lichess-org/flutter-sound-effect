import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sound_effect_platform_interface.dart';

/// An implementation of [SoundEffectPlatform] that uses method channels.
class MethodChannelSoundEffect extends SoundEffectPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('org.lichess/sound_effect');

  @override
  Future<void> initialize() async {
    await methodChannel.invokeMethod<String>('init');
  }

  @override
  Future<void> load(String soundId, String path) async {
    await methodChannel.invokeMethod<String>(
        'load', <String, String>{'soundId': soundId, 'path': path});
  }

  @override
  Future<void> play(String soundId, {double volume = 1.0}) async {
    await methodChannel.invokeMethod<String>(
        'play', <String, Object>{'soundId': soundId, 'volume': volume});
  }

  @override
  Future<void> release() async {
    await methodChannel.invokeMethod<String>('release');
  }
}
