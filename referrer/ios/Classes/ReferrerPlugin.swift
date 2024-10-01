import Flutter
import UIKit

public class ReferrerPlugin: NSObject, FlutterPlugin {
  static let instance = ReferrerPlugin()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "referrer", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.addApplicationDelegate(instance)
  }

  private var latestReferrer: String?

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getReferrer":
      result(["referrer":latestReferrer])
    default:
      result(FlutterMethodNotImplemented)
    }
  }
    
    public func application(
      _ application: UIApplication,
      continue userActivity: NSUserActivity,
      restorationHandler: @escaping ([Any]) -> Void
    ) -> Bool {
        latestReferrer = userActivity.referrerURL?.absoluteString
      return false
    }
}