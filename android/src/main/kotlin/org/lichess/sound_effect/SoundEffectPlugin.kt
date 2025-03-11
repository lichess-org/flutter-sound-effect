package org.lichess.sound_effect

import android.media.AudioAttributes
import android.media.SoundPool

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.StandardMethodCodec

class SoundEffectPlugin: FlutterPlugin, MethodCallHandler, SoundPool.OnLoadCompleteListener {
  companion object {
    private const val CHANNEL_NAME = "org.lichess/sound_effect"
  }

  private lateinit var channel : MethodChannel
  private lateinit var binding: FlutterPlugin.FlutterPluginBinding

  private var soundPool: SoundPool? = null
  private val audioMap = HashMap<String, Int>()

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val taskQueue =
      flutterPluginBinding.binaryMessenger.makeBackgroundTaskQueue()
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME, StandardMethodCodec.INSTANCE, taskQueue)
    binding = flutterPluginBinding
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "init" -> {
        if (soundPool !== null) {
          result.error("Already initialized", null, null)
          return
        }
        val maxStreams = call.argument<Int>("maxStreams") ?: 1
        soundPool = SoundPool.Builder()
                .setMaxStreams(maxStreams)
                .setAudioAttributes(
                  AudioAttributes.Builder()
                  .setUsage(AudioAttributes.USAGE_GAME)
                  .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                  .build()
                )
                .build()

        soundPool?.setOnLoadCompleteListener(this)

        result.success(null)
      }
      "load" -> {
        val audioId = call.argument<String>("soundId")
        val path = call.argument<String>("path")

        if (audioId === null) {
          result.error("Must supply a soundId", null, null)
          return
        }
        if (path === null) {
          result.error("Must supply a path", null, null)
          return
        }

        try {
          val assetPath = binding.flutterAssets.getAssetFilePathBySubpath(path)
          val afd = binding.applicationContext.assets.openFd(assetPath)
          audioMap[audioId] = soundPool!!.load(afd, 1)
          result.success(null)
        } catch (e: Exception) {
          result.error("Failed to load sound", e.message, null)
        }
      }
      "play" -> {
        val audioId = call.argument<String>("soundId")
        val volume = call.argument<Double>("volume")?.toFloat() ?: 1f

        if (audioId === null) {
          result.error("Must supply a soundId", null, null)
          return
        }

        val audio = audioMap[audioId]

        if (audio === null) {
          result.error("Sound not loaded", null, null)
          return
        }

        soundPool?.play(audio, volume, volume, 1, 0, 1f)

        result.success(null)
      }
      "release" -> {
        soundPool?.release()
        soundPool = null
        audioMap.clear()
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onLoadComplete(soundPool: SoundPool, sampleId: Int, status: Int) {
    val audioId = audioMap.filterValues { it == sampleId }.keys.firstOrNull()
    if (status == 0) {
      channel.invokeMethod("onLoadComplete", hashMapOf("soundId" to audioId))
    } else {
      channel.invokeMethod("onLoadError", hashMapOf("soundId" to audioId, "error" to status))
    }
  }
}
