import 'sound_effect_platform_interface.dart';

/// A class that provides an API to play sound effects with low latency.
class SoundEffect {
  /// Initializes the sound effect plugin.
  ///
  /// [maxStreams] is the maximum number of sound streams that can be played simultaneously.
  ///
  /// This method must be called before any other methods.
  Future<void> initialize({int maxStreams = 1}) {
    return SoundEffectPlatform.instance.initialize(maxStreams: maxStreams);
  }

  /// Loads a sound effect from an asset file.
  ///
  /// [soundId] is a unique identifier for the sound effect.
  /// [path] is the path to the asset file (e.g. "assets/sound.mp3").
  Future<void> load(String soundId, String path) {
    return SoundEffectPlatform.instance.load(soundId, path);
  }

  /// Plays a sound effect.
  Future<void> play(String soundId, {double volume = 1.0}) {
    return SoundEffectPlatform.instance.play(soundId, volume: volume);
  }

  /// Releases the sound effect plugin resources.
  ///
  /// Once this method is called, the plugin can no longer be used until the
  /// [initialize] method is called again.
  Future<void> release() {
    return SoundEffectPlatform.instance.release();
  }
}
