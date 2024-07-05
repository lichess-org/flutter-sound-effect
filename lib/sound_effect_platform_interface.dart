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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
