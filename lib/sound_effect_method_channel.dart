import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sound_effect_platform_interface.dart';

/// An implementation of [SoundEffectPlatform] that uses method channels.
class MethodChannelSoundEffect extends SoundEffectPlatform {
  final Map<String, Completer<void>> _completers = {};

  MethodChannelSoundEffect() {
    methodChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onLoadComplete':
          final soundId = call.arguments['soundId'];
          final completer = _completers[soundId];
          if (completer != null) {
            if (!completer.isCompleted) {
              completer.complete();
            }
            _completers.remove(soundId);
          }
          break;
        case 'onLoadError':
          final soundId = call.arguments['soundId'];
          final completer = _completers[soundId];
          if (completer != null) {
            if (!completer.isCompleted) {
              completer
                  .completeError(Exception('Failed to load sound $soundId'));
            }
            _completers.remove(soundId);
          }
          break;
        default:
          throw UnimplementedError('Method ${call.method} is not implemented');
      }
    });
  }

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('org.lichess/sound_effect');

  @override
  Future<void> initialize({required int maxStreams}) async {
    await methodChannel.invokeMethod<String>('init', <String, int>{
      'maxStreams': maxStreams,
    });
  }

  @override
  Future<void> load(String soundId, String path) async {
    if (Platform.isAndroid) {
      // On Android, we need to wait for the sound to be loaded.
      final completer = Completer<void>();
      _completers[soundId] = completer;
      await methodChannel.invokeMethod<String>(
          'load', <String, String>{'soundId': soundId, 'path': path});
      return completer.future;
    } else {
      await methodChannel.invokeMethod<String>(
          'load', <String, String>{'soundId': soundId, 'path': path});
    }
  }

  @override
  Future<void> play(String soundId, {double volume = 1.0}) async {
    await methodChannel.invokeMethod<String>(
        'play', <String, Object>{'soundId': soundId, 'volume': volume});
  }

  @override
  Future<void> release() async {
    _completers.clear();
    await methodChannel.invokeMethod<String>('release');
  }
}
