## 0.1.2

- Fix a potential crash on Android due to a java.util.ConcurrentModificationException

## 0.1.1

- Run android platform side handlers in a background thread.

## 0.1.0

- Allow playing multiple sounds at the same time, with the `maxStreams`
  parameter in `initialize`.
- Run iOS platform side handlers in a background thread.

## 0.0.2

- Make sure the sound is loaded when `load`'s Future is resolved on Android.

## 0.0.1

Initial release:
- Added `load` function to load a sound file from a path
- Added `play` function to play a sound
