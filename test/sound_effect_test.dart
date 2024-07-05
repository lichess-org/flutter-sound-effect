import 'package:flutter_test/flutter_test.dart';
import 'package:sound_effect/sound_effect.dart';
import 'package:sound_effect/sound_effect_platform_interface.dart';
import 'package:sound_effect/sound_effect_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSoundEffectPlatform
    with MockPlatformInterfaceMixin
    implements SoundEffectPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SoundEffectPlatform initialPlatform = SoundEffectPlatform.instance;

  test('$MethodChannelSoundEffect is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSoundEffect>());
  });

  test('getPlatformVersion', () async {
    SoundEffect soundEffectPlugin = SoundEffect();
    MockSoundEffectPlatform fakePlatform = MockSoundEffectPlatform();
    SoundEffectPlatform.instance = fakePlatform;

    expect(await soundEffectPlugin.getPlatformVersion(), '42');
  });
}
