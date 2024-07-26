import 'package:flutter/material.dart';
import 'dart:async';

import 'package:sound_effect/sound_effect.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _soundEffectPlugin = SoundEffect();

  bool _soundLoaded = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    loadSounds();
  }

  Future<void> loadSounds() async {
    try {
      await _soundEffectPlugin.initialize();
      await _soundEffectPlugin.load('demo', 'assets/sounds/demo.mp3');
      setState(() {
        _soundLoaded = true;
      });
    } catch (e) {
      setState(() {
        _loadError = e.toString();
      });
    }
  }

  Future<void> releaseSounds() async {
    await _soundEffectPlugin.release();
  }

  @override
  void dispose() {
    super.dispose();
    releaseSounds();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SoundEffect example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_loadError != null)
                Text(_loadError!)
              else if (_soundLoaded) ...[
                ElevatedButton(
                  onPressed: () {
                    _soundEffectPlugin.play('demo');
                  },
                  child: const Text('Play sound'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _soundEffectPlugin.play('demo', volume: 0.3);
                  },
                  child: const Text('Play sound (30% volume)'),
                ),
              ] else
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
