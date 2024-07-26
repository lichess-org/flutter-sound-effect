import Flutter
import UIKit
import AVFoundation

public class SoundEffectPlugin: NSObject, FlutterPlugin {

  private var audioMap = [String : AVAudioPlayer]()
  private var registrar: FlutterPluginRegistrar? = nil

  public static func register(with registrar: FlutterPluginRegistrar) {
    let session: AVAudioSession = AVAudioSession.sharedInstance()
    do {
        try session.setCategory(AVAudioSession.Category.ambient,
            mode: AVAudioSession.Mode.default,
            options: [])
        try session.setPreferredIOBufferDuration(0.005)
        try session.setActive(true)
    } catch let error as NSError {
        print("Failed to set the audio session: \(error.localizedDescription)")
    }

    let channel = FlutterMethodChannel(name: "org.lichess/sound_effect", binaryMessenger: registrar.messenger())
    let instance = SoundEffectPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    instance.registrar = registrar
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "load":
        let args = call.arguments as! [String: Any]
        guard let audioId = args["soundId"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENT",
                                message: "Invalid soundId",
                                details: "Expect a 'soundId' String" ))
            return
        }

        guard let path = args["path"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENT",
                                message: "Invalid path",
                                details: "Expect a 'path' String" ))
            return
        }

        let player: AVAudioPlayer
        let resourceKey = registrar?.lookupKey(forAsset: path)
        let fullPath = Bundle.main.path(forResource: resourceKey, ofType: nil)!
        let pathUrl = URL(fileURLWithPath: fullPath)

        do {
            player = try AVAudioPlayer(contentsOf: pathUrl)
            player.prepareToPlay()
            audioMap[audioId] = player
        } catch {
            result(FlutterError(code: "LOAD_ERROR",
                                message: "Failed to load audio file",
                                details: nil ))
            return
        }

        result(nil)
    case "play":
        let args = call.arguments as! [String: Any]
        guard let audioId = args["soundId"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENT",
                                message: "Invalid soundId",
                                details: "Expect a 'soundId' String" ))
            return
        }

        guard let player = audioMap[audioId] else {
            result(FlutterError(code: "PLAY_ERROR",
                                message: "Invalid soundId",
                                details: "No audio player found for soundId: \(audioId)" ))
            return
        }

        let volume = args["volume"] as? Double ?? 1.0
        player.volume = Float(volume)

        player.play()
        result(nil)
    default:
        result(FlutterMethodNotImplemented)
    }
  }
}
