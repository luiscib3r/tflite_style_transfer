#import "TfliteStyleTransferIosPlugin.h"
#if __has_include(<tflite_style_transfer_ios/tflite_style_transfer_ios-Swift.h>)
#import <tflite_style_transfer_ios/tflite_style_transfer_ios-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "tflite_style_transfer_ios-Swift.h"
#endif

@implementation TfliteStyleTransferIosPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTfliteStyleTransferIosPlugin registerWithRegistrar:registrar];
}
@end
