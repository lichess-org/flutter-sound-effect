import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sound_effect_method_channel.dart';

abstract class SoundEffectPlatform extends PlatformInterface {
  /// Constructs a SoundEffectPlatform.
  SoundEffectPlatform() : super(token: _token);

  static final Object _token = Object();

  static SoundEffectPlatform _instance = MethodChannelSoundEffect();

  /// The default instance of [SoundEffectPlatform] to use.
  ///
  /// Defaults to [MethodChannelSoundEffect].
  static SoundEffectPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SoundEffectPlatform] when
  /// they register themselves.
  static set instance(SoundEffectPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initialize() {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<void> load(String soundId, String path) {
    throw UnimplementedError('load() has not been implemented.');
  }

  Future<void> play(String soundId, {double volume = 1.0}) {
    throw UnimplementedError('play() has not been implemented.');
  }

  Future<void> release() {
    throw UnimplementedError('release() has not been implemented.');
  }
}
