import Flutter
import UIKit

public class SwiftTfliteStyleTransferIosPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "tflite_style_transfer_ios", binaryMessenger: registrar.messenger())
    let instance = SwiftTfliteStyleTransferIosPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
