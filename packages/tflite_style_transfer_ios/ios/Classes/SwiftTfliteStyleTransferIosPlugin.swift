import Flutter
import UIKit

public class SwiftTfliteStyleTransferIosPlugin: NSObject, FlutterPlugin {
    /// Style transferer instance reponsible for running the TF model. Uses a Int8-based model and
    /// runs inference on the CPU.
    private var cpuStyleTransferer: StyleTransfer?
    
    /// Style transferer instance reponsible for running the TF model. Uses a Float16-based model and
    /// runs inference on the GPU.
    private var gpuStyleTransferer: StyleTransfer?
    
    private var flutterAssetsPath: String
    
    init(flutterAssetsPath: String) {
        self.flutterAssetsPath = flutterAssetsPath
        
        super.init()
        
        StyleTransfer.newCPUStyleTransferer {
            result in switch result {
            case .success(let transfer) :
                self.cpuStyleTransferer = transfer
            case .error(let wrappedError):
                print("Failed to initialize: \(wrappedError)")
            }
        }
        
        StyleTransfer.newGPUStyleTransferer {
            result in switch result {
            case .success(let transfer) :
                self.gpuStyleTransferer = transfer
            case .error(let wrappedError):
                print("Failed to initialize: \(wrappedError)")
            }
        }
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "tflite_style_transfer_ios", binaryMessenger: registrar.messenger()
        )
        
        let flutterAssetsPath = registrar.lookupKey(forAsset: "")
        
        let instance = SwiftTfliteStyleTransferIosPlugin(flutterAssetsPath: flutterAssetsPath)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS Plus" + UIDevice.current.systemVersion)
        case "runStyleTransfer":
            guard let arguments = call.arguments else {
                result(FlutterError(
                    code: "-1",
                    message: "iOS could not extract flutter arguments in method: (runStyleTransfer)",
                    details: nil
                ))
                
                return
            }
            
            if
                let args = arguments as? [String: Any],
                let styleImagePath = args["styleImagePath"] as? String,
                let imagePath  = args["imagePath"] as? String,
                let styleFromAssets = args["styleFromAssets"] as? Bool
            {
                runStyleTransfer(
                    styleImagePath: styleImagePath,
                    imagePath: imagePath,
                    styleFromAssets: styleFromAssets,
                    completion: {
                        generated in
                        switch generated {
                        case let .success(generatedPath):
                            result(generatedPath)
                        case let .error(error):
                            result(FlutterError(code: "-1", message: "\(error)", details: nil))
                        }
                    }
                )
                
                
            } else {
                result(FlutterError(
                    code: "-1",
                    message: "iOS could not extract flutter arguments in method: (runStyleTransfer)",
                    details: nil
                ))
                return
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func runStyleTransfer(
        styleImagePath: String,
        imagePath: String,
        styleFromAssets: Bool = false,
        completion: @escaping ((Result<String?>) -> Void)
    ) {
        let stylePath = styleFromAssets ?
        "\(Bundle.main.bundlePath)/\(flutterAssetsPath)\(styleImagePath)" :
        styleImagePath
        
        if
            let image =  UIImage(contentsOfFile: imagePath),
            let style =  UIImage(contentsOfFile: stylePath),
            (gpuStyleTransferer != nil || cpuStyleTransferer != nil)
        {
            // Run style transfer.
            if (gpuStyleTransferer != nil) {
                gpuStyleTransferer?.runStyleTransfer(
                    style: style,
                    image: image,
                    completion: { result in
                        // Show the result on screen
                        switch result {
                        case let .success(styleTransferResult):
                            let result = self.saveImage(styleTransferResult.resultImage)
                            completion(Result.success(result))
                        case let .error(error):
                            completion(Result.error(error))
                        }
                    }
                )
            } else {
                cpuStyleTransferer?.runStyleTransfer(
                    style: style,
                    image: image,
                    completion: { result in
                        // Show the result on screen
                        switch result {
                        case let .success(styleTransferResult):
                            let result = self.saveImage(styleTransferResult.resultImage)
                            completion(Result.success(result))
                        case let .error(error):
                            completion(Result.error(error))
                        }
                    }
                )
            }
            
        } else {
            completion(Result.error(StyleTransferError.notInterpreter))
        }
    }
    
    func saveImage(_ image: UIImage) -> String? {
        if let data = image.pngData() {
            var filename: URL
            
            if #available(iOS 10.0, *) {
                filename = FileManager.default.temporaryDirectory.appendingPathComponent(
                    "\(UUID().uuidString).png"
                )
            } else {
                filename = FileManager.default.urls(
                    for: .documentDirectory,
                       in: .userDomainMask
                )[0].appendingPathComponent(
                    "\(UUID().uuidString).png"
                )
                
            }
            
            try? data.write(to: filename)
            return filename.path
        }
        return nil
    }
}
